import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:appzoque/core/config/env_config.dart';
import 'package:appzoque/features/home/data/models/home_menu_item_dto.dart';
import 'package:appzoque/features/home/domain/entities/home_menu_item.dart';

class HomeApiDataSource {
  final http.Client client;

  HomeApiDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<List<HomeMenuItem>> getMenuItems(String? token) async {
    final url = Uri.parse('${EnvConfig.apiBaseUrl}/menu');
    debugPrint('Token: $token');
    try {
      debugPrint('API CALL: GET $url');
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      debugPrint('API RESPONSE: ${response.statusCode} from $url');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            json.decode(response.body) as List<dynamic>;
        return jsonList
            .map(
              (json) => HomeMenuItemDTO.fromJson(json as Map<String, dynamic>),
            )
            .map((dto) => dto.toEntity())
            .toList();
      } else {
        throw Exception('Failed to load menu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menu from API: $e');
    }
  }
}
