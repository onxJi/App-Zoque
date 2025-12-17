import 'package:appzoque/features/auth/providers/auth_provider.dart';
import 'package:appzoque/core/services/preferences_service.dart';
import 'package:appzoque/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.userName ?? 'Usuario';
    final userEmail = authProvider.userEmail ?? 'correo@ejemplo.com';
    final userPhotoUrl = authProvider.userPhotoUrl;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mi Cuenta',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con foto de perfil
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Foto de perfil
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: userPhotoUrl != null
                          ? NetworkImage(userPhotoUrl)
                          : null,
                      child: userPhotoUrl == null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Nombre
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Email
                    Text(
                      userEmail,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Sección: Cuenta
              _buildSectionHeader(context, 'Cuenta'),
              _buildOptionTile(
                context,
                icon: Icons.person_outline,
                title: 'Editar Perfil',
                subtitle: 'Actualiza tu información personal',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función próximamente disponible'),
                    ),
                  );
                },
              ),
              _buildOptionTile(
                context,
                icon: Icons.favorite_outline,
                title: 'Favoritos',
                subtitle: 'Noticias y palabras guardadas',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),

              // Sección: Preferencias
              _buildSectionHeader(context, 'Preferencias'),
              _buildOptionTile(
                context,
                icon: Icons.notifications_none,
                title: 'Notificaciones',
                subtitle: 'Configura tus preferencias',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función próximamente disponible'),
                    ),
                  );
                },
              ),
              _buildOptionTile(
                context,
                icon: Icons.language,
                title: 'Idioma',
                subtitle: 'Español / Zoque',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función próximamente disponible'),
                    ),
                  );
                },
              ),

              // Sección: Soporte
              _buildSectionHeader(context, 'Soporte'),
              _buildOptionTile(
                context,
                icon: Icons.help_outline,
                title: 'Ayuda y Soporte',
                subtitle: '¿Necesitas ayuda?',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función próximamente disponible'),
                    ),
                  );
                },
              ),
              _buildOptionTile(
                context,
                icon: Icons.info_outline,
                title: 'Acerca de',
                subtitle: 'Versión 1.0.0',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'App Zoque',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2025 Comunidad Zoque',
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Aplicación dedicada a preservar y promover la cultura y lengua zoque.',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    ],
                  );
                },
              ),
              _buildOptionTile(
                context,
                icon: Icons.replay_outlined,
                title: 'Ver Tutorial de Inicio',
                subtitle: 'Volver a ver la introducción',
                onTap: () async {
                  final prefs = await PreferencesService.getInstance();
                  await prefs.resetFirstTime();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Tutorial reiniciado. Cierra y vuelve a abrir la app.',
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 32),

              // Botón de cerrar sesión
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            '¿Cerrar sesión?',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: Text(
                            '¿Estás seguro de que quieres cerrar sesión?',
                            style: GoogleFonts.inter(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Cerrar sesión'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await authProvider.signOut();
                        // Navegar al login después de cerrar sesión
                        if (context.mounted) {
                          context.go('/');
                        }
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: Text(
                      'Cerrar Sesión',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing:
          trailing ??
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}
