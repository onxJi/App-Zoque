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
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      type: json['type']?.toString() ?? 'vocabulary',
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'duration': duration,
      'type': type,
      'vocabulary': vocabulary.map((v) => v.toJson()).toList(),
      'examples': examples.map((e) => e.toJson()).toList(),
      'exercises': exercises.map((ex) => ex.toJson()).toList(),
    };
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

  factory TeachingLessonDTO.fromEntity(TeachingLesson entity) {
    return TeachingLessonDTO(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      duration: entity.duration,
      type: entity.type,
      vocabulary: entity.vocabulary
          .map((v) => VocabularyItemDTO.fromEntity(v))
          .toList(),
      examples: entity.examples
          .map((e) => LessonExampleDTO.fromEntity(e))
          .toList(),
      exercises: entity.exercises
          .map((ex) => ExerciseDTO.fromEntity(ex))
          .toList(),
    );
  }
}

class VocabularyItemDTO {
  final String word;
  final String translation;
  final String pronunciation;
  final String? audioUrl;

  const VocabularyItemDTO({
    required this.word,
    required this.translation,
    required this.pronunciation,
    this.audioUrl,
  });

  factory VocabularyItemDTO.fromJson(Map<String, dynamic> json) {
    return VocabularyItemDTO(
      word: json['word']?.toString() ?? json['zoque']?.toString() ?? '',
      translation:
          json['translation']?.toString() ?? json['spanish']?.toString() ?? '',
      pronunciation: json['pronunciation']?.toString() ?? '',
      audioUrl: json['audioUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      'pronunciation': pronunciation,
      'audioUrl': audioUrl,
    };
  }

  VocabularyItem toEntity() {
    return VocabularyItem(
      zoque: word,
      spanish: translation,
      pronunciation: pronunciation,
      audioUrl: audioUrl,
    );
  }

  factory VocabularyItemDTO.fromEntity(VocabularyItem entity) {
    return VocabularyItemDTO(
      word: entity.zoque,
      translation: entity.spanish,
      pronunciation: entity.pronunciation,
      audioUrl: entity.audioUrl,
    );
  }
}

class LessonExampleDTO {
  final String zoque;
  final String spanish;
  final String? context;

  const LessonExampleDTO({
    required this.zoque,
    required this.spanish,
    this.context,
  });

  factory LessonExampleDTO.fromJson(Map<String, dynamic> json) {
    return LessonExampleDTO(
      zoque: json['zoque']?.toString() ?? '',
      spanish: json['spanish']?.toString() ?? '',
      context: json['context']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'zoque': zoque, 'spanish': spanish, 'context': context};
  }

  LessonExample toEntity() {
    return LessonExample(
      zoque: zoque,
      spanish: spanish,
      context: context ?? '',
    );
  }

  factory LessonExampleDTO.fromEntity(LessonExample entity) {
    return LessonExampleDTO(
      zoque: entity.zoque,
      spanish: entity.spanish,
      context: entity.context,
    );
  }
}

class ExerciseDTO {
  final String? id;
  final String type;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? explanation;

  const ExerciseDTO({
    this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
  });

  factory ExerciseDTO.fromJson(Map<String, dynamic> json) {
    return ExerciseDTO(
      id: json['id']?.toString(),
      type: json['type']?.toString() ?? 'multiple_choice',
      question: json['question']?.toString() ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((o) => o?.toString() ?? '')
              .toList() ??
          [],
      correctAnswer: _parseCorrectAnswer(json['correctAnswer']),
      explanation: json['explanation']?.toString(),
    );
  }

  static int _parseCorrectAnswer(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      if (explanation != null) 'explanation': explanation,
    };
  }

  Exercise toEntity() {
    return Exercise(
      id: id ?? '',
      type: type,
      question: question,
      options: options,
      correctAnswer: correctAnswer.toString(),
      explanation: explanation ?? '',
    );
  }

  factory ExerciseDTO.fromEntity(Exercise entity) {
    return ExerciseDTO(
      id: entity.id,
      type: entity.type,
      question: entity.question,
      options: entity.options,
      correctAnswer: int.tryParse(entity.correctAnswer) ?? 0,
      explanation: entity.explanation,
    );
  }
}
