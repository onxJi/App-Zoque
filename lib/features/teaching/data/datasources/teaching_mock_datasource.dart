import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/data/models/teaching_module_dto.dart';

class TeachingMockDataSource {
  Future<List<TeachingModule>> getModules() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/mock-data/teaching_modules.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      return jsonList
          .map(
            (json) => TeachingModuleDTO.fromJson(json as Map<String, dynamic>),
          )
          .map((dto) => dto.toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error loading mock teaching data: $e');
    }
  }

  Future<TeachingModule?> getModuleById(String id) async {
    final modules = await getModules();
    try {
      return modules.firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }
}
