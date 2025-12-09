import 'package:appzoque/features/account/presentation/screens/account_screen.dart';
import 'package:appzoque/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.userName ?? 'Usuario';
    final userPhotoUrl = authProvider.userPhotoUrl;

    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fila con título y perfil de usuario
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // Perfil de usuario (clickeable)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Foto de perfil o avatar
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            backgroundImage: userPhotoUrl != null
                                ? NetworkImage(userPhotoUrl)
                                : null,
                            child: userPhotoUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),

                          // Nombre del usuario
                          Text(
                            userName.split(' ').first, // Solo primer nombre
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),

                          // Icono de flecha
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
