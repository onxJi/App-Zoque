import 'package:appzoque/core/config/env_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final List<String> scopes = ['email', 'profile'];
  User? get currentUser => _auth.currentUser;
  static bool isInitialize = false;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize(serverClientId: EnvConfig.googleClientId);
      isInitialize = true;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      initSignIn();
      // Iniciar sesión con Google
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(scopes);

      final accessToken = authorization?.accessToken;

      if (accessToken == null) {
        throw FirebaseAuthException(
          code: 'internal-error',
          message: 'No se pudo obtener el token de acceso',
        );
      }
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // ignore: avoid_print
      print('Error en signInWithGoogle: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Obtiene el ID Token del usuario actual para autenticación con el backend
  /// Este token JWT de Google se usa para verificar si el usuario es admin
  Future<String?> getIdToken() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Force refresh para asegurar que el token esté actualizado
      final idToken = await user.getIdToken(true);
      return idToken;
    } catch (e) {
      print('Error obteniendo ID Token: $e');
      return null;
    }
  }
}
