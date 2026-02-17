import 'package:appzoque/features/dictionary/data/datasources/dictionary_api_datasource.dart';
import 'package:appzoque/features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:appzoque/features/dictionary/domain/repositories/dictionary_repository.dart';
import 'package:appzoque/features/dictionary/domain/usecases/get_words.dart';
import 'package:appzoque/features/dictionary/domain/usecases/search_words.dart';
import 'package:appzoque/features/dictionary/presentation/viewmodels/dictionary_viewmodel.dart';
import 'package:appzoque/features/news/data/datasources/news_api_datasource.dart';
import 'package:appzoque/features/news/data/repositories/news_repository_impl.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';
import 'package:appzoque/features/news/domain/usecases/get_news.dart';
import 'package:appzoque/features/news/domain/usecases/get_news_by_category.dart';
import 'package:appzoque/features/news/domain/usecases/get_news_by_id.dart';
import 'package:appzoque/features/news/presentation/viewmodels/news_viewmodel.dart';
import 'package:appzoque/features/home/data/datasources/home_api_datasource.dart';
import 'package:appzoque/features/home/data/repositories/home_repository_impl.dart';
import 'package:appzoque/features/home/domain/repositories/home_repository.dart';
import 'package:appzoque/features/home/domain/usecases/get_menu_items.dart';
import 'package:appzoque/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:appzoque/features/teaching/data/datasources/teaching_api_datasource.dart';
import 'package:appzoque/features/teaching/data/repositories/teaching_repository_impl.dart';
import 'package:appzoque/features/teaching/domain/repositories/teaching_repository.dart';
import 'package:appzoque/features/teaching/domain/usecases/get_teaching_modules.dart';
import 'package:appzoque/features/teaching/domain/usecases/get_teaching_module_by_id.dart';
import 'package:appzoque/features/teaching/presentation/viewmodels/teaching_viewmodel.dart';
import 'package:appzoque/features/admin/data/datasources/admin_api_datasource.dart';
import 'package:appzoque/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:appzoque/features/admin/domain/repositories/admin_repository.dart';
import 'package:appzoque/features/admin/domain/usecases/get_admin_actions.dart';
import 'package:appzoque/features/admin/domain/usecases/add_word.dart';
import 'package:appzoque/features/admin/domain/usecases/update_word.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_word.dart';
import 'package:appzoque/features/admin/domain/usecases/add_module.dart';
import 'package:appzoque/features/admin/domain/usecases/update_module.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_module.dart';
import 'package:appzoque/features/admin/domain/usecases/add_lesson.dart';
import 'package:appzoque/features/admin/domain/usecases/update_lesson.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_lesson.dart';
import 'package:appzoque/features/admin/domain/usecases/add_news.dart';
import 'package:appzoque/features/admin/domain/usecases/update_news.dart';
import 'package:appzoque/features/admin/domain/usecases/delete_news.dart';
import 'package:appzoque/features/admin/presentation/viewmodels/admin_viewmodel.dart';
import 'package:appzoque/features/auth/data/datasources/admin_auth_datasource.dart';
import 'package:appzoque/features/auth/data/repositories/admin_auth_repository_impl.dart';
import 'package:appzoque/features/auth/domain/usecases/verify_admin_user_usecase.dart';
import 'package:appzoque/features/auth/providers/auth_provider.dart';
import 'package:appzoque/features/auth/services/auth_service.dart';
import 'package:appzoque/features/admob/data/datasources/admob_data_source.dart';
import 'package:appzoque/features/admob/data/repositories/ad_repository_impl.dart';
import 'package:appzoque/features/admob/domain/repositories/ad_repository.dart';
import 'package:appzoque/features/admob/presentation/providers/admob_provider.dart';
import 'package:appzoque/features/favorites/data/datasources/favorites_in_memory_store.dart';
import 'package:appzoque/features/favorites/data/datasources/favorites_mock_datasource.dart';
import 'package:appzoque/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:appzoque/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:appzoque/features/favorites/domain/usecases/add_news_favorite.dart';
import 'package:appzoque/features/favorites/domain/usecases/add_word_favorite.dart';
import 'package:appzoque/features/favorites/domain/usecases/get_favorite_news_ids.dart';
import 'package:appzoque/features/favorites/domain/usecases/get_favorite_word_ids.dart';
import 'package:appzoque/features/favorites/domain/usecases/remove_news_favorite.dart';
import 'package:appzoque/features/favorites/domain/usecases/remove_word_favorite.dart';
import 'package:appzoque/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';
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

  // Favorites dependencies
  late final FavoritesViewModel favoritesViewModel;

  // Auth dependencies
  late final AuthProvider authProvider;

  // AdMob dependencies
  late final AdMobProvider adMobProvider;

  void init() {
    final client = http.Client();

    // Dictionary setup
    final apiDataSource = DictionaryApiDataSource(client: client);
    final DictionaryRepository repository = DictionaryRepositoryImpl(
      apiDataSource: apiDataSource,
    );
    dictionaryViewModel = DictionaryViewModel(
      getWords: GetWords(repository),
      searchWords: SearchWords(repository),
    );

    // News setup
    final newsApiDataSource = NewsApiDataSource();
    final NewsRepository newsRepository = NewsRepositoryImpl(
      apiDataSource: newsApiDataSource,
    );
    newsViewModel = NewsViewModel(
      getNewsUseCase: GetNews(newsRepository),
      getNewsByCategoryUseCase: GetNewsByCategory(newsRepository),
      getNewsByIdUseCase: GetNewsById(newsRepository),
    );

    // Home setup
    final homeApiDataSource = HomeApiDataSource(client: client);
    final HomeRepository homeRepository = HomeRepositoryImpl(
      apiDataSource: homeApiDataSource,
    );
    homeViewModel = HomeViewModel(
      getMenuItemsUseCase: GetMenuItems(homeRepository),
    );

    // Teaching setup
    final teachingApiDataSource = TeachingApiDataSource(client: client);
    final TeachingRepository teachingRepository = TeachingRepositoryImpl(
      apiDataSource: teachingApiDataSource,
    );
    teachingViewModel = TeachingViewModel(
      getTeachingModulesUseCase: GetTeachingModules(teachingRepository),
      getTeachingModuleByIdUseCase: GetTeachingModuleById(teachingRepository),
    );

    // Auth setup
    final authService = AuthService();
    final adminAuthDataSource = AdminAuthDataSourceImpl(client: client);
    final adminAuthRepository = AdminAuthRepositoryImpl(
      dataSource: adminAuthDataSource,
    );
    authProvider = AuthProvider(
      authService: authService,
      verifyAdminUserUseCase: VerifyAdminUserUseCase(
        repository: adminAuthRepository,
      ),
    );

    // Admin setup
    final adminApiDataSource = AdminApiDataSource(
      client: client,
      authService: authService,
    );
    final AdminRepository adminRepository = AdminRepositoryImpl(
      apiDataSource: adminApiDataSource,
    );
    adminViewModel = AdminViewModel(
      getAdminActionsUseCase: GetAdminActions(adminRepository),
      addWordUseCase: AddWord(adminRepository),
      updateWordUseCase: UpdateWord(adminRepository),
      deleteWordUseCase: DeleteWord(adminRepository),
      addModuleUseCase: AddModule(adminRepository),
      updateModuleUseCase: UpdateModule(adminRepository),
      deleteModuleUseCase: DeleteModule(adminRepository),
      addLessonUseCase: AddLesson(adminRepository),
      updateLessonUseCase: UpdateLesson(adminRepository),
      deleteLessonUseCase: DeleteLesson(adminRepository),
      addNewsUseCase: AddNews(adminRepository),
      updateNewsUseCase: UpdateNews(adminRepository),
      deleteNewsUseCase: DeleteNews(adminRepository),
    );

    // AdMob setup
    // Data sources
    final adMobDataSource = AdMobDataSource();

    // Repository
    final AdRepository adRepository = AdRepositoryImpl(adMobDataSource);

    // Provider
    adMobProvider = AdMobProvider(adRepository);

    // Favorites setup
    // Data sources
    final favoritesStore = FavoritesInMemoryStore();
    final favoritesMockDataSource = FavoritesMockDataSource(
      store: favoritesStore,
    );

    // Repository
    final FavoritesRepository favoritesRepository = FavoritesRepositoryImpl(
      mockDataSource: favoritesMockDataSource,
    );

    // Use cases
    final getFavoriteNewsIds = GetFavoriteNewsIds(favoritesRepository);
    final getFavoriteWordIds = GetFavoriteWordIds(favoritesRepository);
    final addNewsFavorite = AddNewsFavorite(favoritesRepository);
    final removeNewsFavorite = RemoveNewsFavorite(favoritesRepository);
    final addWordFavorite = AddWordFavorite(favoritesRepository);
    final removeWordFavorite = RemoveWordFavorite(favoritesRepository);

    // ViewModel
    favoritesViewModel = FavoritesViewModel(
      getFavoriteNewsIdsUseCase: getFavoriteNewsIds,
      getFavoriteWordIdsUseCase: getFavoriteWordIds,
      addNewsFavoriteUseCase: addNewsFavorite,
      removeNewsFavoriteUseCase: removeNewsFavorite,
      addWordFavoriteUseCase: addWordFavorite,
      removeWordFavoriteUseCase: removeWordFavorite,
    );
  }
}
