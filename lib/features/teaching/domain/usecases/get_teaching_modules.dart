import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/domain/repositories/teaching_repository.dart';

class GetTeachingModules {
  final TeachingRepository repository;

  GetTeachingModules(this.repository);

  Future<PaginatedResponse<TeachingModule>> call({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    return await repository.getModules(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
