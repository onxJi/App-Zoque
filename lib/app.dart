import 'package:appzoque/core/themes/app_theme.dart';
import 'package:appzoque/features/auth/providers/auth_provider.dart';
import 'package:appzoque/features/auth/presentation/screens/auth_screen.dart';
import 'package:appzoque/features/auth/presentation/screens/splash_screen.dart';
import 'package:appzoque/features/home/presentation/screens/home_screen.dart';
import 'package:appzoque/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:appzoque/core/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Función para crear el router con el AuthProvider
GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authProvider, // Escuchar cambios en el AuthProvider
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
    redirect: (context, state) async {
      final location = state.uri.toString();

      // Si aún no se ha inicializado, mostrar pantalla de carga
      if (!authProvider.isInitialized) {
        return null; // Mantener en la ubicación actual mientras se inicializa
      }

      // Check if it's the first time
      final prefs = await PreferencesService.getInstance();
      final isFirstTime = prefs.isFirstTime;

      // If first time and not already on onboarding, redirect to onboarding
      if (isFirstTime && location != '/onboarding') {
        return '/onboarding';
      }

      // If not first time, proceed with normal auth flow
      if (!isFirstTime) {
        // Redirigir según el estado de autenticación
        if (!authProvider.isSignedIn && location != '/') {
          return '/'; // No autenticado -> ir al login
        } else if (authProvider.isSignedIn && location == '/') {
          return '/home'; // Autenticado en login -> ir al home
        }
      }

      return null; // No redirigir
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('Initializing app...');
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Mostrar pantalla de carga mientras se inicializa
    if (!authProvider.isInitialized) {
      return MaterialApp(
        title: 'Comunidad Zoque',
        theme: AppTheme().theme(),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      );
    }

    return MaterialApp.router(
      title: 'Comunidad Zoque',
      theme: AppTheme().theme(),
      debugShowCheckedModeBanner: false,
      routerConfig: createRouter(authProvider),
    );
  }
}
