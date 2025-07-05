// sigma home hanya support ESP8266, ESP32 and all 32-bit MCU except for Atmel AVR. karena library FirebaseClient hanya supprot itu saja
// ini adalah contoh kode esp32 untuk on off relay, karena memang sigmaHome hanya support output boolean
// contoh rangkaian bisa dilihat di foto yang tercantum di folder ini

// install semua library arduino
#include <WiFi.h>              //bawaan arduino
#include <WiFiClientSecure.h>  //bawaan arduino
#include <FirebaseClient.h>    //FirebaesClient by Mobizt (digunakan untuk menyambungkan microcontroller dengan firebase)
#include <ArduinoJson.h>       //ArduinoJson by Blanchon (parsing json hasil http request)
#include <ArduinoHttpClient.h> //ArduinoHttpClient by Arduino (digunakan untuk http request id token)

//
#define WIFI_SSID "YOUR_WIFI_NAME"
#define WIFI_PASSWORD "YOUR_WIFI_PASS"
#define RELAY_PIN 13 // ganti sesuai relay pin yang anda gunakan

// konfigrasi enable id token auth dan realtime database
#define ENABLE_ID_TOKEN
#define ENABLE_DATABASE

#define API_KEY "API_KEY"             // api key didapat di detail device
#define REFRESH_TOKEN "REFRESH_TOKEN" // Refresh token didapat dari detail device
#define DATABASE_URL "DATABASE_URL"   // database url didapat dari detail device

// ini untuk httpClient
const char serverAddress[] = "securetoken.googleapis.com"; // address untuk mendapatkan id token
int port = 443;                                            // port digunankan untuk http req (443 untuk http)

String idToken;                // definisikan idToken
unsigned long tokenExpire = 0; // definisi tokenExpire yang nanti akan diisi melalui http req

// inisialisasi wifi dan httpClient
WiFiClientSecure ssl_client;
HttpClient client = HttpClient(ssl_client, serverAddress, port); // http client untuk http request

// konfigurasi firebase (detailnya bisa dibaca pada dokumentasi library FirebaseClient)
using AsyncClient = AsyncClientClass;
AsyncClient aClient(ssl_client);
FirebaseApp app;
RealtimeDatabase DB;
AsyncResult streamResult;

// definisi IDToken auth (dibuat null, akan didefinisikan ulang pada setup setelah fungsi refreshIdToken dijalankan)
IDToken *user_auth_ptr = nullptr;

// definisi fungsi yang digunakan
void refreshIdToken();                  // http req untuk mendapatkan idToken
void processData(AsyncResult &aResult); // untuk process data realtime database

// mulai setup (setup seperti biasa dijalankan sekali)
void setup()
{
  Serial.begin(115200);

  // connect microcontroller ke wifi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWi-Fi connected");

  // klien SSL tidak akan memverifikasi sertifikat server saat melakukan koneksi HTTPS
  ssl_client.setInsecure(); // jika ingin lebih aman, anda bisa memverifikasi sertifikat server dengan kode di bawah
  // ssl_client.setTrustAnchors(&cert); //cari tahu sendiri cara mendapatkan sertifikat gimana
  ssl_client.setTimeout(60);
  ssl_client.setHandshakeTimeout(30);

  // jalankan fungsi untuk mendapatkan id token dan token expire
  refreshIdToken();

  // cek apakah fungsi tadi berhasil mendapatkan id token atau tidak
  if (idToken == "")
  {
    Serial.println("Gagal mendapatkan ID Token");
    return;
  }

  // inisialiasasi IDToken auth baru menggunakan API_KEY, id token, token expire, dan REFRESH_TOKEN
  user_auth_ptr = new IDToken(API_KEY, idToken, tokenExpire, REFRESH_TOKEN);

  // initsialisasi firebase auth (selengkapnya bisa dibaca pada dokumentasi FirebaseClient)
  initializeApp(aClient, app, getAuth(*user_auth_ptr), 10);

  // inisialisasi realtime database
  app.getApp<RealtimeDatabase>(DB);
  DB.url(DATABASE_URL);

  // cek apakah realtime database berhasil diinisialisasi
  if (!app.isInitialized())
  {
    Serial.println("Firebase App gagal diinisialisasi.");
    return;
  }

  // inisialisasi awal relay dibuat menyala
  //  pinMode(RELAY_PIN, OUTPUT);
  //  digitalWrite(RELAY_PIN, LOW);

  Serial.println("Firebase siap, mendapatkan data...");

  // untuk listen realtime database berdasarkan path yang didapat di detail device
  // processData adalah fungsi untuk memprosses output dari getter yaitu nilai dari path
  // untuk memahami bagaimana kode ini berkerja bisa dibaca dokumentasi FirebaseDatabase
  DB.get(aClient, "PATH", processData, true);
}

