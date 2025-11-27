class TeachingLesson {
  final String id;
  final String title;
  final String content;
  final String duration;
  final String type; // 'vocabulary', 'grammar', 'practice', 'video'
  final List<VocabularyItem> vocabulary;
  final List<LessonExample> examples;
  final List<Exercise> exercises;
  final bool isCompleted;

  const TeachingLesson({
    required this.id,
    required this.title,
    required this.content,
    required this.duration,
    this.type = 'vocabulary',
    this.vocabulary = const [],
    this.examples = const [],
    this.exercises = const [],
    this.isCompleted = false,
  });
}

class VocabularyItem {
  final String zoque;
  final String spanish;
  final String pronunciation;
  final String? audioUrl;

  const VocabularyItem({
    required this.zoque,
    required this.spanish,
    required this.pronunciation,
    this.audioUrl,
  });
}

class LessonExample {
  final String zoque;
  final String spanish;
  final String context;

  const LessonExample({
    required this.zoque,
    required this.spanish,
    required this.context,
  });
}

class Exercise {
  final String id;
  final String type; // 'multiple_choice', 'fill_blank', 'match'
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  const Exercise({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
