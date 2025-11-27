import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:appzoque/features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';
import 'package:appzoque/features/admin/presentation/viewmodels/admin_viewmodel.dart';
import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'add_word_screen.dart';
import 'edit_word_screen.dart';

class ManageWordsScreen extends StatefulWidget {
  const ManageWordsScreen({super.key});

  @override
  State<ManageWordsScreen> createState() => _ManageWordsScreenState();
}

class _ManageWordsScreenState extends State<ManageWordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DictionaryViewModel>().loadWords();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<Word> _filterWords(List<Word> words) {
    if (_searchQuery.isEmpty) {
      return words;
    }
    return words.where((word) {
      return word.wordSpanish.toLowerCase().contains(_searchQuery) ||
          word.wordZoque.toLowerCase().contains(_searchQuery) ||
          word.category.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> _deleteWord(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '¿Eliminar palabra?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Esta acción no se puede deshacer.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: GoogleFonts.inter()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Eliminar', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AdminViewModel>().deleteWord(id);
      if (mounted) {
        final adminViewModel = context.read<AdminViewModel>();
        if (adminViewModel.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(adminViewModel.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
          // Reload words
          context.read<DictionaryViewModel>().loadWords();
        } else if (adminViewModel.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(adminViewModel.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestionar Diccionario',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar and Add Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Buscar palabras...',
                          hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddWordScreen(),
                            ),
                          ).then((_) {
                            // Reload words after adding
                            context.read<DictionaryViewModel>().loadWords();
                          });
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        tooltip: 'Agregar Palabra',
                      ),
                    ),
                  ],
                ),
              ),
              // Words List
              Expanded(
                child: Consumer<DictionaryViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (viewModel.error != null) {
                      return Center(
                        child: Text(
                          'Error: ${viewModel.error}',
                          style: GoogleFonts.inter(color: Colors.red),
                        ),
                      );
                    }

                    final filteredWords = _filterWords(viewModel.words);

                    if (filteredWords.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No hay palabras registradas'
                                  : 'No se encontraron resultados',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              word.wordSpanish,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  word.wordZoque,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    word.category,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditWordScreen(word: word),
                                      ),
                                    ).then((_) {
                                      // Reload words after editing
                                      context
                                          .read<DictionaryViewModel>()
                                          .loadWords();
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => _deleteWord(word.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
