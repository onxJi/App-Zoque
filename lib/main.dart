import 'package:appzoque/app.dart';
import 'package:appzoque/features/auth/providers/auth_provider.dart';
import 'package:appzoque/core/config/env_config.dart';
import 'package:appzoque/core/di/dependency_injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  // Initialize environment configuration
  await EnvConfig.load();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize dependency injection
  final di = DependencyInjection();
  di.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider.value(value: di.dictionaryViewModel),
        ChangeNotifierProvider.value(value: di.newsViewModel),
        ChangeNotifierProvider.value(value: di.homeViewModel),
        ChangeNotifierProvider.value(value: di.teachingViewModel),
        ChangeNotifierProvider.value(value: di.adminViewModel),
      ],
      child: const MyApp(),
    ),
  );
}
