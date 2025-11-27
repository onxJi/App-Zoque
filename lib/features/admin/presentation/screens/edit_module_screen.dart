import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/admin/presentation/viewmodels/admin_viewmodel.dart';

class EditModuleScreen extends StatefulWidget {
  final TeachingModule module;

  const EditModuleScreen({super.key, required this.module});

  @override
  State<EditModuleScreen> createState() => _EditModuleScreenState();
}

class _EditModuleScreenState extends State<EditModuleScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _titleZoqueController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _levelController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.module.title);
    _titleZoqueController = TextEditingController(
      text: widget.module.titleZoque,
    );
    _descriptionController = TextEditingController(
      text: widget.module.description,
    );
    _imageUrlController = TextEditingController(text: widget.module.imageUrl);
    _levelController = TextEditingController(text: widget.module.level);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleZoqueController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedModule = TeachingModule(
        id: widget.module.id,
        title: _titleController.text,
        titleZoque: _titleZoqueController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        level: _levelController.text,
        lessons: widget.module.lessons, // Keep existing lessons
      );

      await context.read<AdminViewModel>().updateModule(
        widget.module.id,
        updatedModule,
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
          'Editar Módulo',
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
                    'Editar Módulo',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      hintText: 'Ej: Saludos Básicos',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleZoqueController,
                    decoration: InputDecoration(
                      labelText: 'Título en Zoque',
                      hintText: 'Ej: Jemkuy',
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
                      hintText: 'Describe el módulo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'URL de Imagen',
                      hintText: 'https://...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.image),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la URL de la imagen';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _levelController,
                    decoration: InputDecoration(
                      labelText: 'Nivel',
                      hintText: 'Ej: Principiante, Intermedio, Avanzado',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.bar_chart),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el nivel';
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
