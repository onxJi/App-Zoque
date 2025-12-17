import 'package:appzoque/features/admob/presentation/providers/admob_provider.dart';
import 'package:appzoque/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:appzoque/features/home/presentation/widgets/admin_tab.dart';
import 'package:appzoque/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:appzoque/features/home/presentation/widgets/custom_bottom_nav.dart';
import 'package:appzoque/features/home/presentation/widgets/dictionary_tab.dart';
import 'package:appzoque/features/home/presentation/widgets/news_tab.dart';
import 'package:appzoque/features/home/presentation/widgets/teaching_tab.dart';
import 'package:appzoque/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _adShownThisSession = false;
  bool _showingAd = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndShowInitialAd();
      final authProvider = context.read<AuthProvider>();
      context.read<HomeViewModel>().loadMenuItems(authProvider.userEmail);
    });
  }

  Future<void> _loadAndShowInitialAd() async {
    if (_adShownThisSession || _showingAd) return;

    _adShownThisSession = true;
    _showingAd = true;

    try {
      final adMobProvider = context.read<AdMobProvider>();

      print('🎯 HomeScreen: Cargando anuncio de inicio...');
      await adMobProvider.loadInterstitialAd();

      bool ready = await _waitForAdReady(adMobProvider, timeoutSeconds: 10);

      if (ready && mounted && adMobProvider.isInterstitialAdReady) {
        print('✅ HomeScreen: Anuncio listo, mostrando...');
        await adMobProvider.showInterstitialAd();
        print('🎉 HomeScreen: Anuncio de inicio mostrado exitosamente');
      } else {
        print('⚠️ HomeScreen: Anuncio no se cargó a tiempo');
        if (adMobProvider.error != null) {
          print('❌ Error: ${adMobProvider.error}');
        }
      }
    } catch (e) {
      print('❌ HomeScreen: Error mostrando anuncio: $e');
    } finally {
      if (mounted) {
        _showingAd = false;
      }
    }
  }

  Future<bool> _waitForAdReady(
    AdMobProvider provider, {
    int timeoutSeconds = 10,
  }) async {
    int attempts = 0;
    const maxAttempts = 20;
    const interval = Duration(milliseconds: 500);

    while (attempts < maxAttempts && mounted) {
      if (provider.isInterstitialAdReady) {
        return true;
      }
      await Future.delayed(interval);
      attempts++;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (viewModel.menuItems.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No menu items available')),
          );
        }

        return Scaffold(
          appBar: const CustomAppBar(title: 'App Zoque'),
          body: IndexedStack(
            index: viewModel.selectedIndex,
            children: viewModel.menuItems.map((item) {
              switch (item.id) {
                case 'news':
                  return const NewsTab();
                case 'teaching':
                  return const TeachingTab();
                case 'dictionary':
                  return const DictionaryTab();
                case 'admin':
                  return const AdminTab();
                default:
                  return Center(child: Text('Unknown tab: ${item.label}'));
              }
            }).toList(),
          ),
          bottomNavigationBar: CustomBottomNav(
            currentIndex: viewModel.selectedIndex,
            onTap: (index) => viewModel.setIndex(index),
            menuItems: viewModel.menuItems,
          ),
        );
      },
    );
  }
}
