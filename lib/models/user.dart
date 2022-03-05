class User {
  String uid;
  String profileImage;
  String name;
  String email;
  List<String> conversations;

  User(
      {required this.uid,
      required this.profileImage,
      required this.name,
      required this.email,
      required this.conversations});

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "profileImage": profileImage,
      "name": name,
      "conversations": conversations,
      "email": email
    };
  }

  factory User.fromSnapshot(Map<String, dynamic> json) {
    return User(
      uid: json["uid"],
      profileImage: json["profileImage"],
      name: json["name"],
      email: json["email"],
      conversations: (json["conversations"] as List).cast<String>(),
    );
  }
}
