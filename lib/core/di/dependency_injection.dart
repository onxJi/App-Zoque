import 'package:appzoque/features/dictionary/data/datasources/dictionary_api_datasource.dart';
import 'package:appzoque/features/dictionary/data/datasources/dictionary_mock_datasource.dart';
import 'package:appzoque/features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:appzoque/features/dictionary/domain/repositories/dictionary_repository.dart';
import 'package:appzoque/features/dictionary/domain/usecases/get_words.dart';
import 'package:appzoque/features/dictionary/domain/usecases/search_words.dart';
import 'package:appzoque/features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';
import 'package:appzoque/features/news/data/datasources/news_api_datasource.dart';
import 'package:appzoque/features/news/data/datasources/news_mock_datasource.dart';
import 'package:appzoque/features/news/data/repositories/news_repository_impl.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';
import 'package:appzoque/features/news/domain/usecases/get_news.dart';
import 'package:appzoque/features/news/domain/usecases/get_news_by_category.dart';
import 'package:appzoque/features/news/domain/usecases/get_news_by_id.dart';
import 'package:appzoque/features/news/presentation/viewmodels/news_viewmodel.dart';
import 'package:appzoque/features/home/data/datasources/home_mock_datasource.dart';
import 'package:appzoque/features/home/data/repositories/home_repository_impl.dart';
import 'package:appzoque/features/home/domain/repositories/home_repository.dart';
import 'package:appzoque/features/home/domain/usecases/get_menu_items.dart';
import 'package:appzoque/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:appzoque/features/teaching/data/datasources/teaching_mock_datasource.dart';
import 'package:appzoque/features/teaching/data/repositories/teaching_repository_impl.dart';
import 'package:appzoque/features/teaching/domain/repositories/teaching_repository.dart';
import 'package:appzoque/features/teaching/domain/usecases/get_teaching_modules.dart';
import 'package:appzoque/features/teaching/domain/usecases/get_teaching_module_by_id.dart';
import 'package:appzoque/features/teaching/presentation/viewmodels/teaching_viewmodel.dart';
import 'package:appzoque/features/admin/data/datasources/admin_mock_datasource.dart';
import 'package:appzoque/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';
import 'package:appzoque/features/admin/domain/usecases/add_word.dart';
import 'package:appzoque/features/admin/domain/usecases/update_word.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_word.dart';
import 'package:appzoque/features/admin/domain/usecases/add_module.dart';
import 'package:appzoque/features/admin/domain/usecases/update_module.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_module.dart';
import 'package:appzoque/features/admin/presentation/viewmodels/admin_viewmodel.dart';
import 'package:http/http.dart' as http;

class DependencyInjection {
  // Singleton instance
  static final DependencyInjection _instance = DependencyInjection._internal();
  factory DependencyInjection() => _instance;
  DependencyInjection._internal();

  // Dictionary dependencies
  late final DictionaryViewModel dictionaryViewModel;

  // News dependencies
  late final NewsViewModel newsViewModel;

  // Home dependencies
  late final HomeViewModel homeViewModel;

  // Teaching dependencies
  late final TeachingViewModel teachingViewModel;

  // Admin dependencies
  late final AdminViewModel adminViewModel;

  void init() {
    // Dictionary setup
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

    // News setup
    // Data sources
    final newsApiDataSource = NewsApiDataSource();
    final newsMockDataSource = NewsMockDataSource();

    // Repository
    final NewsRepository newsRepository = NewsRepositoryImpl(
      apiDataSource: newsApiDataSource,
      mockDataSource: newsMockDataSource,
    );

    // Use cases
    final getNews = GetNews(newsRepository);
    final getNewsByCategory = GetNewsByCategory(newsRepository);
    final getNewsById = GetNewsById(newsRepository);

    // ViewModel
    newsViewModel = NewsViewModel(
      getNewsUseCase: getNews,
      getNewsByCategoryUseCase: getNewsByCategory,
      getNewsByIdUseCase: getNewsById,
    );

    // Home setup
    // Data sources
    final homeMockDataSource = HomeMockDataSource();

    // Repository
    final HomeRepository homeRepository = HomeRepositoryImpl(
      mockDataSource: homeMockDataSource,
    );

    // Use cases
    final getMenuItems = GetMenuItems(homeRepository);

    // ViewModel
    homeViewModel = HomeViewModel(getMenuItemsUseCase: getMenuItems);

    // Teaching setup
    // Data sources
    final teachingMockDataSource = TeachingMockDataSource();

    // Repository
    final TeachingRepository teachingRepository = TeachingRepositoryImpl(
      mockDataSource: teachingMockDataSource,
    );

    // Use cases
    final getTeachingModules = GetTeachingModules(teachingRepository);
    final getTeachingModuleById = GetTeachingModuleById(teachingRepository);

    // ViewModel
    teachingViewModel = TeachingViewModel(
      getTeachingModulesUseCase: getTeachingModules,
      getTeachingModuleByIdUseCase: getTeachingModuleById,
    );

    // Admin setup
    // Data sources
    final adminMockDataSource = AdminMockDataSource();

    // Repository
    final AdminRepository adminRepository = AdminRepositoryImpl(
      mockDataSource: adminMockDataSource,
    );

    // Use cases
    final addWord = AddWord(adminRepository);
    final updateWord = UpdateWord(adminRepository);
    final deleteWord = DeleteWord(adminRepository);
    final addModule = AddModule(adminRepository);
    final updateModule = UpdateModule(adminRepository);
    final deleteModule = DeleteModule(adminRepository);

    // ViewModel
    adminViewModel = AdminViewModel(
      addWordUseCase: addWord,
      updateWordUseCase: updateWord,
      deleteWordUseCase: deleteWord,
      addModuleUseCase: addModule,
      updateModuleUseCase: updateModule,
      deleteModuleUseCase: deleteModule,
    );
  }
}
