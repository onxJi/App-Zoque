import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';

class TeachingLessonDTO {
  final String id;
  final String title;
  final String content;
  final String duration;

  const TeachingLessonDTO({
    required this.id,
    required this.title,
    required this.content,
    required this.duration,
  });

  factory TeachingLessonDTO.fromJson(Map<String, dynamic> json) {
    return TeachingLessonDTO(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      duration: json['duration'] as String,
    );
  }

  TeachingLesson toEntity() {
    return TeachingLesson(
      id: id,
      title: title,
      content: content,
      duration: duration,
    );
  }
}