void loop()
{
  // untuk maintain authentication
  app.loop();
}

// fungsi untuk mendapatkan id token menggunakan refresh token
// jangan ubah kode ini jika nggak pengen error (klo anda jago dan bisa mengoptimalkan fungsi ini silahkan diubah)
void refreshIdToken()
{

  String url = "/v1/token?key=" + String(API_KEY);
  String postData = "grant_type=refresh_token&refresh_token=" + String(REFRESH_TOKEN);

  client.beginRequest();
  client.post(url.c_str());
  client.sendHeader("Content-Type", "application/x-www-form-urlencoded");
  client.sendHeader("Content-Length", postData.length());
  client.beginBody();
  client.print(postData);
  client.endRequest();

  int statusCode = client.responseStatusCode();
  String body = client.responseBody();

  Serial.print("Status code: ");
  Serial.println(statusCode);
  Serial.println("Response body:");
  Serial.println(body);
  Serial.print("Response length: ");
  Serial.println(body.length());

  // Cek apakah response kosong atau terpotong
  if (body.length() == 0)
  {
    Serial.println("Response kosong!");
    return;
  }

  // Increase JSON document size untuk handle response yang besar
  DynamicJsonDocument doc(8192); // Naikkan ke 8KB
  DeserializationError error = deserializeJson(doc, body);

  if (error)
  {
    Serial.print("Gagal parsing response: ");
    Serial.println(error.f_str());
    Serial.println("Raw response:");
    Serial.println(body);
    return;
  }

  if (!doc.containsKey("id_token"))
  {
    Serial.println("Response tidak mengandung id_token");
    if (doc.containsKey("error"))
    {
      Serial.print("Error: ");
      Serial.println(doc["error"]["message"].as<String>());
    }
    return;
  }

  idToken = doc["id_token"].as<String>();
  tokenExpire = doc["expires_in"].as<unsigned long>();

  Serial.println("ID Token berhasil diperbarui");
  Serial.print("Token expire dalam: ");
  Serial.print(tokenExpire);
  Serial.println(" detik");
  Serial.print("ID Token length: ");
  Serial.println(idToken.length());
}

// fungsi untuk memproses output dari realtime database
void processData(AsyncResult &aResult)
{
  // klo nggak ada resultnya langsung keluar, bisa juga dikasih debugging klo ternyata error
  if (!aResult.isResult())
    return;

  if (aResult.available())
  {
    // mengubah realtime database result ke string (bisa kamu ubah ke bool karena hasilnya sebenarnya bool)
    RealtimeDatabaseResult &RTDB = aResult.to<RealtimeDatabaseResult>();
    String result = RTDB.to<String>();

    // jika true maka ubah relay menjadi low yang berarti arus listriknya mengalir
    if (result == "true")
    {
      digitalWrite(RELAY_PIN, LOW);
      Serial.println("\u25B6 Relay status: ON");
    }

    // klo false ubah relay jadi high yang berardu arus listriknya distop relay
    else if (result == "false")
    {
      digitalWrite(RELAY_PIN, HIGH);
      Serial.println("\u25B6 Relay status: OFF");
    }
    // klo hasilnya null ya tidak melakukan apa apa
    else if (result == "null")
    {
      Serial.println("\u25B6 relay null");
    }
  }
}