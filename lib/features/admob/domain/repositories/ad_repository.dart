import 'package:appzoque/features/admob/domain/entities/ad.dart';

/// Repository interface for AdMob operations
abstract class AdRepository {
  /// Initialize the Mobile Ads SDK
  Future<void> initialize();

  /// Load an interstitial ad
  Future<Ad> loadInterstitialAd();

  /// Show an interstitial ad
  Future<void> showInterstitialAd();

  /// Load a rewarded ad
  Future<Ad> loadRewardedAd();

  /// Show a rewarded ad
  Future<void> showRewardedAd({required Function onRewarded});

  /// Dispose of all ads
  void dispose();
}
