import 'dart:async';
import 'package:appzoque/core/config/env_config.dart';
import 'package:appzoque/features/auth/domain/entities/auth_user.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthUser? _currentAuthUser;
  AuthUser? get currentUser => _currentAuthUser;

  static bool isInitialize = false;

  final _userStreamController = StreamController<AuthUser?>.broadcast();
  Stream<AuthUser?> get authStateChanges => _userStreamController.stream;

  static Future<void> initSignIn() async {
    if (!isInitialize) {
      await _googleSignIn.initialize(serverClientId: EnvConfig.googleClientId);
      isInitialize = true;
    }
  }

  AuthService() {
    _initUser();
  }

  Future<void> _initUser() async {
    try {
      await initSignIn();
      final account = await _googleSignIn.attemptLightweightAuthentication();
      if (account != null) {
        final auth = await account.authentication;
        _currentAuthUser = AuthUser(
          email: account.email,
          displayName: account.displayName,
          photoURL: account.photoUrl,
          idToken: auth.idToken,
        );
      } else {
        _currentAuthUser = null;
      }
      _userStreamController.add(_currentAuthUser);
    } catch (e) {
      debugPrint('Error en _initUser: $e');
      _userStreamController.add(null);
    }
  }

  Future<AuthUser?> signInWithGoogle() async {
    try {
      await initSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      _currentAuthUser = AuthUser(
        email: googleUser.email,
        displayName: googleUser.displayName,
        photoURL: googleUser.photoUrl,
        idToken: googleAuth.idToken,
      );

      _userStreamController.add(_currentAuthUser);
      return _currentAuthUser;
    } catch (e) {
      debugPrint('Error en signInWithGoogle: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentAuthUser = null;
      _userStreamController.add(null);
    } catch (e) {
      debugPrint('Error en signOut: $e');
    }
  }

  /// Obtiene el ID Token del usuario actual para autenticación con el backend
  Future<String?> getIdToken() async {
    try {
      await initSignIn();

      // Intentar obtener el token del usuario actual o re-autenticar silenciosamente
      final account = await _googleSignIn.attemptLightweightAuthentication();
      if (account == null) {
        debugPrint('AUTH: No hay usuario autenticado (lightweight)');
        return null;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken != null) {
        if (idToken.startsWith('eyJ')) {
          debugPrint(
            'AUTH: Token JWT obtenido correctamente (empieza con eyJ)',
          );
        } else {
          debugPrint(
            'AUTH: ADVERTENCIA - El token obtenido no parece un JWT válido: ${idToken.substring(0, 10)}...',
          );
        }
      } else {
        debugPrint('AUTH: Error - El token obtenido es NULL');
      }

      return idToken;
    } catch (e) {
      debugPrint('AUTH: Error obteniendo ID Token: $e');
      return null;
    }
  }
}
