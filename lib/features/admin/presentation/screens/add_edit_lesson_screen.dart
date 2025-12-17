import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:appzoque/features/admin/presentation/viewmodels/admin_viewmodel.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';

class AddEditLessonScreen extends StatefulWidget {
  final TeachingModule module;
  final TeachingLesson? initialLesson;

  const AddEditLessonScreen({
    super.key,
    required this.module,
    this.initialLesson,
  });

  @override
  State<AddEditLessonScreen> createState() => _AddEditLessonScreenState();
}

class _AddEditLessonScreenState extends State<AddEditLessonScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _durationController;
  late String _type;

  final List<_VocabularyControllers> _vocabulary = [];
  final List<_ExampleControllers> _examples = [];
  final List<_ExerciseControllers> _exercises = [];

  bool get _isEditing => widget.initialLesson != null;

  @override
  void initState() {
    super.initState();

    final lesson = widget.initialLesson;

    _titleController = TextEditingController(text: lesson?.title ?? '');
    _contentController = TextEditingController(text: lesson?.content ?? '');
    _durationController = TextEditingController(text: lesson?.duration ?? '');
    _type = lesson?.type ?? 'vocabulary';

    for (final v in lesson?.vocabulary ?? const <VocabularyItem>[]) {
      _vocabulary.add(
        _VocabularyControllers(
          zoque: TextEditingController(text: v.zoque),
          spanish: TextEditingController(text: v.spanish),
          pronunciation: TextEditingController(text: v.pronunciation),
          audioUrl: TextEditingController(text: v.audioUrl ?? ''),
        ),
      );
    }

    for (final e in lesson?.examples ?? const <LessonExample>[]) {
      _examples.add(
        _ExampleControllers(
          zoque: TextEditingController(text: e.zoque),
          spanish: TextEditingController(text: e.spanish),
          context: TextEditingController(text: e.context),
        ),
      );
    }

    for (final ex in lesson?.exercises ?? const <Exercise>[]) {
      _exercises.add(
        _ExerciseControllers(
          id: TextEditingController(text: ex.id),
          type: TextEditingController(text: ex.type),
          question: TextEditingController(text: ex.question),
          options: TextEditingController(text: ex.options.join(', ')),
          correctAnswer: TextEditingController(text: ex.correctAnswer),
          explanation: TextEditingController(text: ex.explanation),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _durationController.dispose();

    for (final v in _vocabulary) {
      v.dispose();
    }
    for (final e in _examples) {
      e.dispose();
    }
    for (final ex in _exercises) {
      ex.dispose();
    }

    super.dispose();
  }

  void _addVocabularyItem() {
    setState(() {
      _vocabulary.add(_VocabularyControllers.empty());
    });
  }

  void _addExample() {
    setState(() {
      _examples.add(_ExampleControllers.empty());
    });
  }

  void _addExercise() {
    setState(() {
      _exercises.add(
        _ExerciseControllers(
          id: TextEditingController(
            text: DateTime.now().millisecondsSinceEpoch.toString(),
          ),
          type: TextEditingController(text: 'multiple_choice'),
          question: TextEditingController(),
          options: TextEditingController(),
          correctAnswer: TextEditingController(),
          explanation: TextEditingController(),
        ),
      );
    });
  }

  List<VocabularyItem> _buildVocabulary() {
    return _vocabulary
        .where(
          (v) =>
              v.zoque.text.trim().isNotEmpty ||
              v.spanish.text.trim().isNotEmpty ||
              v.pronunciation.text.trim().isNotEmpty ||
              v.audioUrl.text.trim().isNotEmpty,
        )
        .map(
          (v) => VocabularyItem(
            zoque: v.zoque.text.trim(),
            spanish: v.spanish.text.trim(),
            pronunciation: v.pronunciation.text.trim(),
            audioUrl: v.audioUrl.text.trim().isEmpty ? null : v.audioUrl.text,
          ),
        )
        .toList();
  }

  List<LessonExample> _buildExamples() {
    return _examples
        .where(
          (e) =>
              e.zoque.text.trim().isNotEmpty ||
              e.spanish.text.trim().isNotEmpty ||
              e.context.text.trim().isNotEmpty,
        )
        .map(
          (e) => LessonExample(
            zoque: e.zoque.text.trim(),
            spanish: e.spanish.text.trim(),
            context: e.context.text.trim(),
          ),
        )
        .toList();
  }

  List<Exercise> _buildExercises() {
    return _exercises
        .where(
          (ex) =>
              ex.question.text.trim().isNotEmpty ||
              ex.options.text.trim().isNotEmpty ||
              ex.correctAnswer.text.trim().isNotEmpty,
        )
        .map(
          (ex) {
            final options = ex.options.text
                .split(',')
                .map((o) => o.trim())
                .where((o) => o.isNotEmpty)
                .toList();

            return Exercise(
              id: ex.id.text.trim().isEmpty
                  ? DateTime.now().millisecondsSinceEpoch.toString()
                  : ex.id.text.trim(),
              type: ex.type.text.trim().isEmpty
                  ? 'multiple_choice'
                  : ex.type.text.trim(),
              question: ex.question.text.trim(),
              options: options,
              correctAnswer: ex.correctAnswer.text.trim(),
              explanation: ex.explanation.text.trim(),
            );
          },
        )
        .toList();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final lessonId = _isEditing
        ? widget.initialLesson!.id
        : DateTime.now().millisecondsSinceEpoch.toString();

    final newLesson = TeachingLesson(
      id: lessonId,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      duration: _durationController.text.trim(),
      type: _type,
      vocabulary: _buildVocabulary(),
      examples: _buildExamples(),
      exercises: _buildExercises(),
      isCompleted: _isEditing ? widget.initialLesson!.isCompleted : false,
    );

    await context.read<AdminViewModel>().saveLesson(widget.module.id, newLesson);

    if (!mounted) return;

    final vm = context.read<AdminViewModel>();
    if (vm.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.successMessage!),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else if (vm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.error!),
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
          _isEditing ? 'Editar Lección' : 'Agregar Lección',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AdminViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingresa el título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Contenido',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingresa el contenido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Duración',
                      hintText: 'Ej: 5 min',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.timer),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingresa la duración';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(
                        value: 'vocabulary',
                        child: Text('vocabulary'),
                      ),
                      DropdownMenuItem(value: 'grammar', child: Text('grammar')),
                      DropdownMenuItem(
                        value: 'practice',
                        child: Text('practice'),
                      ),
                      DropdownMenuItem(value: 'video', child: Text('video')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _type = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionCard(
                    title: 'Vocabulario',
                    onAdd: _addVocabularyItem,
                    child: _vocabulary.isEmpty
                        ? Text(
                            'Sin vocabulario',
                            style: GoogleFonts.inter(color: Colors.grey[600]),
                          )
                        : Column(
                            children: [
                              for (int i = 0; i < _vocabulary.length; i++)
                                _VocabularyRow(
                                  key: ValueKey('vocab_$i'),
                                  controllers: _vocabulary[i],
                                  onRemove: () {
                                    setState(() {
                                      _vocabulary[i].dispose();
                                      _vocabulary.removeAt(i);
                                    });
                                  },
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Ejemplos',
                    onAdd: _addExample,
                    child: _examples.isEmpty
                        ? Text(
                            'Sin ejemplos',
                            style: GoogleFonts.inter(color: Colors.grey[600]),
                          )
                        : Column(
                            children: [
                              for (int i = 0; i < _examples.length; i++)
                                _ExampleRow(
                                  key: ValueKey('example_$i'),
                                  controllers: _examples[i],
                                  onRemove: () {
                                    setState(() {
                                      _examples[i].dispose();
                                      _examples.removeAt(i);
                                    });
                                  },
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Ejercicios',
                    onAdd: _addExercise,
                    child: _exercises.isEmpty
                        ? Text(
                            'Sin ejercicios',
                            style: GoogleFonts.inter(color: Colors.grey[600]),
                          )
                        : Column(
                            children: [
                              for (int i = 0; i < _exercises.length; i++)
                                _ExerciseCard(
                                  key: ValueKey('exercise_$i'),
                                  controllers: _exercises[i],
                                  onRemove: () {
                                    setState(() {
                                      _exercises[i].dispose();
                                      _exercises.removeAt(i);
                                    });
                                  },
                                ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : _submit,
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
                            _isEditing ? 'Guardar Cambios' : 'Agregar Lección',
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

class _SectionCard extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.onAdd,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _VocabularyRow extends StatelessWidget {
  final _VocabularyControllers controllers;
  final VoidCallback onRemove;

  const _VocabularyRow({
    super.key,
    required this.controllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controllers.zoque,
                  decoration: InputDecoration(
                    labelText: 'Zoque',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controllers.spanish,
                  decoration: InputDecoration(
                    labelText: 'Español',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controllers.pronunciation,
                  decoration: InputDecoration(
                    labelText: 'Pronunciación',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controllers.audioUrl,
                  decoration: InputDecoration(
                    labelText: 'Audio URL (opcional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  final _ExampleControllers controllers;
  final VoidCallback onRemove;

  const _ExampleRow({
    super.key,
    required this.controllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controllers.zoque,
                  decoration: InputDecoration(
                    labelText: 'Zoque',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controllers.spanish,
                  decoration: InputDecoration(
                    labelText: 'Español',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controllers.context,
            decoration: InputDecoration(
              labelText: 'Contexto',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final _ExerciseControllers controllers;
  final VoidCallback onRemove;

  const _ExerciseCard({
    super.key,
    required this.controllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ejercicio',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllers.type,
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        hintText: 'multiple_choice, fill_blank, match',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: controllers.id,
                      decoration: InputDecoration(
                        labelText: 'ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controllers.question,
                decoration: InputDecoration(
                  labelText: 'Pregunta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controllers.options,
                decoration: InputDecoration(
                  labelText: 'Opciones (separadas por coma)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controllers.correctAnswer,
                decoration: InputDecoration(
                  labelText: 'Respuesta correcta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controllers.explanation,
                decoration: InputDecoration(
                  labelText: 'Explicación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VocabularyControllers {
  final TextEditingController zoque;
  final TextEditingController spanish;
  final TextEditingController pronunciation;
  final TextEditingController audioUrl;

  _VocabularyControllers({
    required this.zoque,
    required this.spanish,
    required this.pronunciation,
    required this.audioUrl,
  });

  factory _VocabularyControllers.empty() {
    return _VocabularyControllers(
      zoque: TextEditingController(),
      spanish: TextEditingController(),
      pronunciation: TextEditingController(),
      audioUrl: TextEditingController(),
    );
  }

  void dispose() {
    zoque.dispose();
    spanish.dispose();
    pronunciation.dispose();
    audioUrl.dispose();
  }
}

class _ExampleControllers {
  final TextEditingController zoque;
  final TextEditingController spanish;
  final TextEditingController context;

  _ExampleControllers({
    required this.zoque,
    required this.spanish,
    required this.context,
  });

  factory _ExampleControllers.empty() {
    return _ExampleControllers(
      zoque: TextEditingController(),
      spanish: TextEditingController(),
      context: TextEditingController(),
    );
  }

  void dispose() {
    zoque.dispose();
    spanish.dispose();
    context.dispose();
  }
}

class _ExerciseControllers {
  final TextEditingController id;
  final TextEditingController type;
  final TextEditingController question;
  final TextEditingController options;
  final TextEditingController correctAnswer;
  final TextEditingController explanation;

  _ExerciseControllers({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  void dispose() {
    id.dispose();
    type.dispose();
    question.dispose();
    options.dispose();
    correctAnswer.dispose();
    explanation.dispose();
  }
}
