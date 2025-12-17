import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:appzoque/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';
import '../../domain/entities/word.dart';
import '../screens/word_detail_screen.dart';

class WordCard extends StatelessWidget {
  final Word word;

  const WordCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final favoritesVm = context.watch<FavoritesViewModel>();
    final isFavorite = favoritesVm.isWordFavorite(word.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Quitar el foco del TextField para cerrar el teclado
          FocusScope.of(context).unfocus();

          // Navegar a la pantalla de detalle
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WordDetailScreen(word: word),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon based on category
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getCategoryIcon(word.category),
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Word content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Zoque word
                    Text(
                      word.wordZoque,
                      style: GoogleFonts.notoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Spanish translation
                    Text(
                      word.wordSpanish,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        word.category,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: favoritesVm.isLoading
                        ? null
                        : () async {
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
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey.shade600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sustantivo':
        return Icons.article;
      case 'verbo':
        return Icons.directions_run;
      case 'adjetivo':
        return Icons.star;
      case 'preposición':
        return Icons.link;
      case 'pronombre':
        return Icons.person;
      default:
        return Icons.text_fields;
    }
  }
}
