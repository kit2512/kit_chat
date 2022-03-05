class Conversation {
  final String uid;
  final List<String> members;

  const Conversation({
    required this.uid,
    required this.members,
  });

  factory Conversation.fromSnapshot(Map<String, dynamic> json) {
    return Conversation(
      uid: json['uid'],
      members: List<String>.from(json['members']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'members': members,
    };
  }
}
