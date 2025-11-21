import 'package:appzoque/features/dictionary/domain/entities/word.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';

class AdminMockDataSource {
  // Simulate API delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Dictionary operations
  Future<void> addWord(Word word) async {
    await _simulateDelay();
    // Simulate POST request
    print('POST /api/words - Adding word: ${word.wordSpanish}');
    // In a real scenario, this would send data to the server
  }

  Future<void> updateWord(String id, Word word) async {
    await _simulateDelay();
    // Simulate PUT request
    print('PUT /api/words/$id - Updating word: ${word.wordSpanish}');
  }

  Future<void> deleteWord(String id) async {
    await _simulateDelay();
    // Simulate DELETE request
    print('DELETE /api/words/$id - Deleting word');
  }

  // Teaching operations
  Future<void> addModule(TeachingModule module) async {
    await _simulateDelay();
    // Simulate POST request
    print('POST /api/modules - Adding module: ${module.title}');
  }

  Future<void> updateModule(String id, TeachingModule module) async {
    await _simulateDelay();
    // Simulate PUT request
    print('PUT /api/modules/$id - Updating module: ${module.title}');
  }

  Future<void> deleteModule(String id) async {
    await _simulateDelay();
    // Simulate DELETE request
    print('DELETE /api/modules/$id - Deleting module');
  }
}
