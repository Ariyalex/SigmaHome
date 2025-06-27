import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_home/src/models/user_model.dart';

class AuthController extends GetxController {
  //text editing controller
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();
  final username = TextEditingController();

  RxnBool terms = RxnBool();
  RxBool isLoading = false.obs;
  RxBool isLoadingGoogle = false.obs;

  final Rxn<UserModel> userData = Rxn<UserModel>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("users");

  final Rxn<User> _user = Rxn<User>();

  User? get user => _user.value;

  bool get isLoggedin => user != null;

  final RxBool _initialized = false.obs;
  @override
  bool get initialized => _initialized.value;

  /// Inisialisasi autentikasi dan status user saat aplikasi dijalankan
  Future<void> initializedAuth() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Jika user sudah login, set user dan simpan ke preferences
        _user.value = currentUser;
        debugPrint("auth initialized with user: ${currentUser.uid}");

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setBool("hasLoggedIn", true);
        await pref.setString("userId", currentUser.uid);

        // Ambil data user dari Firestore
        await getUserData(_user.value!.uid);
      } else {
        // Jika belum login, coba load user dari preferences
        await _loadUserFromPreferences();
      }

      // Dengarkan perubahan status autentikasi
      _auth.authStateChanges().listen(
        (User? firebaseUser) async {
          if (firebaseUser != null &&
              (_user.value == null || _user.value?.uid != firebaseUser.uid)) {
            // Jika ada user baru login, update user dan preferences
            _user.value = firebaseUser;
            debugPrint("auth state changed: user = ${firebaseUser.uid}");

            await _saveUserToPreferences(firebaseUser);

            // Ambil data user dari Firestore
            await getUserData(_user.value!.uid);
          } else if (firebaseUser == null && _user.value != null) {
            // Jika user logout, reset user
            _user.value = null;
            print("auth state changed: user logged out");
            userData.value = null;
          }
        },
      );

      _initialized.value = true;
    } catch (error) {
      debugPrint("error initializing auth: $error");
      _initialized.value = true;
    }
  }

  Future<void> _saveUserToPreferences(User user) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", true);
      await pref.setString("userId", user.uid);
      print("User saved to preferences: ${user.uid}");
    } catch (e) {
      print("Error saving user to preferences: $e");
    }
  }

  Future<void> _loadUserFromPreferences() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      bool hasLoggedIn = pref.getBool("hasLoggedIn") ?? false;
      String? userId = pref.getString("userId");

      if (hasLoggedIn && userId != null) {
        if (_auth.currentUser != null) {
          _user.value = _auth.currentUser;
          debugPrint("user loaded form firebase auth: ${_user.value?.uid}");
        } else {
          debugPrint("trying to recover session for userid: $userId");
        }
      } else {
        debugPrint("no logged in user found in preferences");
      }
    } catch (error) {
      debugPrint("error loading user from preferences: $error");
    }
  }

  Future<void> getUserData(String uid) async {
    try {
      QuerySnapshot snapshot =
          await _userCollection.where("uid", isEqualTo: uid).get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        userData.value =
            UserModel(uid: data["uid"], username: data["username"]);
        debugPrint("User data loaded: ${userData.value?.username}");
      } else {
        userData.value = null;
        debugPrint("No user data found in Firestore");
      }
    } catch (error) {
      debugPrint("Error getting user data: $error");
      userData.value = null;
    }
  }

  //sign in method
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user.value = userCredential.user;

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", true);
      if (_user.value != null) {
        await pref.setString("userId", _user.value!.uid);
        debugPrint("user id saved to preferences; ${_user.value!.uid}");
      }

      await getUserData(_user.value!.uid);
    } on FirebaseAuthException catch (error) {
      String errorMessage;

      switch (error.code) {
        case "invalid-credential":
          errorMessage = 'Email atau password yang anda masukkan salah';
          break;
        case "too-many-requests":
          errorMessage = "Terlalu banyak percobaan login. Coba lagi nanti.";
          break;
        case "network-request-failed":
          errorMessage = "Tidak ada koneksi internet. Periksa jaringan Anda.";
          break;
        case "invalid-email":
          errorMessage = "Email tidak valid";
        default:
          errorMessage = "Terjadi kesalahan saat login. Silakan coba lagi.";
      }
      throw errorMessage;
    } catch (error) {
      throw ("terjadi kesalahan yang tidak diketahui");
    }
  }

  //sign up method
  Future<void> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //menyimpan data user ke firestore
      await FirebaseFirestore.instance.collection("users").doc(email).set({
        "uid": userCredential.user!.uid,
        "username": username,
      });
    } on FirebaseAuthException catch (error) {
      String errorMessage;

      switch (error.code) {
        case "invalid-email":
          errorMessage = 'Format email tidak valid';
          break;
        case "too-many-requests":
          errorMessage = "Terlalu banyak percobaan login. Coba lagi nanti.";
          break;
        case "network-request-failed":
          errorMessage = "Tidak ada koneksi internet. Periksa jaringan Anda.";
          break;
        case "email-already-in-use":
          throw "Email sudah dipakai, gunakan email yang lain";
        default:
          errorMessage = "Terjadi kesalahan saat Sign up. Silakan coba lagi.";
      }
      throw errorMessage;
    } catch (error) {
      throw ("terjadi kesalahan yang tidak diketahui");
    }
  }

  //sign in menggunakan google
  Future<void> signInWithGoogle() async {
    try {
      isLoadingGoogle.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw "Login dibatalkan pengguna";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      _user.value = userCredential.user;

      if (_user.value != null) {
        // Simpan di SharedPreferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setBool("hasLoggedIn", true);
        await pref.setString("userId", _user.value!.uid);

        // Simpan/Update di Firestore
        await _userCollection.doc(googleUser.email).set({
          "uid": _user.value!.uid,
          "username": googleUser.displayName ?? "User",
        }, SetOptions(merge: true));

        // Get user data
        await getUserData(_user.value!.uid);

        debugPrint("Google Sign-In berhasil: ${_user.value!.email}");
      }
    } on PlatformException catch (error) {
      String errorMessage;
      if (error.code == 'sign_in_failed') {
        if (error.message?.contains('10') == true) {
          errorMessage =
              "Konfigurasi Google Sign-In belum benar. Hubungi developer.";
        } else {
          errorMessage = "Gagal login dengan Google. Coba lagi.";
        }
      } else {
        errorMessage = "Error: ${error.message}";
      }
      throw errorMessage;
    } catch (error) {
      throw "Gagal login menggunakan Google: $error";
    } finally {
      isLoadingGoogle.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _user.value = null;
      userData.value = null;

      //clear preferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", false);
      await pref.remove("userId");
    } catch (error) {
      throw ("error saat logout: $error");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      var snapshot = await _userCollection.doc(email.trim()).get();
      if (!snapshot.exists) {
        throw "Email tidak terdaftar. Silahkan periksa kembali.";
      }

      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw error.message ??
          "Terjadi kesalahan saat mengirim email reset password.";
    } catch (error) {
      rethrow;
    }
  }
}
