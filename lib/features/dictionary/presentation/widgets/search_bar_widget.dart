import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dictionary_viewmodel.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Create new timer (debounce)
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<DictionaryViewModel>().search(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    context.read<DictionaryViewModel>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade800),
        decoration: InputDecoration(
          hintText: 'Buscar en Zoque o Español...',
          hintStyle: GoogleFonts.inter(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
