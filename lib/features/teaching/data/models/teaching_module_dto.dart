import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'teaching_lesson_dto.dart';

class TeachingModuleDTO {
  final String id;
  final String title;
  final String titleZoque;
  final String description;
  final String imageUrl;
  final String level;
  final List<TeachingLessonDTO> lessons;

  const TeachingModuleDTO({
    required this.id,
    required this.title,
    required this.titleZoque,
    required this.description,
    required this.imageUrl,
    required this.level,
    required this.lessons,
  });

  factory TeachingModuleDTO.fromJson(Map<String, dynamic> json) {
    return TeachingModuleDTO(
      id: json['id'] as String,
      title: json['title'] as String,
      titleZoque: json['titleZoque'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      level: json['level'] as String,
      lessons:
          (json['lessons'] as List<dynamic>?)
              ?.map(
                (e) => TeachingLessonDTO.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  TeachingModule toEntity() {
    return TeachingModule(
      id: id,
      title: title,
      titleZoque: titleZoque,
      description: description,
      imageUrl: imageUrl,
      level: level,
      lessons: lessons.map((dto) => dto.toEntity()).toList(),
    );
  }
}
