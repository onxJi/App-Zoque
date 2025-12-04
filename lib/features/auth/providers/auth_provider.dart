import 'package:appzoque/features/auth/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isSignedIn = false;
  bool _isInitialized = false;
  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;

  bool get isSignedIn => _isSignedIn;
  bool get isInitialized => _isInitialized;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhotoUrl => _userPhotoUrl;

  AuthProvider() {
    // Verificar si hay un usuario ya autenticado al iniciar
    _checkCurrentUser();

    // Escuchar cambios en el estado de autenticación
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
      _isInitialized = true;
      notifyListeners();
    });
  }

  // Verificar si hay un usuario actual al inicializar
  void _checkCurrentUser() {
    final user = _authService.currentUser;
    if (user != null) {
      _isSignedIn = true;
      _userName = user.displayName;
      _userEmail = user.email;
      _userPhotoUrl = user.photoURL;
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    final result = await _authService.signInWithGoogle();
    return result != null;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
