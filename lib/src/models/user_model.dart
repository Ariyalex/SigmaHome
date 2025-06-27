class UserModel {
  final String uid;
  final String username;
  final Uri? photoProfile;

  UserModel({
    required this.uid,
    required this.username,
    this.photoProfile,
  });
}
