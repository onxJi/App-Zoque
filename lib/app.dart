import 'package:appzoque/core/themes/app_theme.dart';
import 'package:appzoque/presentation/auth/providers/auth_provider.dart';
import 'package:appzoque/presentation/auth/screens/auth_screen.dart';
import 'package:appzoque/presentation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
  ],
  redirect: (context, state) {
    final authProvider = context.read<AuthProvider>();
    final location = state.uri.toString();

    if (!authProvider.isSignedIn && location != '/') {
      return '/';
    } else if (authProvider.isSignedIn && location == '/') {
      return '/home';
    }
    return null;
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Comunidad Zoque',
      theme: AppTheme().theme(),
      routerConfig: _router,
    );
  }
}
