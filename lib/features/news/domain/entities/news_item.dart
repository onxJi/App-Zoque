class NewsItem {
  final String id;
  final String titleSpanish;
  final String titleZoque;
  final String description;
  final String youtubeVideoId;
  final String? thumbnailUrl;
  final DateTime publishedDate;
  final String category;

  const NewsItem({
    required this.id,
    required this.titleSpanish,
    required this.titleZoque,
    required this.description,
    required this.youtubeVideoId,
    this.thumbnailUrl,
    required this.publishedDate,
    required this.category,
  });

  // Obtener thumbnail de YouTube
  String get youtubeThumbnail =>
      thumbnailUrl ??
      'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewsItem &&
        other.id == id &&
        other.titleSpanish == titleSpanish &&
        other.titleZoque == titleZoque &&
        other.description == description &&
        other.youtubeVideoId == youtubeVideoId &&
        other.thumbnailUrl == thumbnailUrl &&
        other.publishedDate == publishedDate &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(
    id,
    titleSpanish,
    titleZoque,
    description,
    youtubeVideoId,
    thumbnailUrl,
    publishedDate,
    category,
  );

  @override
  String toString() {
    return 'NewsItem(id: $id, titleSpanish: $titleSpanish, category: $category)';
  }
}
