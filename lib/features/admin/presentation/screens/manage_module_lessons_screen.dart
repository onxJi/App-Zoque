import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:appzoque/features/admin/presentation/viewmodels/admin_viewmodel.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/presentation/viewmodels/teaching_viewmodel.dart';

import 'add_edit_lesson_screen.dart';

class ManageModuleLessonsScreen extends StatefulWidget {
  final TeachingModule module;

  const ManageModuleLessonsScreen({super.key, required this.module});

  @override
  State<ManageModuleLessonsScreen> createState() =>
      _ManageModuleLessonsScreenState();
}

class _ManageModuleLessonsScreenState extends State<ManageModuleLessonsScreen> {
  late TeachingModule _module;

  @override
  void initState() {
    super.initState();
    _module = widget.module;
  }

  Future<void> _refreshModules() async {
    final teachingVm = context.read<TeachingViewModel>();
    await teachingVm.loadModules();

    if (!mounted) return;

    try {
      final updated = teachingVm.modules.firstWhere((m) => m.id == _module.id);
      setState(() {
        _module = updated;
      });
    } catch (_) {
      // Module might have been deleted; keep current local reference.
    }
  }

  Future<void> _deleteLesson(TeachingLesson lesson) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '¿Eliminar lección?',
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

    if (confirmed != true || !mounted) return;

    final updatedLessons = List<TeachingLesson>.from(_module.lessons)
      ..removeWhere((l) => l.id == lesson.id);

    final updatedModule = TeachingModule(
      id: _module.id,
      title: _module.title,
      titleZoque: _module.titleZoque,
      description: _module.description,
      imageUrl: _module.imageUrl,
      level: _module.level,
      lessons: updatedLessons,
    );

    await context.read<AdminViewModel>().updateModule(_module.id, updatedModule);

    if (!mounted) return;

    final viewModel = context.read<AdminViewModel>();
    if (viewModel.successMessage != null) {
      setState(() {
        _module = updatedModule;
      });
      await _refreshModules();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.successMessage!),
          backgroundColor: Colors.green,
        ),
      );
    } else if (viewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lecciones del Módulo',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditLessonScreen(module: _module),
            ),
          );

          if (result == true && mounted) {
            await _refreshModules();
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _module.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _module.titleZoque,
                  style: GoogleFonts.inter(color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _module.lessons.isEmpty
                      ? Center(
                          child: Text(
                            'No hay lecciones registradas',
                            style: GoogleFonts.inter(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _module.lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = _module.lessons[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  lesson.title,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  '${lesson.type} • ${lesson.duration}',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      onPressed: () async {
                                        final result =
                                            await Navigator.push<bool>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddEditLessonScreen(
                                              module: _module,
                                              initialLesson: lesson,
                                            ),
                                          ),
                                        );

                                        if (result == true && mounted) {
                                          await _refreshModules();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () => _deleteLesson(lesson),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
