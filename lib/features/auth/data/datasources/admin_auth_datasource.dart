import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:appzoque/core/config/env_config.dart';

abstract class AdminAuthDataSource {
  Future<bool> verifyAdminUser(String idToken);
}

class AdminAuthDataSourceImpl implements AdminAuthDataSource {
  final http.Client client;

  AdminAuthDataSourceImpl({required this.client});

  @override
  Future<bool> verifyAdminUser(String idToken) async {
    try {
      final url = Uri.parse('${EnvConfig.apiBaseUrl}/auth/verify');

      debugPrint('API CALL: POST $url');
      debugPrint(
        'AUTH: Enviando token: ${idToken.substring(0, idToken.length > 10 ? 10 : idToken.length)}...',
      );
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': idToken}),
      );
      debugPrint('API RESPONSE: ${response.statusCode} from $url');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        // idRole 1 is Admin according to docs
        return data['idRole'] == 1;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        // Token inválido o expirado
        throw Exception('Token de autenticación inválido o formato incorrecto');
      } else {
        throw Exception('Error al verificar usuario: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error en verifyAdminUser: $e');
      rethrow;
    }
  }
}
