import 'package:appzoque/features/dictionary/data/datasources/dictionary_api_datasource.dart';
import 'package:appzoque/features/dictionary/data/datasources/dictionary_mock_datasource.dart';
import 'package:appzoque/features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:appzoque/features/dictionary/domain/repositories/dictionary_repository.dart';
import 'package:appzoque/features/dictionary/domain/usecases/get_words.dart';
import 'package:appzoque/features/dictionary/domain/usecases/search_words.dart';
import 'package:appzoque/features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';
import 'package:http/http.dart' as http;

class DependencyInjection {
  // Singleton instance
  static final DependencyInjection _instance = DependencyInjection._internal();
  factory DependencyInjection() => _instance;
  DependencyInjection._internal();

  // Dictionary dependencies
  late final DictionaryViewModel dictionaryViewModel;

  void init() {
    // Data sources
    final apiDataSource = DictionaryApiDataSource(client: http.Client());
    final mockDataSource = DictionaryMockDataSource();

    // Repository
    final DictionaryRepository repository = DictionaryRepositoryImpl(
      apiDataSource: apiDataSource,
      mockDataSource: mockDataSource,
    );

    // Use cases
    final getWords = GetWords(repository);
    final searchWords = SearchWords(repository);

    // ViewModel
    dictionaryViewModel = DictionaryViewModel(
      getWords: getWords,
      searchWords: searchWords,
    );
  }
}
