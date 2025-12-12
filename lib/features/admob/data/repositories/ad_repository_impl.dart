import 'package:appzoque/features/admob/data/datasources/admob_data_source.dart';
import 'package:appzoque/features/admob/domain/entities/ad.dart';
import 'package:appzoque/features/admob/domain/repositories/ad_repository.dart';

/// Implementation of the AdRepository
class AdRepositoryImpl implements AdRepository {
  final AdMobDataSource _dataSource;
  Ad? _currentInterstitialAd;
  Ad? _currentRewardedAd;

  AdRepositoryImpl(this._dataSource);

  @override
  Future<void> initialize() async {
    await _dataSource.initialize();
  }

  @override
  Future<Ad> loadInterstitialAd() async {
    _currentInterstitialAd = Ad(
      adUnitId: _dataSource.interstitialAdUnitId,
      type: AdType.interstitial,
      status: AdStatus.loading,
    );

    await _dataSource.loadInterstitialAd(
      onAdLoaded: () {
        _currentInterstitialAd = _currentInterstitialAd?.copyWith(
          status: AdStatus.loaded,
        );
      },
      onAdFailedToLoad: (error) {
        _currentInterstitialAd = _currentInterstitialAd?.copyWith(
          status: AdStatus.failed,
        );
        throw Exception('Failed to load interstitial ad: $error');
      },
    );

    return _currentInterstitialAd!;
  }

  @override
  Future<void> showInterstitialAd() async {
    if (_currentInterstitialAd?.status != AdStatus.loaded) {
      throw Exception('Interstitial ad is not loaded');
    }

    _currentInterstitialAd = _currentInterstitialAd?.copyWith(
      status: AdStatus.showing,
    );

    await _dataSource.showInterstitialAd(
      onAdDismissed: () {
        _currentInterstitialAd = _currentInterstitialAd?.copyWith(
          status: AdStatus.closed,
        );
      },
      onAdFailedToShow: () {
        _currentInterstitialAd = _currentInterstitialAd?.copyWith(
          status: AdStatus.failed,
        );
      },
    );
  }

  @override
  Future<Ad> loadRewardedAd() async {
    _currentRewardedAd = Ad(
      adUnitId: _dataSource.rewardedAdUnitId,
      type: AdType.rewarded,
      status: AdStatus.loading,
    );

    await _dataSource.loadRewardedAd(
      onAdLoaded: () {
        _currentRewardedAd = _currentRewardedAd?.copyWith(
          status: AdStatus.loaded,
        );
      },
      onAdFailedToLoad: (error) {
        _currentRewardedAd = _currentRewardedAd?.copyWith(
          status: AdStatus.failed,
        );
        throw Exception('Failed to load rewarded ad: $error');
      },
    );

    return _currentRewardedAd!;
  }

  @override
  Future<void> showRewardedAd({required Function onRewarded}) async {
    if (_currentRewardedAd?.status != AdStatus.loaded) {
      throw Exception('Rewarded ad is not loaded');
    }

    _currentRewardedAd = _currentRewardedAd?.copyWith(status: AdStatus.showing);

    await _dataSource.showRewardedAd(
      onUserEarnedReward: (amount, type) {
        onRewarded();
      },
      onAdDismissed: () {
        _currentRewardedAd = _currentRewardedAd?.copyWith(
          status: AdStatus.closed,
        );
      },
      onAdFailedToShow: () {
        _currentRewardedAd = _currentRewardedAd?.copyWith(
          status: AdStatus.failed,
        );
      },
    );
  }

  @override
  void dispose() {
    _dataSource.dispose();
    _currentInterstitialAd = null;
    _currentRewardedAd = null;
  }
}
