import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';

abstract class TeachingRepository {
  Future<PaginatedResponse<TeachingModule>> getModules({
    int page = 1,
    int limit = 10,
    String? search,
  });
  Future<TeachingModule?> getModuleById(String id);
}
