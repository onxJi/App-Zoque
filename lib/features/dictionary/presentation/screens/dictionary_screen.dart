import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dictionary_viewmodel.dart';
import '../widgets/word_card.dart';
import '../widgets/search_bar_widget.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  @override
  void initState() {
    super.initState();
    // Load words when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DictionaryViewModel>().loadWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // Search bar
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBarWidget(),
          ),

          // Content
          Expanded(
            child: Consumer<DictionaryViewModel>(
              builder: (context, viewModel, child) {
                // Loading state
                if (viewModel.isLoading && !viewModel.hasWords) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error state
                if (viewModel.error != null && !viewModel.hasWords) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            viewModel.error!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => viewModel.loadWords(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Empty state
                if (!viewModel.hasWords) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            viewModel.searchQuery.isEmpty
                                ? 'No hay palabras disponibles'
                                : 'No se encontraron resultados para "${viewModel.searchQuery}"',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Intenta con otra búsqueda',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Success state - List of words
                return RefreshIndicator(
                  onRefresh: () => viewModel.loadWords(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: viewModel.words.length,
                    itemBuilder: (context, index) {
                      return WordCard(word: viewModel.words[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
