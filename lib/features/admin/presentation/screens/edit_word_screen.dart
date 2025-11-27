import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/admin/presentation/viewmodels/admin_viewmodel.dart';

class EditWordScreen extends StatefulWidget {
  final Word word;

  const EditWordScreen({super.key, required this.word});

  @override
  State<EditWordScreen> createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _spanishController;
  late final TextEditingController _zoqueController;
  late final TextEditingController _categoryController;
  late final TextEditingController _pronunciationController;

  @override
  void initState() {
    super.initState();
    _spanishController = TextEditingController(text: widget.word.wordSpanish);
    _zoqueController = TextEditingController(text: widget.word.wordZoque);
    _categoryController = TextEditingController(text: widget.word.category);
    _pronunciationController = TextEditingController(
      text: widget.word.pronunciation,
    );
  }

  @override
  void dispose() {
    _spanishController.dispose();
    _zoqueController.dispose();
    _categoryController.dispose();
    _pronunciationController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedWord = Word(
        id: widget.word.id,
        wordSpanish: _spanishController.text,
        wordZoque: _zoqueController.text,
        pronunciation: _pronunciationController.text,
        category: _categoryController.text,
        examples: widget.word.examples, // Keep existing examples
        audioUrl: widget.word.audioUrl, // Keep existing audio
      );

      await context.read<AdminViewModel>().updateWord(
        widget.word.id,
        updatedWord,
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
          'Editar Palabra',
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
                    'Editar Palabra',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _spanishController,
                    decoration: InputDecoration(
                      labelText: 'Español',
                      hintText: 'Ingresa la palabra en español',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.translate),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la palabra en español';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _zoqueController,
                    decoration: InputDecoration(
                      labelText: 'Zoque',
                      hintText: 'Ingresa la palabra en zoque',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.language),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la palabra en zoque';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pronunciationController,
                    decoration: InputDecoration(
                      labelText: 'Pronunciación',
                      hintText: 'Ingresa la pronunciación',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.record_voice_over),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      hintText: 'Ej: Saludos, Números, etc.',
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
