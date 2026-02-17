import 'package:appzoque/features/teaching/presentation/viewmodels/teaching_viewmodel.dart';
import 'package:appzoque/features/teaching/presentation/widgets/module_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'module_detail_screen.dart';

class TeachingListScreen extends StatefulWidget {
  const TeachingListScreen({super.key});

  @override
  State<TeachingListScreen> createState() => _TeachingListScreenState();
}

class _TeachingListScreenState extends State<TeachingListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeachingViewModel>().loadModules();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<TeachingViewModel>().loadModules(refresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<TeachingViewModel>().setSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Buscar módulos...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<TeachingViewModel>().setSearchQuery(
                              '',
                            );
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            // Module List
            Expanded(
              child: Consumer<TeachingViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.modules.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.error != null && viewModel.modules.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${viewModel.error}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => viewModel.loadModules(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (viewModel.modules.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.beach_access_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            viewModel.searchQuery.isEmpty
                                ? 'No hay módulos disponibles.'
                                : 'No se encontraron módulos para "${viewModel.searchQuery}"',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => viewModel.loadModules(),
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount:
                          viewModel.modules.length +
                          (viewModel.isLoadingMore ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index < viewModel.modules.length) {
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
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
