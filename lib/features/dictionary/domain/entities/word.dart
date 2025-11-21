class WordExample {
  final String zoque;
  final String spanish;

  const WordExample({required this.zoque, required this.spanish});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WordExample &&
        other.zoque == zoque &&
        other.spanish == spanish;
  }

  @override
  int get hashCode => Object.hash(zoque, spanish);
}

class Word {
  final String id;
  final String wordZoque;
  final String wordSpanish;
  final String pronunciation;
  final String category;
  final List<WordExample> examples;
  final String? audioUrl;

  const Word({
    required this.id,
    required this.wordZoque,
    required this.wordSpanish,
    required this.pronunciation,
    required this.category,
    required this.examples,
    this.audioUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Word &&
        other.id == id &&
        other.wordZoque == wordZoque &&
        other.wordSpanish == wordSpanish &&
        other.pronunciation == pronunciation &&
        other.category == category &&
        other.audioUrl == audioUrl;
  }

  @override
  int get hashCode => Object.hash(
    id,
    wordZoque,
    wordSpanish,
    pronunciation,
    category,
    audioUrl,
  );

  @override
  String toString() {
    return 'Word(id: $id, wordZoque: $wordZoque, wordSpanish: $wordSpanish)';
  }
}
