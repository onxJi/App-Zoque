import 'dart:async';

import 'package:appzoque/features/admob/domain/entities/ad.dart';
import 'package:appzoque/features/admob/domain/repositories/ad_repository.dart';
import 'package:appzoque/features/admob/config/admob_config.dart';
import 'package:flutter/foundation.dart';

/// Provider for managing AdMob state and operations
class AdMobProvider extends ChangeNotifier {
  final AdRepository _repository;
  Completer<void>? _interstitialLoadCompleter;
  Ad? _interstitialAd;
  Ad? _rewardedAd;
  bool _isInitialized = false;
  String? _error;
  String _lastLog = '';
  final List<String> _logs = [];

  AdMobProvider(this._repository);

  // Getters
  Ad? get interstitialAd => _interstitialAd;
  Ad? get rewardedAd => _rewardedAd;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  bool get isInterstitialAdReady => _interstitialAd?.status == AdStatus.loaded;
  bool get isRewardedAdReady => _rewardedAd?.status == AdStatus.loaded;
  String get lastLog => _lastLog;
  List<String> get logs => List.unmodifiable(_logs);
  String get currentMode => AdMobConfig.modeDescription;
  String get currentAdUnitId => AdMobConfig.interstitialAdUnitId;

  void _log(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    _lastLog = '$timestamp: $message';
    _logs.add(_lastLog);
    if (_logs.length > 50) {
      _logs.removeAt(0); // Keep only last 50 logs
    }
    if (kDebugMode) {
      print('🎯 AdMob: $message');
    }
    notifyListeners();
  }

  /// Initialize the Mobile Ads SDK
  Future<void> initialize() async {
    try {
      _log('Inicializando AdMob SDK...');
      _log('Modo: ${AdMobConfig.modeDescription}');
      await _repository.initialize();
      _isInitialized = true;
      _error = null;
      _log('✅ AdMob SDK inicializado correctamente');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isInitialized = false;
      _log('❌ Error al inicializar AdMob: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadInterstitialAd() async {
    try {
      _interstitialLoadCompleter = Completer<void>();

      _log('📥 Cargando anuncio intersticial...');
      _error = null;

      // Tu lógica actual de carga
      _interstitialAd = await _repository.loadInterstitialAd();

      // Importante: Completa el completer cuando esté listo
      if (_interstitialAd?.status == AdStatus.loaded) {
        if (!_interstitialLoadCompleter!.isCompleted) {
          _interstitialLoadCompleter!.complete();
        }
      }

      _log('✅ Anuncio intersticial cargado');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _interstitialAd = null;
      _interstitialLoadCompleter?.completeError(e);
      _log('❌ Error al cargar anuncio: $e');
      notifyListeners();
    }
  }

  // Método para esperar que el anuncio esté listo
  Future<void> waitForInterstitialReady() async {
    if (_interstitialLoadCompleter != null) {
      await _interstitialLoadCompleter!.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Anuncio no se cargó a tiempo'),
      );
    } else {
      throw Exception('No hay carga de anuncio en progreso');
    }
  }

  /// Show an interstitial ad
  Future<void> showInterstitialAd() async {
    if (!isInterstitialAdReady) {
      _log('⚠️ Anuncio no está listo para mostrarse');
      return;
    }

    try {
      _log('📺 Mostrando anuncio intersticial...');
      await _repository.showInterstitialAd();
      _interstitialAd = null;
      _log('✅ Anuncio mostrado y cerrado');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _log('❌ Error al mostrar anuncio: $e');
      notifyListeners();
    }
  }

  /// Load and show an interstitial ad (convenience method)
  Future<void> loadAndShowInterstitialAd() async {
    _log('🚀 Iniciando carga y visualización de anuncio...');
    await loadInterstitialAd();
    // Wait a bit to ensure the ad is loaded
    await Future.delayed(const Duration(seconds: 2));
    if (isInterstitialAdReady) {
      await showInterstitialAd();
    } else {
      _log(
        '⚠️ Anuncio no se cargó a tiempo. Estado: ${_interstitialAd?.status}',
      );
    }
  }

  /// Load a rewarded ad
  Future<void> loadRewardedAd() async {
    try {
      _log('📥 Cargando anuncio recompensado...');
      _log('ID: ${AdMobConfig.rewardedAdUnitId}');
      _error = null;
      _rewardedAd = await _repository.loadRewardedAd();
      _log('✅ Anuncio recompensado cargado');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _rewardedAd = null;
      _log('❌ Error al cargar anuncio recompensado: $e');
      notifyListeners();
    }
  }

  /// Show a rewarded ad
  Future<void> showRewardedAd({required Function onRewarded}) async {
    if (!isRewardedAdReady) {
      _log('⚠️ Anuncio recompensado no está listo');
      return;
    }

    try {
      _log('📺 Mostrando anuncio recompensado...');
      await _repository.showRewardedAd(onRewarded: onRewarded);
      _rewardedAd = null;
      _log('✅ Anuncio recompensado mostrado');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _log('❌ Error al mostrar anuncio recompensado: $e');
      notifyListeners();
    }
  }

  /// Clear logs
  void clearLogs() {
    _logs.clear();
    _lastLog = '';
    _log('Logs limpiados');
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
