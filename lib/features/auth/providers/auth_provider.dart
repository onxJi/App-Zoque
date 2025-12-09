import 'package:appzoque/features/auth/services/auth_service.dart';
import 'package:appzoque/features/auth/domain/usecases/verify_admin_user_usecase.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final VerifyAdminUserUseCase? _verifyAdminUserUseCase;

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
  bool get isAdmin => _isAdmin;
  bool get isCheckingAdmin => _isCheckingAdmin;

  bool _isAdmin = false;
  bool _isCheckingAdmin = false;

  AuthProvider({
    AuthService? authService,
    VerifyAdminUserUseCase? verifyAdminUserUseCase,
  }) : _authService = authService ?? AuthService(),
       _verifyAdminUserUseCase = verifyAdminUserUseCase {
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
    if (result != null) {
      // Verificar si el usuario es admin después del login
      await checkIfUserIsAdmin();
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isAdmin = false;
    _isCheckingAdmin = false;
    notifyListeners();
  }

  /// Verifica si el usuario actual es administrador
  /// Envía el JWT de Google al backend para validación
  Future<void> checkIfUserIsAdmin() async {
    if (_verifyAdminUserUseCase == null) {
      print('VerifyAdminUserUseCase no está disponible');
      return;
    }

    _isCheckingAdmin = true;
    _isAdmin = false;
    notifyListeners();

    try {
      // Obtener el ID Token de Google
      final idToken = await _authService.getIdToken();

      if (idToken == null) {
        print('No se pudo obtener el ID Token');
        _isCheckingAdmin = false;
        notifyListeners();
        return;
      }

      // Verificar con el backend si el usuario es admin
      final isAdmin = await _verifyAdminUserUseCase.call(idToken);
      _isAdmin = isAdmin;

      print('Usuario es admin: $isAdmin');
    } catch (e) {
      print('Error verificando si el usuario es admin: $e');
      _isAdmin = false;
    } finally {
      _isCheckingAdmin = false;
      notifyListeners();
    }
  }
}
