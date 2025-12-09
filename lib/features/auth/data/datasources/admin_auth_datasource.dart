import 'dart:convert';
import 'package:http/http.dart' as http;
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
      final url = Uri.parse('${EnvConfig.apiBaseUrl}/auth/verify-admin');

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['isAdmin'] ?? false;
      } else if (response.statusCode == 401) {
        // Token inválido o expirado
        throw Exception('Token de autenticación inválido');
      } else if (response.statusCode == 403) {
        // Usuario no es admin
        return false;
      } else {
        throw Exception(
          'Error al verificar usuario admin: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error en verifyAdminUser: $e');
      rethrow;
    }
  }
}
