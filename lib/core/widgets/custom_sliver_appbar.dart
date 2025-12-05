import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSliverAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? imageUrl; // Opcional: para el background con imagen
  final bool showBackButton; // Opcional: para mostrar el botón de regreso
  final VoidCallback?
  onBackButtonPressed; // Opcional: acción del botón de regreso
  final Color? backgroundColor; // Opcional: color de fondo cuando no hay imagen
  final Widget? leading; // Opcional: widget personalizado para leading
  final List<Widget>? actions; // Opcional: acciones en el AppBar
  final bool?
  floating; // Opcional: para controlar el comportamiento de desplazamiento
  final bool? pinned; // Opcional: para fijar el AppBar
  final double? expandedHeight; // Opcional: altura expandida

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.imageUrl,
    this.showBackButton = false,
    this.onBackButtonPressed,
    this.backgroundColor,
    this.leading,
    this.actions,
    this.floating,
    this.pinned,
    this.expandedHeight,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Determinar si es un AppBar con imagen o sin imagen
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    // Calcular altura expandida si no se proporciona
    final double calculatedHeight = expandedHeight ?? (hasImage ? 200.0 : 0.0);

    // Determinar si debe flotar (por defecto true si no tiene imagen, false si tiene imagen)
    final bool calculatedFloating = floating ?? (hasImage ? false : true);

    // Determinar si debe estar fijado
    final bool calculatedPinned = pinned ?? (hasImage ? true : true);

    // Construir el leading
    Widget? appBarLeading = leading;
    if (showBackButton && leading == null) {
      appBarLeading = IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
      );
    }

    // Si tiene imagen, construir el FlexibleSpaceBar
    if (hasImage) {
      return SliverAppBar(
        expandedHeight: calculatedHeight,
        floating: calculatedFloating,
        pinned: calculatedPinned,
        backgroundColor: backgroundColor,
        leading: appBarLeading,
        actions: actions,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3.0,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          background: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color:
                        backgroundColor ??
                        Theme.of(context).colorScheme.primary,
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // AppBar sin imagen
      return SliverAppBar(
        expandedHeight: calculatedHeight,
        floating: calculatedFloating,
        pinned: calculatedPinned,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        leading: appBarLeading,
        actions: actions,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
