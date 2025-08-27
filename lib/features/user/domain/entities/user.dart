class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.photoUrl,
  });

  get profileImage => null;
}
