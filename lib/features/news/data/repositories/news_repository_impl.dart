import 'package:appzoque/core/config/env_config.dart';
import 'package:appzoque/features/news/data/datasources/news_api_datasource.dart';
import 'package:appzoque/features/news/data/datasources/news_mock_datasource.dart';
import 'package:appzoque/features/news/domain/entities/news_item.dart';
import 'package:appzoque/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiDataSource apiDataSource;
  final NewsMockDataSource mockDataSource;

  NewsRepositoryImpl({
    required this.apiDataSource,
    required this.mockDataSource,
  });

  bool get _useMockData => EnvConfig.useMockData;

  @override
  Future<List<NewsItem>> getNews() async {
    try {
      if (_useMockData) {
        return await mockDataSource.getNews();
      } else {
        return await apiDataSource.getNews();
      }
    } catch (e) {
      // Fallback to mock data if API fails
      if (!_useMockData) {
        return await mockDataSource.getNews();
      }
      rethrow;
    }
  }

  @override
  Future<List<NewsItem>> getNewsByCategory(String category) async {
    try {
      if (_useMockData) {
        return await mockDataSource.getNewsByCategory(category);
      } else {
        return await apiDataSource.getNewsByCategory(category);
      }
    } catch (e) {
      // Fallback to mock data if API fails
      if (!_useMockData) {
        return await mockDataSource.getNewsByCategory(category);
      }
      rethrow;
    }
  }

  @override
  Future<NewsItem?> getNewsById(String id) async {
    try {
      if (_useMockData) {
        return await mockDataSource.getNewsById(id);
      } else {
        return await apiDataSource.getNewsById(id);
      }
    } catch (e) {
      // Fallback to mock data if API fails
      if (!_useMockData) {
        return await mockDataSource.getNewsById(id);
      }
      rethrow;
    }
  }
}
