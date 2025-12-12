import 'package:appzoque/features/admob/presentation/providers/admob_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Manager global para controlar cuándo mostrar anuncios de inicio
/// Usa el ciclo de vida de la app para determinar si es un "inicio fresco"
class AppStartAdManager {
  static bool _shouldShowAdOnNextNavigation = true;
  static DateTime? _lastAdShownTime;

  /// Marca que se debe mostrar un anuncio en la próxima navegación al home
  static void markAppStart() {
    _shouldShowAdOnNextNavigation = true;
    print(
      '🔄 AppStartAdManager: Marcado para mostrar anuncio en próxima navegación',
    );
  }

  /// Verifica si se debe mostrar el anuncio
  static bool shouldShowAd() {
    // Si ya se mostró hace menos de 5 segundos, no mostrar de nuevo
    // (evita mostrar múltiples veces en navegación rápida)
    if (_lastAdShownTime != null) {
      final timeSinceLastAd = DateTime.now().difference(_lastAdShownTime!);
      if (timeSinceLastAd.inSeconds < 5) {
        print(
          '⏭️ AppStartAdManager: Anuncio mostrado hace ${timeSinceLastAd.inSeconds}s, saltando',
        );
        return false;
      }
    }

    return _shouldShowAdOnNextNavigation;
  }

  /// Marca que el anuncio ya se mostró
  static void markAdShown() {
    _shouldShowAdOnNextNavigation = false;
    _lastAdShownTime = DateTime.now();
    print('✅ AppStartAdManager: Anuncio marcado como mostrado');
  }

  /// Resetea el estado (para testing)
  static void reset() {
    _shouldShowAdOnNextNavigation = true;
    _lastAdShownTime = null;
    print('🔄 AppStartAdManager: Estado reseteado');
  }
}

/// Wrapper que muestra un anuncio intersticial antes de mostrar el contenido
/// Muestra el anuncio CADA VEZ que se inicia la app
class AdInterstitialWrapper extends StatefulWidget {
  final Widget child;
  final bool showAdOnInit;

  const AdInterstitialWrapper({
    super.key,
    required this.child,
    this.showAdOnInit = true,
  });

  @override
  State<AdInterstitialWrapper> createState() => _AdInterstitialWrapperState();
}

class _AdInterstitialWrapperState extends State<AdInterstitialWrapper> {
  bool _isLoading = true;
  bool _adAttempted = false;

  @override
  void initState() {
    super.initState();
    print('🔵 AdInterstitialWrapper: initState');

    if (widget.showAdOnInit &&
        AppStartAdManager.shouldShowAd() &&
        !_adAttempted) {
      _loadAndShowAd();
    } else {
      print('⏭️ AdInterstitialWrapper: No se debe mostrar anuncio ahora');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAndShowAd() async {
    if (_adAttempted) {
      print('⚠️ AdInterstitialWrapper: Ya se intentó en esta instancia');
      setState(() => _isLoading = false);
      return;
    }

    _adAttempted = true;
    print('🎯 AdInterstitialWrapper: Iniciando carga de anuncio de inicio...');

    try {
      final adMobProvider = context.read<AdMobProvider>();

      // Cargar el anuncio
      print('📥 AdInterstitialWrapper: Cargando anuncio...');
      await adMobProvider.loadInterstitialAd();

      // Esperar un poco para asegurar que se cargó
      await Future.delayed(const Duration(seconds: 2));

      // Verificar si está listo
      if (adMobProvider.isInterstitialAdReady) {
        print('✅ AdInterstitialWrapper: Anuncio listo, mostrando...');

        // Mostrar el anuncio
        await adMobProvider.showInterstitialAd();

        // Marcar que se mostró
        AppStartAdManager.markAdShown();

        print(
          '🎉 AdInterstitialWrapper: Anuncio de inicio mostrado exitosamente',
        );
      } else {
        print('⚠️ AdInterstitialWrapper: Anuncio no se cargó a tiempo');
        print('📊 Estado del anuncio: ${adMobProvider.interstitialAd?.status}');
        if (adMobProvider.error != null) {
          print('❌ Error: ${adMobProvider.error}');
        }
        // Si falla, permitir intentar de nuevo en el próximo inicio
        AppStartAdManager.markAppStart();
      }
    } catch (e) {
      print('❌ AdInterstitialWrapper: Error al cargar/mostrar anuncio: $e');
      // Si hay error, permitir intentar de nuevo en el próximo inicio
      AppStartAdManager.markAppStart();
    } finally {
      if (mounted) {
        print('🏁 AdInterstitialWrapper: Finalizando, mostrando contenido');
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mostrar un indicador de carga mientras se carga el anuncio
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
}
