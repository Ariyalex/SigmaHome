import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_home/firebase_options.dart';
import 'package:sigma_home/src/models/user_model.dart';
import 'package:sigma_home/src/theme/theme.dart';

class AuthController extends GetxController {
  final Rxn<UserModel> userData = Rxn<UserModel>();

  //token dan session
  RxString idToken = "".obs;
  RxString refreshTkn = "".obs;

  String? dataUsername;
  //text editing controller
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();
  final username = TextEditingController();

  RxnBool terms = RxnBool();
  RxBool isLoading = false.obs;
  RxBool isLoadingGoogle = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final List<String> scopes = <String>['email', 'profile'];

  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection("users");

  final RxBool _initialized = false.obs;
  @override
  bool get initialized => _initialized.value;

  // ✅ Update isLoggedin getter karena tidak pakai Firebase Auth User object
  bool get isLoggedin {
    // Check dari SharedPreferences instead of Firebase Auth
    return _isUserLoggedIn();
  }

  /// Inisialisasi autentikasi dan status user saat aplikasi dijalankan
  Future<void> initializedAuth() async {
    try {
      // ✅ Load dari SharedPreferences instead of Firebase Auth
      await _loadCachedUserData();

      if (_cachedUserId != null && _cachedUserEmail != null) {
        debugPrint("Auth initialized with cached user: $_cachedUserId");

        // ✅ Load stored tokens
        SharedPreferences pref = await SharedPreferences.getInstance();
        idToken.value = pref.getString("idToken") ?? "";
        refreshTkn.value = pref.getString("refreshToken") ?? "";

        if (idToken.value.isNotEmpty) {
          //validasi token
          bool isTokenValid = await _validateTokenWithFirebase();

          if (isTokenValid) {
            // ✅ Get user data dari Firestore
            await getUserData(_cachedUserEmail!);
            dataUsername = userData.value?.username;
            username.text = dataUsername ?? "";

            debugPrint("✅ User session restored successfully");
          } else {
            debugPrint("⚠️ Token invalid, trying to refresh...");

            try {
              await refreshIdToken();

              // ✅ Setelah refresh berhasil, load user data
              await getUserData(_cachedUserEmail!);
              dataUsername = userData.value?.username;
              username.text = dataUsername ?? "";

              debugPrint("✅ Token refreshed and user session restored");
            } catch (refreshError) {
              debugPrint("❌ Token refresh failed: $refreshError");

              // ✅ Clear invalid session
              await _clearInvalidSession();
              debugPrint("⚠️ Session cleared, user needs to re-login");
            }
          }
        } else {
          debugPrint("⚠️ No valid token found, user needs to re-login");
        }
      } else {
        debugPrint("No cached user found");
      }

      _initialized.value = true;
    } catch (error) {
      debugPrint("Error initializing auth: $error");
      await _clearInvalidSession();
      _initialized.value = true;
    }
  }

