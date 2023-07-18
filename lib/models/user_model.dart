class User {
  const User({
    required this.username,
    required this.email,
    required this.profilePicture,
    required this.userId,
  });
  final String userId;
  final String username;
  final String email;
  final String profilePicture;

  toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
    };
  }
}
