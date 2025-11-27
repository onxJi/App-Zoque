import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';

class TeachingLessonDTO {
  final String id;
  final String title;
  final String content;
  final String duration;
  final String type;
  final List<VocabularyItemDTO> vocabulary;
  final List<LessonExampleDTO> examples;
  final List<ExerciseDTO> exercises;

  const TeachingLessonDTO({
    required this.id,
    required this.title,
    required this.content,
    required this.duration,
    this.type = 'vocabulary',
    this.vocabulary = const [],
    this.examples = const [],
    this.exercises = const [],
  });

  factory TeachingLessonDTO.fromJson(Map<String, dynamic> json) {
    return TeachingLessonDTO(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      duration: json['duration'] as String,
      type: json['type'] as String? ?? 'vocabulary',
      vocabulary:
          (json['vocabulary'] as List<dynamic>?)
              ?.map(
                (v) => VocabularyItemDTO.fromJson(v as Map<String, dynamic>),
              )
              .toList() ??
          [],
      examples:
          (json['examples'] as List<dynamic>?)
              ?.map((e) => LessonExampleDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exercises:
          (json['exercises'] as List<dynamic>?)
              ?.map((ex) => ExerciseDTO.fromJson(ex as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  TeachingLesson toEntity() {
    return TeachingLesson(
      id: id,
      title: title,
      content: content,
      duration: duration,
      type: type,
      vocabulary: vocabulary.map((v) => v.toEntity()).toList(),
      examples: examples.map((e) => e.toEntity()).toList(),
      exercises: exercises.map((ex) => ex.toEntity()).toList(),
    );
  }
}

class VocabularyItemDTO {
  final String zoque;
  final String spanish;
  final String pronunciation;
  final String? audioUrl;

  const VocabularyItemDTO({
    required this.zoque,
    required this.spanish,
    required this.pronunciation,
    this.audioUrl,
  });

  factory VocabularyItemDTO.fromJson(Map<String, dynamic> json) {
    return VocabularyItemDTO(
      zoque: json['zoque'] as String,
      spanish: json['spanish'] as String,
      pronunciation: json['pronunciation'] as String,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  VocabularyItem toEntity() {
    return VocabularyItem(
      zoque: zoque,
      spanish: spanish,
      pronunciation: pronunciation,
      audioUrl: audioUrl,
    );
  }
}

class LessonExampleDTO {
  final String zoque;
  final String spanish;
  final String context;

  const LessonExampleDTO({
    required this.zoque,
    required this.spanish,
    required this.context,
  });

  factory LessonExampleDTO.fromJson(Map<String, dynamic> json) {
    return LessonExampleDTO(
      zoque: json['zoque'] as String,
      spanish: json['spanish'] as String,
      context: json['context'] as String,
    );
  }

  LessonExample toEntity() {
    return LessonExample(zoque: zoque, spanish: spanish, context: context);
  }
}

class ExerciseDTO {
  final String id;
  final String type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  const ExerciseDTO({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory ExerciseDTO.fromJson(Map<String, dynamic> json) {
    return ExerciseDTO(
      id: json['id'] as String,
      type: json['type'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((o) => o as String)
          .toList(),
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String,
    );
  }

  Exercise toEntity() {
    return Exercise(
      id: id,
      type: type,
      question: question,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
    );
  }
}
