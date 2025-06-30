class UserProfile {
  final String uid;
  final String name;
  final String email;

  UserProfile({required this.uid, required this.name, required this.email});

  factory UserProfile.fromMap(Map<String, dynamic> data) =>
      UserProfile(uid: data['uid'], name: data['name'], email: data['email']);

  Map<String, dynamic> toMap() => {'uid': uid, 'name': name, 'email': email};
}
