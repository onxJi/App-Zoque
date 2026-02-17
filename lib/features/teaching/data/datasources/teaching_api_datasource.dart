import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appzoque/core/config/env_config.dart';
import 'package:appzoque/core/models/paginated_response.dart';
import 'package:appzoque/features/teaching/data/models/teaching_module_dto.dart';
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:flutter/foundation.dart';

class TeachingApiDataSource {
  final http.Client client;

  TeachingApiDataSource({http.Client? client})
    : client = client ?? http.Client();

  Future<PaginatedResponse<TeachingModule>> getModules({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null) 'search': search,
    };

    final uri = Uri.parse(
      '${EnvConfig.apiBaseUrl}/teaching',
    ).replace(queryParameters: queryParams);

    try {
      debugPrint('API CALL: GET $uri');
      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('API RESPONSE: ${response.statusCode} from $uri');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        return PaginatedResponse.fromJson(
          jsonResponse,
          (json) => TeachingModuleDTO.fromJson(json).toEntity(),
        );
      } else {
        throw Exception(
          'Failed to load teaching modules: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching teaching modules from API: $e');
    }
  }

  Future<TeachingModule?> getModuleById(String id) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/teaching/$id');

    try {
      debugPrint('API CALL: GET $url');
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('API RESPONSE: ${response.statusCode} from $url');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return TeachingModuleDTO.fromJson(json).toEntity();
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
          'Failed to load teaching module: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching teaching module from API: $e');
    }
  }
}
