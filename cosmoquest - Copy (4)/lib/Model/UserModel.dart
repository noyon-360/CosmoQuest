class UserModel {
  final String? email;
  final String? displayName;
  final String? photoURL;

  UserModel({
    this.email,
    this.displayName,
    this.photoURL,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
    );
  }
}