  Future<void> getUserData(String email) async {
    try {
      DocumentSnapshot snapshot = await _userCollection.doc(email).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        userData.value = UserModel(
          uid: data["uid"],
          username: data["username"],
        );
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
      final String apiKey = DefaultFirebaseOptions.android.apiKey;
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey";

      final Map<String, dynamic> requestBody = {
        "email": email,
        "password": password,
        "returnSecureToken": true,
      };

      debugPrint("🔄 Signing in with REST API...");
      debugPrint("📧 Email: $email");
      debugPrint("🔗 URL: $url");

      // ✅ Make POST request ke Firebase REST API
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      debugPrint("📡 Response Status: ${response.statusCode}");
      debugPrint("📄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // ✅ Parse response data
        final Map<String, dynamic> responseData = json.decode(response.body);

        final String uid = responseData['localId'] ?? '';
        final String userEmail = responseData['email'] ?? '';
        final String idTokenFromAPI = responseData['idToken'] ?? '';
        final String refreshToken = responseData['refreshToken'] ?? '';
        final String expiresIn = responseData['expiresIn'] ?? '3600';
        final bool emailVerified = responseData['emailVerified'] ?? false;

        debugPrint("✅ Sign In Successful!");
        debugPrint("👤 UID: $uid");
        debugPrint("📧 Email: $userEmail");
        debugPrint("🆔 ID Token: ${idTokenFromAPI.substring(0, 50)}...");
        debugPrint("🔄 Refresh Token: ${refreshToken.substring(0, 50)}...");

        // ✅ Set ID token to controller
        idToken.value = idTokenFromAPI;
        refreshTkn.value = refreshToken;

        // ✅ Save authentication data ke SharedPreferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setBool("hasLoggedIn", true);
        await pref.setString("userId", uid);
        await pref.setString("userEmail", userEmail);
        await pref.setString("idToken", idTokenFromAPI);
        await pref.setString("refreshToken", refreshToken);
        await pref.setString("expiresIn", expiresIn);
        await pref.setBool("emailVerified", emailVerified);

        // ✅ Save timestamp untuk token expiry checking
        await pref.setString(
          "tokenTimestamp",
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        );

        debugPrint("✅ Authentication data saved to preferences");

        // ✅ Get user data dari Firestore menggunakan email
        await getUserData(userEmail);

        if (userData.value != null) {
          username.text = userData.value!.username;
          debugPrint("✅ User data loaded: ${userData.value!.username}");
        } else {
          debugPrint("⚠️ No user data found in Firestore");
        }

        // ✅ TAMBAHAN: Authenticate Firebase Auth SDK untuk Realtime Database access
        await _authenticateFirebaseSDK();

        terms.value = false;

        debugPrint("✅ Sign in completed successfully!");
      } else {
        // ✅ Handle error response
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorCode = errorData['error']?['code'] ?? 'UNKNOWN_ERROR';
        final String errorMessage =
            errorData['error']?['message'] ?? 'Unknown error';

        debugPrint("❌ Sign In Failed!");
        debugPrint("❌ Error Code: $errorCode");
        debugPrint("❌ Error Message: $errorMessage");

        // ✅ Map Firebase REST API errors to user-friendly messages
        String userFriendlyMessage;
        switch (errorCode) {
          case 'EMAIL_NOT_FOUND':
            userFriendlyMessage = 'Email tidak terdaftar';
            break;
          case 'INVALID_PASSWORD':
            userFriendlyMessage =
                'Email atau password yang anda masukkan salah';
            break;
          case 'USER_DISABLED':
            userFriendlyMessage = 'Akun Anda telah dinonaktifkan';
            break;
          case 'TOO_MANY_ATTEMPTS_TRY_LATER':
            userFriendlyMessage =
                'Terlalu banyak percobaan login. Coba lagi nanti';
            break;
          case 'INVALID_EMAIL':
            userFriendlyMessage = 'Email tidak valid';
            break;
          default:
            userFriendlyMessage =
                'Terjadi kesalahan saat login. Silakan coba lagi.';
        }

        throw userFriendlyMessage;
      }
    } on http.ClientException catch (error) {
      debugPrint("❌ Network Error: $error");
      throw "Tidak ada koneksi internet. Periksa jaringan Anda.";
    } on FormatException catch (error) {
      debugPrint("❌ JSON Parse Error: $error");
      throw "Response tidak valid dari server";
    } catch (error) {
      debugPrint("❌ Unexpected Error: $error");
      if (error is String) {
        rethrow;
      } else {
        throw "Terjadi kesalahan yang tidak diketahui: $error";
      }
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

      await signIn(email, password);

      debugPrint("User data: $userData");
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
      throw ("terjadi kesalahan yang tidak diketahui: $error");
    }
  }

