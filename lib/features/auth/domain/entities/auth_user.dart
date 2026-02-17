class AuthUser {
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? idToken;

  AuthUser({
    required this.email,
    this.displayName,
    this.photoURL,
    this.idToken,
  });

  @override
  String toString() {
    return 'AuthUser(email: $email, name: $displayName, idToken: ${idToken?.substring(0, 10)}...)';
  }
}
