import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/teaching/data/datasources/teaching_api_datasource.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/domain/repositories/teaching_repository.dart';

class TeachingRepositoryImpl implements TeachingRepository {
  final TeachingApiDataSource apiDataSource;

  TeachingRepositoryImpl({required this.apiDataSource});

  @override
  Future<PaginatedResponse<TeachingModule>> getModules({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    return await apiDataSource.getModules(
      page: page,
      limit: limit,
      search: search,
    );
  }

  @override
  Future<TeachingModule?> getModuleById(String id) async {
    return await apiDataSource.getModuleById(id);
  }
}
