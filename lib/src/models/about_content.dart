class AboutContent {
  static const Map<String, String> perkenalan = {
    "title": "Apa itu SigmaHome?",
    "description1":
        "SigmaHome adalah aplikasi smart home berbasis IoT, jadi semua device yang akan dibuat oleh pengguna bisa dikontrol layaknya remote melalui aplikasi ini secara real time.",
    "description2":
        "Device dibuat secara mandiri dengan langkah-langkah yang dijelaskan di repository github. Template code dan contoh rangkaian tersedia di reposiory juga, silahkan kembangkan code dan rangkaian sesuai kebutuhan.",
  };

  static const Map<String, dynamic> caraKerja = {
    "title": "Bagaimana cara SigmaHome berkerja?",
    "content": <String>[
      "User login untuk dapat mengakses realtime database dan dapat menambahkan device",
      "Ketika device ditambahkan, aplikasi akan generate Device ID yang nantinya akan digunakan untuk code IoT.",
      "Setelah rangkaian dan code sudah berhasil diatur, pengguna bisa mengontrol device secara online dan realtime menggunakan SigmaHome.",
    ],
  };

  static const Map<String, dynamic> langkahPenggunaan = {
    "title": "Langkah-langkah penggunaan",
    "content": <String>[
      "Register dan login",
      "Buat device baru dan pilih rooms device",
      "Gunakan device id yang digenerate untuk code microcontroller",
      "Gunakan Email dan Password untuk auth pada microcontroller",
      "Setup microcontoller sesuai contoh kode pada repository github",
      "Device telah dibuat dan bisa dicontroll lewat SigmaHome",
    ],
  };
}
