import 'package:appzoque/features/news/domain/entities/news_item.dart';

class NewsItemDTO {
  final String id;
  final String titleSpanish;
  final String titleZoque;
  final String description;
  final String youtubeVideoId;
  final String? thumbnailUrl;
  final String publishedDate;
  final String category;

  const NewsItemDTO({
    required this.id,
    required this.titleSpanish,
    required this.titleZoque,
    required this.description,
    required this.youtubeVideoId,
    this.thumbnailUrl,
    required this.publishedDate,
    required this.category,
  });

  // Convert from JSON
  factory NewsItemDTO.fromJson(Map<String, dynamic> json) {
    return NewsItemDTO(
      id: json['id'] as String,
      titleSpanish: json['titleSpanish'] as String,
      titleZoque: json['titleZoque'] as String,
      description: json['description'] as String,
      youtubeVideoId: json['youtubeVideoId'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      publishedDate: json['publishedDate'] as String,
      category: json['category'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleSpanish': titleSpanish,
      'titleZoque': titleZoque,
      'description': description,
      'youtubeVideoId': youtubeVideoId,
      'thumbnailUrl': thumbnailUrl,
      'publishedDate': publishedDate,
      'category': category,
    };
  }

  // Convert to domain entity
  NewsItem toEntity() {
    return NewsItem(
      id: id,
      titleSpanish: titleSpanish,
      titleZoque: titleZoque,
      description: description,
      youtubeVideoId: youtubeVideoId,
      thumbnailUrl: thumbnailUrl,
      publishedDate: DateTime.parse(publishedDate),
      category: category,
    );
  }

  // Create from domain entity
  factory NewsItemDTO.fromEntity(NewsItem entity) {
    return NewsItemDTO(
      id: entity.id,
      titleSpanish: entity.titleSpanish,
      titleZoque: entity.titleZoque,
      description: entity.description,
      youtubeVideoId: entity.youtubeVideoId,
      thumbnailUrl: entity.thumbnailUrl,
      publishedDate: entity.publishedDate.toIso8601String(),
      category: entity.category,
    );
  }
}
