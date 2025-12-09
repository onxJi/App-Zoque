import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appzoque/features/auth/providers/auth_provider.dart';

/// Ejemplo de widget que muestra contenido diferente según el rol del usuario
/// Este widget demuestra cómo usar el AuthProvider para verificar si un usuario es admin
class AdminProtectedWidget extends StatelessWidget {
  const AdminProtectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Si no está autenticado, mostrar pantalla de login
        if (!authProvider.isSignedIn) {
          return const _LoginPrompt();
        }

        // Si está verificando el estado de admin, mostrar loading
        if (authProvider.isCheckingAdmin) {
          return const _LoadingState();
        }

        // Si es admin, mostrar panel de administración
        if (authProvider.isAdmin) {
          return const _AdminPanel();
        }

        // Si no es admin, mostrar mensaje de acceso denegado
        return const _AccessDenied();
      },
    );
  }
}

/// Widget que solicita al usuario iniciar sesión
class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Inicia sesión para continuar',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              await authProvider.signInWithGoogle();
            },
            icon: const Icon(Icons.login),
            label: const Text('Iniciar sesión con Google'),
          ),
        ],
      ),
    );
  }
}

/// Widget que muestra un indicador de carga mientras se verifica el estado de admin
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Verificando permisos de administrador...'),
        ],
      ),
    );
  }
}

/// Widget que muestra el panel de administración
class _AdminPanel extends StatelessWidget {
  const _AdminPanel();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Verificar estado de admin',
            onPressed: () async {
              await authProvider.checkIfUserIsAdmin();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: authProvider.userPhotoUrl != null
                          ? NetworkImage(authProvider.userPhotoUrl!)
                          : null,
                      child: authProvider.userPhotoUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userName ?? 'Usuario',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            authProvider.userEmail ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'ADMINISTRADOR',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Funciones de Administrador',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _AdminActionCard(
                    icon: Icons.book,
                    title: 'Gestionar Diccionario',
                    onTap: () {
                      // Navegar a gestión de diccionario
                    },
                  ),
                  _AdminActionCard(
                    icon: Icons.school,
                    title: 'Gestionar Módulos',
                    onTap: () {
                      // Navegar a gestión de módulos
                    },
                  ),
                  _AdminActionCard(
                    icon: Icons.article,
                    title: 'Gestionar Noticias',
                    onTap: () {
                      // Navegar a gestión de noticias
                    },
                  ),
                  _AdminActionCard(
                    icon: Icons.people,
                    title: 'Gestionar Usuarios',
                    onTap: () {
                      // Navegar a gestión de usuarios
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de tarjeta para acciones de administrador
class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget que muestra mensaje de acceso denegado
class _AccessDenied extends StatelessWidget {
  const _AccessDenied();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Acceso Denegado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'No tienes permisos de administrador para acceder a esta sección.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Text(
              'Usuario: ${authProvider.userEmail ?? "Desconocido"}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                // Intentar verificar de nuevo
                await authProvider.checkIfUserIsAdmin();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Verificar de nuevo'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ejemplo de uso en una ruta
/// 
/// En tu configuración de rutas (go_router, etc.):
/// 
/// ```dart
/// GoRoute(
///   path: '/admin',
///   builder: (context, state) => const AdminProtectedWidget(),
/// ),
/// ```
/// 
/// O como widget independiente:
/// 
/// ```dart
/// class AdminScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return const AdminProtectedWidget();
///   }
/// }
/// ```
