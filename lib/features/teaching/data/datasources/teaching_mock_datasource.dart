import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:appzoque/features/teaching/domain/entities/teaching_module.dart';
import 'package:appzoque/features/teaching/data/models/teaching_module_dto.dart';
import 'package:appzoque/features/teaching/data/datasources/teaching_in_memory_store.dart';

class TeachingMockDataSource {
  final TeachingInMemoryStore store;

  TeachingMockDataSource({required this.store});

  Future<List<TeachingModule>> getModules() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final cached = store.modules;
    if (cached != null) {
      return cached;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/mock-data/teaching_modules.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      final modules = jsonList
          .map(
            (json) => TeachingModuleDTO.fromJson(json as Map<String, dynamic>),
          )
          .map((dto) => dto.toEntity())
          .toList();

      store.setModules(modules);
      return modules;
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
