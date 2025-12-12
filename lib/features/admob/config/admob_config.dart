import 'dart:io';

/// Configuration class for AdMob Ad Unit IDs
///
/// This class centralizes all AdMob configuration.
/// Switch between test and production IDs by changing the `useTestAds` flag.
class AdMobConfig {
  // Set to false when ready for production
  static const bool useTestAds = true;

  // ============================================
  // PRODUCTION AD UNIT IDs
  // ============================================
  // TODO: Replace these with your actual AdMob Ad Unit IDs

  // Android Production IDs
  static const String _androidInterstitialId =
      'ca-app-pub-9314487366819068/3440438510';
  static const String _androidRewardedId =
      'ca-app-pub-9314487366819068/8640794306';
  static const String _androidBannerId =
      'ca-app-pub-9314487366819068/5507596010';

  // iOS Production IDs
  static const String _iosInterstitialId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
  static const String _iosRewardedId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
  static const String _iosBannerId = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';

  // ============================================
  // TEST AD UNIT IDs (Google's official test IDs)
  // ============================================

  // Android Test IDs
  static const String _androidTestInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _androidTestRewardedId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _androidTestBannerId =
      'ca-app-pub-3940256099942544/6300978111';

  // iOS Test IDs
  static const String _iosTestInterstitialId =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _iosTestRewardedId =
      'ca-app-pub-3940256099942544/1712485313';
  static const String _iosTestBannerId =
      'ca-app-pub-3940256099942544/2934735716';

  // ============================================
  // PUBLIC GETTERS
  // ============================================

  /// Get the appropriate interstitial ad unit ID based on platform and mode
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return useTestAds ? _androidTestInterstitialId : _androidInterstitialId;
    } else if (Platform.isIOS) {
      return useTestAds ? _iosTestInterstitialId : _iosInterstitialId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Get the appropriate rewarded ad unit ID based on platform and mode
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return useTestAds ? _androidTestRewardedId : _androidRewardedId;
    } else if (Platform.isIOS) {
      return useTestAds ? _iosTestRewardedId : _iosRewardedId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Get the appropriate banner ad unit ID based on platform and mode
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return useTestAds ? _androidTestBannerId : _androidBannerId;
    } else if (Platform.isIOS) {
      return useTestAds ? _iosTestBannerId : _iosBannerId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Check if we're using test ads
  static bool get isTestMode => useTestAds;

  /// Get a description of the current mode
  static String get modeDescription =>
      useTestAds ? 'Test Mode' : 'Production Mode';
}
