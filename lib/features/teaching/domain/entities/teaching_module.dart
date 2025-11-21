import 'teaching_lesson.dart';

class TeachingModule {
  final String id;
  final String title;
  final String titleZoque;
  final String description;
  final String imageUrl;
  final String level;
  final List<TeachingLesson> lessons;

  const TeachingModule({
    required this.id,
    required this.title,
    required this.titleZoque,
    required this.description,
    required this.imageUrl,
    required this.level,
    required this.lessons,
  });
}
