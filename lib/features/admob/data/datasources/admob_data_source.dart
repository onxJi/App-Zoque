import 'package:appzoque/features/admob/config/admob_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Data source for AdMob operations
class AdMobDataSource {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  /// Get the interstitial ad unit ID based on platform
  String get interstitialAdUnitId => AdMobConfig.interstitialAdUnitId;

  /// Get the rewarded ad unit ID based on platform
  String get rewardedAdUnitId => AdMobConfig.rewardedAdUnitId;

  /// Initialize the Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// Load an interstitial ad
  Future<void> loadInterstitialAd({
    required Function() onAdLoaded,
    required Function(String error) onAdFailedToLoad,
  }) async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          onAdFailedToLoad(error.message);
        },
      ),
    );
  }

  /// Show an interstitial ad
  Future<void> showInterstitialAd({
    required Function() onAdDismissed,
    required Function() onAdFailedToShow,
  }) async {
    if (_interstitialAd == null) {
      onAdFailedToShow();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onAdFailedToShow();
      },
    );

    await _interstitialAd!.show();
  }

  /// Load a rewarded ad
  Future<void> loadRewardedAd({
    required Function() onAdLoaded,
    required Function(String error) onAdFailedToLoad,
  }) async {
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          onAdFailedToLoad(error.message);
        },
      ),
    );
  }

  /// Show a rewarded ad
  Future<void> showRewardedAd({
    required Function(int amount, String type) onUserEarnedReward,
    required Function() onAdDismissed,
    required Function() onAdFailedToShow,
  }) async {
    if (_rewardedAd == null) {
      onAdFailedToShow();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        onAdFailedToShow();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onUserEarnedReward(reward.amount.toInt(), reward.type);
      },
    );
  }

  /// Dispose of all ads
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialAd = null;
    _rewardedAd = null;
  }
}
