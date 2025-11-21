import '../models/news_item.dart';

class NewsData {
  // Datos de ejemplo de noticias sobre cultura Zoque
  static final List<NewsItem> sampleNews = [
    NewsItem(
      id: '1',
      titleSpanish: 'Enséñame tu idioma',
      titleZoque: 'Tsakam wäy jama',
      description:
          'Fernando Sánchez, cantautor Zoque de San Miguel Chimalapas, comparte la belleza de la lengua zoque a través de la música. En esta emotiva canción, nos invita a conocer y preservar el idioma ancestral de su pueblo.',
      youtubeVideoId: 'XJvI1IzWCHw',
      publishedDate: DateTime(2024, 1, 15),
      category: 'Música',
    ),
    NewsItem(
      id: '2',
      titleSpanish: 'Celebración del Día de la Lengua Zoque',
      titleZoque: 'Shük tsoon xöö kax ta jna',
      description:
          'La comunidad zoque celebra un día especial dedicado a preservar y promover su lengua ancestral con diversas actividades culturales, talleres y presentaciones artísticas.',
      youtubeVideoId: 'XJvI1IzWCHw', // Placeholder - reemplazar con video real
      publishedDate: DateTime(2024, 2, 20),
      category: 'Cultura',
    ),
    NewsItem(
      id: '3',
      titleSpanish: 'Taller de Artesanías Tradicionales',
      titleZoque: 'Wäy tsakam pät\'äk',
      description:
          'Artesanos zoques comparten sus conocimientos sobre técnicas tradicionales de tejido y cerámica con las nuevas generaciones, manteniendo vivas las tradiciones ancestrales.',
      youtubeVideoId: 'XJvI1IzWCHw', // Placeholder - reemplazar con video real
      publishedDate: DateTime(2024, 3, 10),
      category: 'Artesanía',
    ),
    NewsItem(
      id: '4',
      titleSpanish: 'Festival de Música Autóctona',
      titleZoque: 'Jama tum pät\'äk',
      description:
          'Músicos de diferentes comunidades zoques se reúnen para compartir melodías tradicionales y crear nuevas composiciones que fusionan lo ancestral con lo contemporáneo.',
      youtubeVideoId: 'XJvI1IzWCHw', // Placeholder - reemplazar con video real
      publishedDate: DateTime(2024, 4, 5),
      category: 'Música',
    ),
    NewsItem(
      id: '5',
      titleSpanish: 'Rescate de Recetas Ancestrales',
      titleZoque: 'Tsakam wäy jama',
      description:
          'Cocineras tradicionales enseñan la preparación de platillos zoques que han pasado de generación en generación, preservando los sabores y técnicas culinarias ancestrales.',
      youtubeVideoId: 'XJvI1IzWCHw', // Placeholder - reemplazar con video real
      publishedDate: DateTime(2024, 5, 12),
      category: 'Gastronomía',
    ),
  ];

  // Helper para extraer video ID de diferentes formatos de URL de YouTube
  static String? extractYoutubeVideoId(String url) {
    // Patrones comunes de URLs de YouTube
    final patterns = [
      RegExp(r'(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&\?\/]+)'),
      RegExp(r'youtube\.com\/embed\/([^&\?\/]+)'),
      RegExp(r'youtube\.com\/v\/([^&\?\/]+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    // Si no coincide con ningún patrón, asumir que es el ID directamente
    if (url.length == 11 && !url.contains('/') && !url.contains('?')) {
      return url;
    }

    return null;
  }
}
