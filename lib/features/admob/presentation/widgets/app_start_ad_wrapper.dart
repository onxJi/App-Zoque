import 'package:appzoque/features/admob/presentation/providers/admob_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Wrapper que muestra un anuncio intersticial al iniciar la app
/// Se usa SOLO en la ruta inicial después del splash screen
class AppStartAdWrapper extends StatefulWidget {
  final Widget child;

  const AppStartAdWrapper({super.key, required this.child});

  @override
  State<AppStartAdWrapper> createState() => _AppStartAdWrapperState();
}

class _AppStartAdWrapperState extends State<AppStartAdWrapper> {
  // Variable estática para mostrar el anuncio solo UNA VEZ por sesión de app
  static bool _adShownThisSession = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print(
      '🔵 AppStartAdWrapper: initState - Ya mostrado: $_adShownThisSession',
    );

    if (!_adShownThisSession) {
      _loadAndShowAd();
    } else {
      print('⏭️ AppStartAdWrapper: Anuncio ya mostrado en esta sesión');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAndShowAd() async {
    _adShownThisSession = true;
    print('🎯 AppStartAdWrapper: Cargando anuncio de inicio...');

    try {
      final adMobProvider = context.read<AdMobProvider>();

      print('📥 AppStartAdWrapper: Cargando anuncio...');
      await adMobProvider.loadInterstitialAd();

      // Esperar hasta que esté listo o timeout
      bool ready = await _waitForAdReady(adMobProvider, timeoutSeconds: 10);

      if (ready && adMobProvider.isInterstitialAdReady) {
        print('✅ AppStartAdWrapper: Anuncio listo, mostrando...');
        await adMobProvider.showInterstitialAd();
        print('🎉 AppStartAdWrapper: Anuncio de inicio mostrado exitosamente');
      } else {
        print('⚠️ AppStartAdWrapper: Anuncio no se cargó a tiempo o falló');
        print('📊 Estado: ${adMobProvider.interstitialAd?.status}');
        if (adMobProvider.error != null) {
          print('❌ Error: ${adMobProvider.error}');
        }
      }
    } catch (e) {
      print('❌ AppStartAdWrapper: Error general: $e');
    } finally {
      if (mounted) {
        print('🏁 AppStartAdWrapper: Mostrando contenido principal');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _waitForAdReady(
    AdMobProvider provider, {
    int timeoutSeconds = 10,
  }) async {
    int attempts = 0;
    const maxAttempts = 20; // 20 intentos * 0.5s = 10s máx
    const interval = Duration(milliseconds: 500);

    while (attempts < maxAttempts) {
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Cargando contenido...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }

  /// Resetear el estado (útil al cerrar sesión)
  static void reset() {
    _adShownThisSession = false;
    print('🔄 AppStartAdWrapper: Estado reseteado');
  }
}
