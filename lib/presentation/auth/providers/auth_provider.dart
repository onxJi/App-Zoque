import 'package:appzoque/presentation/auth/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isSignedIn = false;
  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;

  bool get isSignedIn => _isSignedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhotoUrl => _userPhotoUrl;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        _isSignedIn = true;
        _userName = user.displayName;
        _userEmail = user.email;
        _userPhotoUrl = user.photoURL;
      } else {
        _isSignedIn = false;
        _userName = null;
        _userEmail = null;
        _userPhotoUrl = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    final result = await _authService.signInWithGoogle();
    return result != null;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
