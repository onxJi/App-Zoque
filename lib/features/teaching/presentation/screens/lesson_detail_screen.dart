import 'package:appzoque/features/teaching/domain/entities/teaching_lesson.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonDetailScreen extends StatefulWidget {
  final TeachingLesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  int _currentSection = 0; // 0: vocabulary, 1: examples, 2: exercises
  int _currentExerciseIndex = 0;
  String? _selectedAnswer;
  bool _showExplanation = false;
  final Map<String, String> _userAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(child: _buildCurrentSection()),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildProgressStep(0, 'Vocabulario', Icons.book),
          _buildProgressDivider(),
          _buildProgressStep(1, 'Ejemplos', Icons.lightbulb_outline),
          _buildProgressDivider(),
          _buildProgressStep(2, 'Ejercicios', Icons.quiz),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int index, String label, IconData icon) {
    final isActive = _currentSection == index;
    final isCompleted = _currentSection > index;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive || isCompleted
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDivider() {
    return Container(
      width: 20,
      height: 2,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 20),
    );
  }

  Widget _buildCurrentSection() {
    switch (_currentSection) {
      case 0:
        return _buildVocabularySection();
      case 1:
        return _buildExamplesSection();
      case 2:
        return _buildExercisesSection();
      default:
        return const SizedBox();
    }
  }

  Widget _buildVocabularySection() {
    if (widget.lesson.vocabulary.isEmpty) {
      return _buildEmptyState('No hay vocabulario disponible');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Vocabulario',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Aprende estas palabras y frases en Zoque',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        ...widget.lesson.vocabulary.map((item) => _buildVocabularyCard(item)),
      ],
    );
  }

  Widget _buildVocabularyCard(VocabularyItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.zoque,
                        style: GoogleFonts.notoSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.spanish,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Play audio pronunciation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Audio no disponible aún'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.volume_up,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.record_voice_over,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.pronunciation,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesSection() {
    if (widget.lesson.examples.isEmpty) {
      return _buildEmptyState('No hay ejemplos disponibles');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Ejemplos',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Mira cómo se usan estas palabras en contexto',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        ...widget.lesson.examples.map((example) => _buildExampleCard(example)),
      ],
    );
  }

  Widget _buildExampleCard(LessonExample example) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                example.zoque,
                style: GoogleFonts.notoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              example.spanish,
              style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    example.context,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExercisesSection() {
    if (widget.lesson.exercises.isEmpty) {
      return _buildEmptyState('No hay ejercicios disponibles');
    }

    final exercise = widget.lesson.exercises[_currentExerciseIndex];
    final isAnswered = _userAnswers.containsKey(exercise.id);
    final isCorrect = _userAnswers[exercise.id] == exercise.correctAnswer;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ejercicio ${_currentExerciseIndex + 1} de ${widget.lesson.exercises.length}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (isAnswered)
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 28,
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            exercise.question,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          ...exercise.options.map(
            (option) => _buildOptionCard(option, exercise, isAnswered),
          ),
          if (_showExplanation && isAnswered) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCorrect
                      ? Colors.green.shade200
                      : Colors.orange.shade200,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: isCorrect
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explicación',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: isCorrect
                                ? Colors.green.shade900
                                : Colors.orange.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exercise.explanation,
                          style: GoogleFonts.inter(
                            color: isCorrect
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionCard(String option, Exercise exercise, bool isAnswered) {
    final isSelected = _selectedAnswer == option;
    final isCorrectAnswer = option == exercise.correctAnswer;
    final showCorrect = isAnswered && isCorrectAnswer;
    final showIncorrect = isAnswered && isSelected && !isCorrectAnswer;

    Color? backgroundColor;
    Color? borderColor;
    if (showCorrect) {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade400;
    } else if (showIncorrect) {
      backgroundColor = Colors.red.shade50;
      borderColor = Colors.red.shade400;
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
      borderColor = Theme.of(context).colorScheme.primary;
    }

    return GestureDetector(
      onTap: isAnswered
          ? null
          : () {
              setState(() {
                _selectedAnswer = option;
              });
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor ?? Colors.grey.shade400,
                  width: 2,
                ),
                color: (showCorrect || showIncorrect)
                    ? (showCorrect ? Colors.green : Colors.red)
                    : (isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent),
              ),
              child: (showCorrect || showIncorrect)
                  ? Icon(
                      showCorrect ? Icons.check : Icons.close,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isExerciseSection = _currentSection == 2;
    final hasMoreExercises =
        isExerciseSection &&
        _currentExerciseIndex < widget.lesson.exercises.length - 1;
    final isLastSection = _currentSection == 2;
    final canGoNext =
        !isExerciseSection ||
        _userAnswers.containsKey(
          widget.lesson.exercises[_currentExerciseIndex].id,
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentSection > 0 ||
              (isExerciseSection && _currentExerciseIndex > 0))
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    if (isExerciseSection && _currentExerciseIndex > 0) {
                      _currentExerciseIndex--;
                      _selectedAnswer = null;
                      _showExplanation = false;
                    } else {
                      _currentSection--;
                      _selectedAnswer = null;
                      _showExplanation = false;
                    }
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Anterior',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          if (_currentSection > 0 ||
              (isExerciseSection && _currentExerciseIndex > 0))
            const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                if (isExerciseSection &&
                    _selectedAnswer != null &&
                    !_userAnswers.containsKey(
                      widget.lesson.exercises[_currentExerciseIndex].id,
                    )) {
                  // Check answer
                  setState(() {
                    _userAnswers[widget
                            .lesson
                            .exercises[_currentExerciseIndex]
                            .id] =
                        _selectedAnswer!;
                    _showExplanation = true;
                  });
                } else if (hasMoreExercises && canGoNext) {
                  // Next exercise
                  setState(() {
                    _currentExerciseIndex++;
                    _selectedAnswer = null;
                    _showExplanation = false;
                  });
                } else if (!isLastSection) {
                  // Next section
                  setState(() {
                    _currentSection++;
                    _currentExerciseIndex = 0;
                    _selectedAnswer = null;
                    _showExplanation = false;
                  });
                } else if (isLastSection && canGoNext) {
                  // Finish lesson
                  _finishLesson();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _getNextButtonText(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    final isExerciseSection = _currentSection == 2;
    final hasMoreExercises =
        isExerciseSection &&
        _currentExerciseIndex < widget.lesson.exercises.length - 1;
    final isLastSection = _currentSection == 2;
    final isAnswered =
        isExerciseSection &&
        _userAnswers.containsKey(
          widget.lesson.exercises[_currentExerciseIndex].id,
        );

    if (isExerciseSection && !isAnswered) {
      return 'Verificar';
    } else if (hasMoreExercises) {
      return 'Siguiente Ejercicio';
    } else if (!isLastSection) {
      return 'Continuar';
    } else {
      return 'Completar Lección';
    }
  }

  void _finishLesson() {
    final correctAnswers = _userAnswers.values
        .where(
          (answer) =>
              widget.lesson.exercises.any((ex) => ex.correctAnswer == answer),
        )
        .length;
    final totalExercises = widget.lesson.exercises.length;
    final score = (correctAnswers / totalExercises * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              score >= 70 ? Icons.celebration : Icons.emoji_events_outlined,
              color: score >= 70 ? Colors.amber : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              '¡Lección Completada!',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tu puntuación',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '$score%',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: score >= 70 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$correctAnswers de $totalExercises respuestas correctas',
              style: GoogleFonts.inter(color: Colors.grey[700]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to module detail
            },
            child: Text(
              'Volver al Módulo',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
