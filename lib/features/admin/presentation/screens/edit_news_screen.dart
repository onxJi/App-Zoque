import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/admin/presentation/viewmodels/admin_viewmodel.dart';

class EditNewsScreen extends StatefulWidget {
  final NewsItem newsItem;

  const EditNewsScreen({super.key, required this.newsItem});

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleSpanishController;
  late final TextEditingController _titleZoqueController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _youtubeVideoIdController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleSpanishController = TextEditingController(
      text: widget.newsItem.titleSpanish,
    );
    _titleZoqueController = TextEditingController(
      text: widget.newsItem.titleZoque,
    );
    _descriptionController = TextEditingController(
      text: widget.newsItem.description,
    );
    _youtubeVideoIdController = TextEditingController(
      text: widget.newsItem.youtubeVideoId,
    );
    _categoryController = TextEditingController(text: widget.newsItem.category);
  }

  @override
  void dispose() {
    _titleSpanishController.dispose();
    _titleZoqueController.dispose();
    _descriptionController.dispose();
    _youtubeVideoIdController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedNewsItem = NewsItem(
        id: widget.newsItem.id,
        titleSpanish: _titleSpanishController.text,
        titleZoque: _titleZoqueController.text,
        description: _descriptionController.text,
        youtubeVideoId: _youtubeVideoIdController.text,
        publishedDate: widget.newsItem.publishedDate, // Keep original date
        category: _categoryController.text,
        thumbnailUrl: widget.newsItem.thumbnailUrl, // Keep original thumbnail
      );

      await context.read<AdminViewModel>().updateNews(
        widget.newsItem.id,
        updatedNewsItem,
      );

      if (mounted) {
        final viewModel = context.read<AdminViewModel>();
        if (viewModel.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (viewModel.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(viewModel.error!),
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
          'Editar Noticia',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AdminViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Editar Noticia',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _titleSpanishController,
                    decoration: InputDecoration(
                      labelText: 'Título en Español',
                      hintText: 'Ingresa el título de la noticia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el título en español';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleZoqueController,
                    decoration: InputDecoration(
                      labelText: 'Título en Zoque',
                      hintText: 'Ingresa el título en zoque',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.language),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el título en zoque';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Describe la noticia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _youtubeVideoIdController,
                    decoration: InputDecoration(
                      labelText: 'ID del Video de YouTube',
                      hintText: 'Ej: dQw4w9WgXcQ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.video_library),
                      helperText: 'Solo el ID del video, no la URL completa',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el ID del video';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      hintText: 'Ej: Cultura, Eventos, Educación',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la categoría';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Guardar Cambios',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
