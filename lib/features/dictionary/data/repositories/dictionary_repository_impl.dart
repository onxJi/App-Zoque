import '../../domain/entities/word.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_api_datasource.dart';
import '../datasources/dictionary_mock_datasource.dart';
import '../../../../core/config/env_config.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryApiDataSource apiDataSource;
  final DictionaryMockDataSource mockDataSource;

  DictionaryRepositoryImpl({
    required this.apiDataSource,
    required this.mockDataSource,
  });

  bool get _useMockData => EnvConfig.useMockData;

  @override
  Future<List<Word>> getWords() async {
    try {
      if (_useMockData) {
        return await mockDataSource.getWords();
      } else {
        return await apiDataSource.getWords();
      }
    } catch (e) {
      // Fallback to mock data if API fails
      if (!_useMockData) {
        return await mockDataSource.getWords();
      }
      rethrow;
    }
  }

  @override
  Future<List<Word>> searchWords(String query) async {
    try {
      if (_useMockData) {
        return await mockDataSource.searchWords(query);
      } else {
        return await apiDataSource.searchWords(query);
      }
    } catch (e) {
      // Fallback to mock data if API fails
      if (!_useMockData) {
        return await mockDataSource.searchWords(query);
      }
      rethrow;
    }
  }

  @override
  Future<Word?> getWordById(String id) async {
    try {
      if (_useMockData) {
        return await mockDataSource.getWordById(id);
      } else {
        return await apiDataSource.getWordById(id);
      }
    } catch (e) {
      // Fallback to mock data if API fails
      if (!_useMockData) {
        return await mockDataSource.getWordById(id);
      }
      rethrow;
    }
  }

  @override
  Future<List<Word>> getWordsByCategory(String category) async {
    try {
      if (_useMockData) {
        return await mockDataSource.getWordsByCategory(category);
      } else {
        return await apiDataSource.getWordsByCategory(category);
      }
    } catch (e) {
      // Fallback to mock data if API fails
      if (!_useMockData) {
        return await mockDataSource.getWordsByCategory(category);
      }
      rethrow;
    }
  }
}
