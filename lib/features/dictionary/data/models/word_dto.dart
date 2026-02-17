import '../../domain/entities/word.dart';

class WordExampleDTO {
  final String zoque;
  final String spanish;

  WordExampleDTO({required this.zoque, required this.spanish});

  factory WordExampleDTO.fromJson(Map<String, dynamic> json) {
    return WordExampleDTO(
      zoque: json['zoque']?.toString() ?? '',
      spanish: json['spanish']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'zoque': zoque, 'spanish': spanish};
  }

  WordExample toEntity() {
    return WordExample(zoque: zoque, spanish: spanish);
  }
}

class WordDTO {
  final String id;
  final String wordZoque;
  final String wordSpanish;
  final String pronunciation;
  final String category;
  final List<WordExampleDTO> examples;
  final String? audioUrl;

  WordDTO({
    required this.id,
    required this.wordZoque,
    required this.wordSpanish,
    required this.pronunciation,
    required this.category,
    required this.examples,
    this.audioUrl,
  });

  factory WordDTO.fromJson(Map<String, dynamic> json) {
    return WordDTO(
      id: json['id']?.toString() ?? '',
      wordZoque: json['wordZoque']?.toString() ?? '',
      wordSpanish: json['wordSpanish']?.toString() ?? '',
      pronunciation: json['pronunciation']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      examples:
          (json['examples'] as List<dynamic>?)
              ?.map((e) => WordExampleDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      audioUrl: json['audioUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wordZoque': wordZoque,
      'wordSpanish': wordSpanish,
      'pronunciation': pronunciation,
      'category': category,
      'examples': examples.map((e) => e.toJson()).toList(),
      'audioUrl': audioUrl,
    };
  }

  Word toEntity() {
    return Word(
      id: id,
      wordZoque: wordZoque,
      wordSpanish: wordSpanish,
      pronunciation: pronunciation,
      category: category,
      examples: examples.map((e) => e.toEntity()).toList(),
      audioUrl: audioUrl,
    );
  }
}
