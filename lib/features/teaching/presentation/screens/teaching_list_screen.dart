import 'package:appzoque/features/teaching/presentation/viewmodels/teaching_viewmodel.dart';
import 'package:appzoque/features/teaching/presentation/widgets/module_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'module_detail_screen.dart';

class TeachingListScreen extends StatefulWidget {
  const TeachingListScreen({super.key});

  @override
  State<TeachingListScreen> createState() => _TeachingListScreenState();
}

class _TeachingListScreenState extends State<TeachingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeachingViewModel>().loadModules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TeachingViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          if (viewModel.modules.isEmpty) {
            return const Center(child: Text('No hay módulos disponibles.'));
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.loadModules(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Adjust for responsiveness later if needed
                childAspectRatio: 1.1, // Adjust based on card design
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: viewModel.modules.length,
              itemBuilder: (context, index) {
                final module = viewModel.modules[index];
                return ModuleCard(
                  module: module,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ModuleDetailScreen(module: module),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
