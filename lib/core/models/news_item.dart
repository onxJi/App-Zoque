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

  // Copiar con modificaciones
  NewsItem copyWith({
    String? id,
    String? titleSpanish,
    String? titleZoque,
    String? description,
    String? youtubeVideoId,
    String? thumbnailUrl,
    DateTime? publishedDate,
    String? category,
  }) {
    return NewsItem(
      id: id ?? this.id,
      titleSpanish: titleSpanish ?? this.titleSpanish,
      titleZoque: titleZoque ?? this.titleZoque,
      description: description ?? this.description,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      category: category ?? this.category,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleSpanish': titleSpanish,
      'titleZoque': titleZoque,
      'description': description,
      'youtubeVideoId': youtubeVideoId,
      'thumbnailUrl': thumbnailUrl,
      'publishedDate': publishedDate.toIso8601String(),
      'category': category,
    };
  }

  // Crear desde JSON
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String,
      titleSpanish: json['titleSpanish'] as String,
      titleZoque: json['titleZoque'] as String,
      description: json['description'] as String,
      youtubeVideoId: json['youtubeVideoId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      category: json['category'] as String,
    );
  }

  @override
  String toString() {
    return 'NewsItem(id: $id, titleSpanish: $titleSpanish, category: $category)';
  }

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
  int get hashCode {
    return Object.hash(
      id,
      titleSpanish,
      titleZoque,
      description,
      youtubeVideoId,
      thumbnailUrl,
      publishedDate,
      category,
    );
  }
}
