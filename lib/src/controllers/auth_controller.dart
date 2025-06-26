import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  //text editing controller
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();
  final username = TextEditingController();

  RxnBool terms = RxnBool();
  RxBool isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rxn<User> _user = Rxn<User>();

  User? get user => _user.value;

  bool get isLoggedin => user != null;

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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw "login dibatalkan pengguna";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      if (_user.value != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("userId", _user.value!.uid);
      }
    } catch (error) {
      throw "gagal login menggunakan google: $error";
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _user.value = null;

      //clear preferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("hasLoggedIn", false);
      await pref.remove("userId");
    } catch (error) {
      throw ("error saat logout: $error");
    }
  }
}
