/// Entity representing an AdMob advertisement
class Ad {
  final String adUnitId;
  final AdType type;
  final AdStatus status;

  Ad({
    required this.adUnitId,
    required this.type,
    this.status = AdStatus.notLoaded,
  });

  Ad copyWith({String? adUnitId, AdType? type, AdStatus? status}) {
    return Ad(
      adUnitId: adUnitId ?? this.adUnitId,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}

/// Types of ads supported
enum AdType { interstitial, rewarded, banner }

/// Status of an ad
enum AdStatus { notLoaded, loading, loaded, failed, showing, closed }