  //sign in menggunakan google
  Future<void> signInWithGoogle() async {
    try {
      isLoadingGoogle.value = true;
      await _googleSignIn.initialize(
        clientId: DefaultFirebaseOptions.android.androidClientId,
        serverClientId: DefaultFirebaseOptions.serverClientId,
      );

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      await googleUser.authorizationClient.authorizeServer(scopes);

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      String? googleIdToken = googleAuth.idToken;

      //jangan ubah yang di atas comment ini!!

      // ✅ REPLACED: signInWithCredential dengan Firebase REST API OAuth
      if (googleIdToken != null) {
        // ✅ Use Firebase REST API untuk sign in dengan Google OAuth
        await _signInWithGoogleOAuth(googleIdToken, googleUser);

        if (userData.value != null) {
          username.text = userData.value!.username;

          debugPrint("id token: ${idToken.value}");

          // ✅ Simpan/Update di Firestore jika username kosong
          if (userData.value!.username.isEmpty) {
            await _userCollection.doc(googleUser.email).set({
              "uid": _cachedUserId ?? '',
              "username": googleUser.displayName ?? "User",
            }, SetOptions(merge: true));

            await getUserData(googleUser.email);
            username.text = userData.value!.username;
          }

          debugPrint("Google Sign-In berhasil: ${googleUser.email}");

          // ✅ TAMBAHAN: Authenticate Firebase Auth SDK untuk Realtime Database access
          await _authenticateFirebaseSDK();
        }
      } else {
        throw "Failed to get Google ID token";
      }

      terms.value = false;
    } on GoogleSignInException catch (error) {
      throw '${error.description}';
    } catch (error) {
      throw "Gagal login menggunakan Google: $error";
    } finally {
      isLoadingGoogle.value = false;
    }
  }

