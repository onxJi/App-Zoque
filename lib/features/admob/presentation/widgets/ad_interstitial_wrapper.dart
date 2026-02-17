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
  }

  /// Verifica si se debe mostrar el anuncio
  static bool shouldShowAd() {
    // Si ya se mostró hace menos de 5 segundos, no mostrar de nuevo
    // (evita mostrar múltiples veces en navegación rápida)
    if (_lastAdShownTime != null) {
      final timeSinceLastAd = DateTime.now().difference(_lastAdShownTime!);
      if (timeSinceLastAd.inSeconds < 5) {
        return false;
      }
    }

    return _shouldShowAdOnNextNavigation;
  }

  /// Marca que el anuncio ya se mostró
  static void markAdShown() {
    _shouldShowAdOnNextNavigation = false;
    _lastAdShownTime = DateTime.now();
  }

  /// Resetea el estado (para testing)
  static void reset() {
    _shouldShowAdOnNextNavigation = true;
    _lastAdShownTime = null;
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

    if (widget.showAdOnInit &&
        AppStartAdManager.shouldShowAd() &&
        !_adAttempted) {
      _loadAndShowAd();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAndShowAd() async {
    if (_adAttempted) {
      setState(() => _isLoading = false);
      return;
    }

    _adAttempted = true;

    try {
      final adMobProvider = context.read<AdMobProvider>();

      // Cargar el anuncio
      await adMobProvider.loadInterstitialAd();

      // Esperar un poco para asegurar que se cargó
      await Future.delayed(const Duration(seconds: 2));

      // Verificar si está listo
      if (adMobProvider.isInterstitialAdReady) {
        // Mostrar el anuncio
        await adMobProvider.showInterstitialAd();

        // Marcar que se mostró
        AppStartAdManager.markAdShown();
      } else {
        // Si falla, permitir intentar de nuevo en el próximo inicio
        AppStartAdManager.markAppStart();
      }
    } catch (e) {
      // Si hay error, permitir intentar de nuevo en el próximo inicio
      AppStartAdManager.markAppStart();
    } finally {
      if (mounted) {
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
