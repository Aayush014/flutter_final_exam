class UserModel {
  String? name, email, token,pass;

  UserModel({
    required this.email,
    required this.pass,
  });

  factory UserModel.fromMap(Map m1) {
    return UserModel(
      email: m1["email"],
      pass: m1["pass"],
    );
  }

  Map<String, String?> toMap(UserModel user) {
    return {
      'email': user.email,
      'pass': user.pass,
    };
  }
}