  // ✅ NEW METHOD: Sign in dengan Google OAuth menggunakan Firebase REST API
  Future<void> _signInWithGoogleOAuth(
    String googleIdToken,
    GoogleSignInAccount googleUser,
  ) async {
    try {
      final String apiKey = DefaultFirebaseOptions.android.apiKey;
      final String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=$apiKey";

      // ✅ Prepare request body untuk OAuth sign in
      final Map<String, dynamic> requestBody = {
        "requestUri":
            "http://localhost", // Required but can be localhost for mobile
        "postBody": "id_token=$googleIdToken&providerId=google.com",
        "returnSecureToken": true,
        "returnIdpCredential": true,
      };

      debugPrint("🔄 Signing in with Google OAuth via REST API...");
      debugPrint("📧 Google Email: ${googleUser.email}");
      debugPrint("🔗 URL: $url");
      debugPrint("🆔 Google ID Token: ${googleIdToken.substring(0, 50)}...");

      // ✅ Make POST request ke Firebase REST API
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      debugPrint("📡 Response Status: ${response.statusCode}");
      debugPrint("📄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // ✅ Extract data dari OAuth response
        final String uid = responseData['localId'] ?? '';
        final String userEmail = responseData['email'] ?? '';
        final String idTokenFromAPI = responseData['idToken'] ?? '';
        final String refreshToken = responseData['refreshToken'] ?? '';
        final String expiresIn = responseData['expiresIn'] ?? '3600';
        final bool emailVerified = responseData['emailVerified'] ?? false;
        final bool isNewUser = responseData['isNewUser'] ?? false;

        // ✅ Additional OAuth data
        final String displayName =
            responseData['displayName'] ?? googleUser.displayName ?? '';
        final String photoUrl = responseData['photoUrl'] ?? '';
        final String providerId = responseData['providerId'] ?? 'google.com';

        debugPrint("✅ Google OAuth Sign In Successful!");
        debugPrint("👤 UID: $uid");
        debugPrint("📧 Email: $userEmail");
        debugPrint("👥 Display Name: $displayName");
        debugPrint("📸 Photo URL: $photoUrl");
        debugPrint("🆔 ID Token: ${idTokenFromAPI.substring(0, 50)}...");
        debugPrint("🔄 Refresh Token: ${refreshToken.substring(0, 50)}...");
        debugPrint("🆕 Is New User: $isNewUser");
        debugPrint("🔗 Provider: $providerId");

        // ✅ Set tokens to controller
        idToken.value = idTokenFromAPI;
        refreshTkn.value = refreshToken;

        // ✅ Update cached user data
        _cachedUserId = uid;
        _cachedUserEmail = userEmail;

        // ✅ Save authentication data ke SharedPreferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setBool("hasLoggedIn", true);
        await pref.setString("userId", uid);
        await pref.setString("userEmail", userEmail);
        await pref.setString("idToken", idTokenFromAPI);
        await pref.setString("refreshToken", refreshToken);
        await pref.setString("expiresIn", expiresIn);
        await pref.setBool("emailVerified", emailVerified);
        await pref.setString("displayName", displayName);
        await pref.setString("photoUrl", photoUrl);
        await pref.setString("providerId", providerId);
        await pref.setBool("isNewUser", isNewUser);

        // ✅ Save timestamp untuk token expiry checking
        await pref.setString(
          "tokenTimestamp",
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        );

        debugPrint("✅ Google OAuth authentication data saved to preferences");

        // ✅ Get user data dari Firestore
        await getUserData(userEmail);

        // ✅ Jika user baru atau data Firestore kosong, create/update
        if (isNewUser || userData.value == null) {
          debugPrint("🆕 Creating/updating user data in Firestore...");

          await _userCollection.doc(userEmail).set({
            "uid": uid,
            "username": displayName.isNotEmpty ? displayName : "Google User",
            "email": userEmail,
            "displayName": displayName,
            "photoUrl": photoUrl,
            "provider": providerId,
            "emailVerified": emailVerified,
            "createdAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // ✅ Reload user data setelah create/update
          await getUserData(userEmail);
        }

        debugPrint("✅ Google OAuth sign in completed successfully!");
      } else {
        // ✅ Handle error response
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorCode = errorData['error']?['code'] ?? 'UNKNOWN_ERROR';
        final String errorMessage =
            errorData['error']?['message'] ?? 'Unknown error';

        debugPrint("❌ Google OAuth Sign In Failed!");
        debugPrint("❌ Error Code: $errorCode");
        debugPrint("❌ Error Message: $errorMessage");

        // ✅ Map OAuth errors to user-friendly messages
        String userFriendlyMessage;
        switch (errorCode) {
          case 'INVALID_IDP_RESPONSE':
            userFriendlyMessage = 'Response Google tidak valid';
            break;
          case 'FEDERATED_USER_ID_ALREADY_LINKED':
            userFriendlyMessage =
                'Akun Google sudah terhubung dengan akun lain';
            break;
          case 'EMAIL_EXISTS':
            userFriendlyMessage = 'Email sudah terdaftar dengan provider lain';
            break;
          case 'USER_DISABLED':
            userFriendlyMessage = 'Akun Anda telah dinonaktifkan';
            break;
          default:
            userFriendlyMessage = 'Gagal login dengan Google: $errorMessage';
        }

        throw userFriendlyMessage;
      }
    } on http.ClientException catch (error) {
      debugPrint("❌ Network Error during Google OAuth: $error");
      throw "Tidak ada koneksi internet. Periksa jaringan Anda.";
    } on FormatException catch (error) {
      debugPrint("❌ JSON Parse Error during Google OAuth: $error");
      throw "Response tidak valid dari server Google";
    } catch (error) {
      debugPrint("❌ Unexpected Error during Google OAuth: $error");
      if (error is String) {
        rethrow;
      } else {
        throw "Terjadi kesalahan saat login dengan Google: $error";
      }
    }
  }

  Future<void> signOut() async {
    try {
      // ✅ Use comprehensive session clearing
      await _clearAllSessions();

      // ✅ Sign out dari Google
      await _googleSignIn.signOut();

      // ✅ Clear text controllers
      email.text = "";
      password.text = "";
      confirmPass.text = "";
      username.text = "";

      debugPrint(
        "✅ Sign out completed (including Google OAuth and Firebase Auth)",
      );
    } catch (error) {
      debugPrint("❌ Error during sign out: $error");
      throw "Error saat logout: $error";
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

  Future<void> changeUsername(String newName) async {
    try {
      // ✅ Use cached email instead of user.email
      String? userEmail = _getCachedUserEmail();
      if (userEmail == null) {
        throw "User tidak login";
      }

      // Gunakan REST API untuk update username di Firestore
      final String idTokenStr = idToken.value;
      if (idTokenStr.isEmpty) {
        throw "ID Token tidak tersedia. Silakan login ulang.";
      }
      // Firestore REST API endpoint
      final String url =
          "https://firestore.googleapis.com/v1/projects/${DefaultFirebaseOptions.android.projectId}/databases/(default)/documents/users/${Uri.encodeComponent(userEmail)}?updateMask.fieldPaths=username";
      final Map<String, dynamic> body = {
        "fields": {
          "username": {"stringValue": newName},
        },
      };
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idTokenStr',
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        if (userData.value != null) {
          userData.update((val) {
            val?.username = newName;
          });
        }
        debugPrint("Username updated: ${userData.value?.username ?? newName}");
        Get.snackbar(
          "Berhasil!",
          "Berhasil mengganti username ke ${userData.value?.username ?? newName}",
          backgroundColor: AppTheme.sucessColor,
          colorText: AppTheme.surfaceColor,
        );
      } else {
        debugPrint(
          "❌ Error updating username: ${response.statusCode} ${response.body}",
        );
        throw "Gagal mengganti username: ${json.decode(response.body)['error']['message'] ?? response.body}";
      }
    } catch (error) {
      Get.snackbar(
        "Error!",
        error.toString(),
        backgroundColor: AppTheme.errorColor,
        colorText: AppTheme.surfaceColor,
      );
    }
  }

  // ✅ Helper method untuk check login status
  bool _isUserLoggedIn() {
    try {
      // Check if we have valid authentication data
      return idToken.value.isNotEmpty && userData.value != null;
    } catch (error) {
      return false;
    }
  }

  // ✅ Alternative: Add cached user properties
  String? get currentUserUid {
    try {
      return _getCachedUserId();
    } catch (error) {
      return null;
    }
  }

  String? get currentUserEmail {
    try {
      return _getCachedUserEmail();
    } catch (error) {
      return null;
    }
  }

  // ✅ Add cached properties
  String? _cachedUserId;
  String? _cachedUserEmail;

  // ✅ Get cached user ID
  String? _getCachedUserId() {
    if (_cachedUserId != null) return _cachedUserId;

    // Load from SharedPreferences if not cached
    _loadCachedUserData();
    return _cachedUserId;
  }

  // ✅ Get cached user email
  String? _getCachedUserEmail() {
    if (_cachedUserEmail != null) return _cachedUserEmail;

    // Load from SharedPreferences if not cached
    _loadCachedUserData();
    return _cachedUserEmail;
  }

  // ✅ Load cached user data from SharedPreferences (including Google OAuth)
  Future<void> _loadCachedUserData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      _cachedUserId = pref.getString("userId");
      _cachedUserEmail = pref.getString("userEmail");

      // ✅ Load additional Google OAuth data
      String? displayName = pref.getString("displayName");
      String? providerId = pref.getString("providerId");

      debugPrint("✅ Cached user data loaded: $_cachedUserEmail");
      if (providerId == "google.com") {
        debugPrint("👥 Google user: $displayName");
      }
    } catch (error) {
      debugPrint("❌ Error loading cached user data: $error");
    }
  }

  // ✅ Refresh ID Token menggunakan refresh token
  Future<void> refreshIdToken() async {
    try {
      // ✅ Check if refresh token exists
      if (refreshTkn.value.isEmpty) {
        throw "No refresh token available. Please login again.";
      }

      final String apiKey = DefaultFirebaseOptions.android.apiKey;
      final String url =
          "https://securetoken.googleapis.com/v1/token?key=$apiKey";

      // ✅ Prepare request body untuk refresh token
      final Map<String, dynamic> requestBody = {
        "grant_type": "refresh_token",
        "refresh_token": refreshTkn.value,
      };

      debugPrint("🔄 Refreshing ID token...");
      debugPrint("🔗 URL: $url");
      debugPrint(
        "🔄 Using refresh token: ${refreshTkn.value.substring(0, 50)}...",
      );

      // ✅ Make POST request ke Firebase token refresh endpoint
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: requestBody.entries
            .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}')
            .join('&'),
      );

      debugPrint("📡 Refresh Response Status: ${response.statusCode}");
      debugPrint("📄 Refresh Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // ✅ Extract new tokens dari response
        final String newIdToken = responseData['id_token'] ?? '';
        final String newRefreshToken = responseData['refresh_token'] ?? '';
        final String expiresIn = responseData['expires_in'] ?? '3600';
        final String tokenType = responseData['token_type'] ?? 'Bearer';
        final String userId = responseData['user_id'] ?? '';

        debugPrint("✅ Token Refresh Successful!");
        debugPrint("🆔 New ID Token: ${newIdToken.substring(0, 50)}...");
        debugPrint(
          "🔄 New Refresh Token: ${newRefreshToken.substring(0, 50)}...",
        );
        debugPrint("⏰ Expires In: $expiresIn seconds");
        debugPrint("🏷️ Token Type: $tokenType");
        debugPrint("👤 User ID: $userId");

        // ✅ Update tokens di controller
        idToken.value = newIdToken;
        refreshTkn.value = newRefreshToken;

        // ✅ Save new tokens ke SharedPreferences
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("idToken", newIdToken);
        await pref.setString("refreshToken", newRefreshToken);
        await pref.setString("expiresIn", expiresIn);

        // ✅ Update timestamp untuk token expiry checking
        await pref.setString(
          "tokenTimestamp",
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        );

        debugPrint("✅ New tokens saved to preferences");
        debugPrint("✅ Token refresh completed successfully!");
      } else {
        // ✅ Handle error response
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorCode =
            errorData['error']?['error']?['status'] ?? 'UNKNOWN_ERROR';
        final String errorMessage =
            errorData['error']?['error']?['message'] ?? 'Unknown error';

        debugPrint("❌ Token Refresh Failed!");
        debugPrint("❌ Error Code: $errorCode");
        debugPrint("❌ Error Message: $errorMessage");

        // ✅ Map refresh token errors to user-friendly messages
        String userFriendlyMessage;
        switch (errorCode) {
          case 'INVALID_REFRESH_TOKEN':
            userFriendlyMessage =
                'Refresh token tidak valid. Silakan login ulang.';
            break;
          case 'TOKEN_EXPIRED':
            userFriendlyMessage =
                'Token sudah kadaluarsa. Silakan login ulang.';
            break;
          case 'USER_DISABLED':
            userFriendlyMessage = 'Akun Anda telah dinonaktifkan.';
            break;
          case 'USER_NOT_FOUND':
            userFriendlyMessage = 'User tidak ditemukan. Silakan login ulang.';
            break;
          default:
            userFriendlyMessage = 'Gagal refresh token. Silakan login ulang.';
        }

        // ✅ Clear invalid tokens
        await _clearInvalidTokens();

        throw userFriendlyMessage;
      }
    } on http.ClientException catch (error) {
      debugPrint("❌ Network Error during token refresh: $error");
      throw "Tidak ada koneksi internet. Periksa jaringan Anda.";
    } on FormatException catch (error) {
      debugPrint("❌ JSON Parse Error during token refresh: $error");
      throw "Response tidak valid dari server";
    } catch (error) {
      debugPrint("❌ Unexpected Error during token refresh: $error");
      if (error is String) {
        rethrow;
      } else {
        throw "Terjadi kesalahan saat refresh token: $error";
      }
    }
  }

  Future<bool> _validateTokenWithFirebase() async {
    try {
      if (idToken.value.isEmpty) return false;

      final String apiKey = DefaultFirebaseOptions.android.apiKey;
      final String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$apiKey";

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"idToken": idToken.value}),
      );

      debugPrint("🔍 Token validation response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final users = responseData['users'] as List?;

        if (users != null && users.isNotEmpty) {
          final user = users[0];
          final bool emailVerified = user['emailVerified'] ?? false;
          final bool disabled = user['disabled'] ?? false;

          debugPrint(
            "✅ Token valid - Email verified: $emailVerified, Disabled: $disabled",
          );

          // ✅ Return true jika user aktif dan tidak disabled
          return !disabled;
        }
      }
      debugPrint("❌ Token validation failed");
      return false;
    } catch (error) {
      debugPrint("❌ Error validating token: $error");
      return false;
    }
  }

  // ✅ Clear invalid tokens ketika refresh gagal
  Future<void> _clearInvalidTokens() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      // ✅ Clear tokens dari SharedPreferences
      await pref.remove("idToken");
      await pref.remove("refreshToken");
      await pref.remove("tokenTimestamp");

      // ✅ Clear tokens dari controller
      idToken.value = "";
      refreshTkn.value = "";

      debugPrint("✅ Invalid tokens cleared");
    } catch (error) {
      debugPrint("❌ Error clearing invalid tokens: $error");
    }
  }

  Future<void> _clearInvalidSession() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      //clear semua auth data
      // ✅ Clear semua auth data
      await pref.setBool("hasLoggedIn", false);
      await pref.remove("userId");
      await pref.remove("userEmail");
      await pref.remove("idToken");
      await pref.remove("refreshToken");
      await pref.remove("tokenTimestamp");

      // ✅ Clear controller data
      _cachedUserId = null;
      _cachedUserEmail = null;
      userData.value = null;
      idToken.value = "";
      refreshTkn.value = "";

      debugPrint("✅ Invalid session cleared");
    } catch (error) {
      debugPrint("❌ Error clearing session: $error");
    }
  }

  // ✅ Authenticate Firebase Auth SDK setelah REST API Sign In berhasil
  Future<void> _authenticateFirebaseSDK() async {
    try {
      // ✅ Check apakah sudah authenticated dengan Firebase Auth
      if (_auth.currentUser != null) {
        debugPrint(
          "✅ Already authenticated with Firebase Auth SDK: ${_auth.currentUser?.uid}",
        );
        return;
      }

      debugPrint(
        "🔐 Authenticating Firebase Auth SDK for Realtime Database access...",
      );

      // ✅ Skip Firebase Auth SDK authentication and use HTTP REST API instead
      debugPrint("⚠️ Skipping Firebase Auth SDK authentication");
      debugPrint(
        "⚠️ Will use HTTP REST API for Realtime Database with ID Token",
      );
      debugPrint(
        "� ID Token from REST API: ${idToken.value.substring(0, 50)}...",
      );

      // ✅ Just verify we have a valid REST API token
      if (idToken.value.isNotEmpty) {
        debugPrint(
          "✅ REST API authentication token available for HTTP requests",
        );
      } else {
        throw "No REST API token available";
      }
    } catch (error) {
      debugPrint("❌ Error in Firebase SDK setup: $error");
      debugPrint("⚠️ Continuing with HTTP REST API approach only");
    }
  }

  // ✅ Check Firebase Auth status for debugging - PUBLIC method
  Future<void> checkFirebaseAuthStatus() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        debugPrint("✅ Firebase Auth Status: AUTHENTICATED");
        debugPrint("✅ User UID: ${user.uid}");
        debugPrint("✅ User Email: ${user.email ?? 'Anonymous'}");
        debugPrint("✅ Is Anonymous: ${user.isAnonymous}");
        debugPrint("✅ Email Verified: ${user.emailVerified}");

        // ✅ Test token retrieval
        try {
          final token = await user.getIdToken();
          if (token != null && token.isNotEmpty) {
            debugPrint(
              "✅ Firebase Auth ID Token available: ${token.substring(0, 50)}...",
            );
          }
        } catch (tokenError) {
          debugPrint("❌ Error getting Firebase Auth token: $tokenError");
        }
      } else {
        debugPrint("❌ Firebase Auth Status: NOT AUTHENTICATED");
      }
    } catch (error) {
      debugPrint("❌ Error checking Firebase Auth status: $error");
    }
  }

  // ✅ Clear all authentication (both REST API and Firebase Auth)
  Future<void> _clearAllSessions() async {
    try {
      // ✅ Clear Firebase Auth session
      if (_auth.currentUser != null) {
        await _auth.signOut();
        debugPrint("✅ Firebase Auth signed out");
      }

      // ✅ Clear REST API session
      await _clearInvalidSession();

      debugPrint("✅ All authentication sessions cleared");
    } catch (error) {
      debugPrint("❌ Error clearing all sessions: $error");
    }
  }
}
