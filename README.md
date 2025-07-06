# SigmaHome

Aplikasi Smart Home berbasis Flutter yang menghubungkan aplikasi mobile dengan microcontroller melalui Firebase (Realtime Database & Firestore). Mendukung ESP8266, ESP32, dan semua 32-bit MCU (kecuali Atmel AVR). Detail versi sigma home [disini](https://github.com/Ariyalex/SigmaHome/releases)

---

## Fitur Utama
- **Autentikasi**: Email/password & Google OAuth (REST API, token, session, SharedPreferences)
- **Manajemen Device**: Tambah, edit, hapus, toggle status device via REST API
- **Polling Device**: Status device diperbarui dengan polling HTTP
- **Manajemen User**: Edit profil, ganti username (via REST API)
- **Remote Config**: Cek versi aplikasi & update via Firebase Remote Config
- **UI Modern**: GetX, custom theme, widget modular
- **Cuaca Terkini**: Menampilkan cuaca berdasarkan lokasi user menggunakan OpenWeatherMap
- **Integrasi Microcontroller**: Microcontroller dapat mengakses database menggunakan library FirebaseConsole arduino

---

## Microcontroller Support
- ESP8266
- ESP32
- Semua 32-bit MCU (kecuali Atmel AVR)

---

## Struktur Project
- `lib/` - Source code utama Flutter
- `lib/src/controllers/` - GetX controller (auth, device, dsb)
- `lib/src/models/` - Model data (device, user, dsb)
- `lib/src/screens/` - Halaman UI (home, about, auth, dsb)
- `lib/src/widgets/` - Widget custom
- `android/` - Kode native Android & konfigurasi Firebase
- `assets/` - Gambar, font, dsb

---

## Getting Started

1. Clone repo ini
2. Buat project di Firebase Console, download `google-services.json` ke folder `android/app/`
3. Konfigurasi firebase dengan project flutter
5. Buat api OpenWeatherMap untuk info cuaca dan letakkan pada library
6. Jalankan:
   ```bash
   flutter pub get
   flutter run
   ```
7. Konfigurasi rules Firestore & Realtime Database sesuai kebutuhan keamanan
8. Untuk microcontroller, gunakan contoh kode pada [example](https://github.com/Ariyalex/SigmaHome/tree/main/example)

---

## Tutorial Setting Microcontroller (ESP8266/ESP32)

### 1. Siapkan Library
- Install library berikut di Arduino IDE / PlatformIO:
  - `Firebase ESP8266` atau `Firebase ESP32`
  - `WiFi` / `WiFiClientSecure`
  - `ArduinoJson`
  - `ArduinoHttpClient`

### 2. Buat kode arduino sesuai [Example](https://github.com/Ariyalex/SigmaHome/blob/main/example/sigmaHome.ino)

### 3. Tips
- Ganti bebrapa token atau path sesuai dengan detail device pada aplikasi
- Pastikan fungsi http request untuk mendapatkan id token ada, ini penting karena hanya refresh token yang disediakan.
- Ubah fungsi processData sesuai kebutuhan, fungsi ini merupakan core dari microcontroller.

---

## Dokumentasi & Bantuan
- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase for Flutter](https://firebase.flutter.dev)
- [Firebase Client](https://github.com/mobizt/FirebaseClient)
- [GetX](https://pub.dev/packages/get)
- [Weather Library](https://pub.dev/packages/weather)

---

> Project ini sudah selesai. Silakan gunakan, modifikasi, dan kontribusi!
