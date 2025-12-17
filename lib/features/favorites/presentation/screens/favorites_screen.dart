import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:appzoque/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:appzoque/features/news/presentation/viewmodels/news_viewmodel.dart';
import 'package:appzoque/features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/news/presentation/screens/news_detail_screen.dart';
import 'package:appzoque/features/dictionary/presentation/screens/word_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<FavoritesViewModel>().loadFavorites();
      await context.read<NewsViewModel>().loadNews();
      await context.read<DictionaryViewModel>().loadWords();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NewsItem> _resolveFavoriteNews(
    FavoritesViewModel favoritesVm,
    NewsViewModel newsVm,
  ) {
    final ids = favoritesVm.favoriteNewsIds;
    final items = newsVm.newsItems.where((n) => ids.contains(n.id)).toList();
    return items;
  }

  List<Word> _resolveFavoriteWords(
    FavoritesViewModel favoritesVm,
    DictionaryViewModel dictionaryVm,
  ) {
    final ids = favoritesVm.favoriteWordIds;
    final items = dictionaryVm.words.where((w) => ids.contains(w.id)).toList();
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoritos',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Noticias'),
            Tab(text: 'Diccionario'),
          ],
        ),
      ),
      body: Consumer3<FavoritesViewModel, NewsViewModel, DictionaryViewModel>(
        builder: (context, favoritesVm, newsVm, dictVm, child) {
          if (favoritesVm.isLoading &&
              favoritesVm.favoriteNewsIds.isEmpty &&
              favoritesVm.favoriteWordIds.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoritesVm.error != null &&
              favoritesVm.favoriteNewsIds.isEmpty &&
              favoritesVm.favoriteWordIds.isEmpty) {
            return Center(
              child: Text(
                favoritesVm.error!,
                style: GoogleFonts.inter(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          final favoriteNews = _resolveFavoriteNews(favoritesVm, newsVm);
          final favoriteWords = _resolveFavoriteWords(favoritesVm, dictVm);

          return TabBarView(
            controller: _tabController,
            children: [
              _FavoritesNewsTab(
                items: favoriteNews,
                onOpen: (item) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NewsDetailScreen(newsItem: item),
                    ),
                  );
                },
                onToggleFavorite: (item) async {
                  await favoritesVm.toggleNewsFavorite(item.id);
                  if (!context.mounted) return;
                  if (favoritesVm.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(favoritesVm.successMessage!),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (favoritesVm.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(favoritesVm.error!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                isFavorite: favoritesVm.isNewsFavorite,
              ),
              _FavoritesWordsTab(
                items: favoriteWords,
                onOpen: (word) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WordDetailScreen(word: word),
                    ),
                  );
                },
                onToggleFavorite: (word) async {
                  await favoritesVm.toggleWordFavorite(word.id);
                  if (!context.mounted) return;
                  if (favoritesVm.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(favoritesVm.successMessage!),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (favoritesVm.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(favoritesVm.error!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                isFavorite: favoritesVm.isWordFavorite,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FavoritesNewsTab extends StatelessWidget {
  final List<NewsItem> items;
  final void Function(NewsItem item) onOpen;
  final Future<void> Function(NewsItem item) onToggleFavorite;
  final bool Function(String newsId) isFavorite;

  const _FavoritesNewsTab({
    required this.items,
    required this.onOpen,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No tienes noticias favoritas',
          style: GoogleFonts.inter(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () => onOpen(item),
            title: Text(
              item.titleSpanish,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              item.category,
              style: GoogleFonts.inter(color: Colors.grey[700]),
            ),
            trailing: IconButton(
              onPressed: () => onToggleFavorite(item),
              icon: Icon(
                isFavorite(item.id) ? Icons.favorite : Icons.favorite_border,
                color: isFavorite(item.id) ? Colors.red : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FavoritesWordsTab extends StatelessWidget {
  final List<Word> items;
  final void Function(Word word) onOpen;
  final Future<void> Function(Word word) onToggleFavorite;
  final bool Function(String wordId) isFavorite;

  const _FavoritesWordsTab({
    required this.items,
    required this.onOpen,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No tienes palabras favoritas',
          style: GoogleFonts.inter(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final word = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () => onOpen(word),
            title: Text(
              word.wordZoque,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              word.wordSpanish,
              style: GoogleFonts.inter(color: Colors.grey[700]),
            ),
            trailing: IconButton(
              onPressed: () => onToggleFavorite(word),
              icon: Icon(
                isFavorite(word.id) ? Icons.favorite : Icons.favorite_border,
                color: isFavorite(word.id) ? Colors.red : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
