# Autenticación de Administradores con JWT de Google

## Descripción General

Esta funcionalidad permite verificar si un usuario autenticado con Google es un administrador mediante el envío de un JWT (JSON Web Token) de Google al backend para su validación.

## Arquitectura

La implementación sigue el patrón de Clean Architecture con las siguientes capas:

### 1. Data Layer (`lib/features/auth/data/`)

#### DataSource
- **`admin_auth_datasource.dart`**: Maneja las peticiones HTTP al backend
  - Endpoint: `POST /auth/verify-admin`
  - Headers: `Authorization: Bearer {idToken}`
  - Respuestas:
    - `200`: Usuario es admin (`{ "isAdmin": true }`)
    - `403`: Usuario no es admin
    - `401`: Token inválido

#### Repository
- **`admin_auth_repository_impl.dart`**: Implementa la interfaz del repositorio

### 2. Domain Layer (`lib/features/auth/domain/`)

#### Use Case
- **`verify_admin_user_usecase.dart`**: Caso de uso para verificar si un usuario es admin

### 3. Presentation Layer (`lib/features/auth/`)

#### Services
- **`auth_service.dart`**: 
  - Método `getIdToken()`: Obtiene el ID Token de Firebase Auth
  - El token se fuerza a refrescar para asegurar que esté actualizado

#### Providers
- **`auth_provider.dart`**:
  - Estado `isAdmin`: Indica si el usuario actual es administrador
  - Estado `isCheckingAdmin`: Indica si se está verificando el estado de admin
  - Método `checkIfUserIsAdmin()`: Verifica el estado de admin con el backend

## Configuración del Backend

El backend debe implementar el endpoint:

```
POST /auth/verify-admin
Headers:
  Authorization: Bearer {Google_ID_Token}
  Content-Type: application/json

Respuestas:
  200 OK: { "isAdmin": true/false }
  401 Unauthorized: Token inválido o expirado
  403 Forbidden: Usuario no es admin
```

## Configuración del Entorno

En el archivo `.env`, configura la URL base del API:

```env
API_BASE_URL=https://api.appzoque.com/v1
USE_MOCK_DATA=false
```

## Uso en la Aplicación

### 1. Acceder al estado de admin

```dart
import 'package:provider/provider.dart';
import 'package:appzoque/features/auth/providers/auth_provider.dart';

// En cualquier widget
final authProvider = Provider.of<AuthProvider>(context);

if (authProvider.isCheckingAdmin) {
  return CircularProgressIndicator();
}

if (authProvider.isAdmin) {
  // Mostrar funcionalidad de admin
  return AdminPanel();
} else {
  // Mostrar mensaje de acceso denegado
  return Text('No tienes permisos de administrador');
}
```

### 2. Verificar manualmente el estado de admin

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.checkIfUserIsAdmin();
```

### 3. El estado de admin se verifica automáticamente

La verificación se realiza automáticamente después del login:

```dart
// En AuthProvider.signInWithGoogle()
final result = await _authService.signInWithGoogle();
if (result != null) {
  await checkIfUserIsAdmin(); // ← Verificación automática
  return true;
}
```

## Flujo de Autenticación

1. Usuario inicia sesión con Google
2. Firebase Auth genera credenciales
3. Se obtiene el ID Token de Google
4. El token se envía al backend en el header `Authorization`
5. El backend valida el token y verifica si el usuario es admin
6. El estado `isAdmin` se actualiza en el `AuthProvider`
7. La UI reacciona al cambio de estado

## Inyección de Dependencias

La configuración se realiza en `lib/core/di/dependency_injection.dart`:

```dart
// Auth setup
final authService = AuthService();
final adminAuthDataSource = AdminAuthDataSourceImpl(client: http.Client());
final adminAuthRepository = AdminAuthRepositoryImpl(dataSource: adminAuthDataSource);
final verifyAdminUserUseCase = VerifyAdminUserUseCase(repository: adminAuthRepository);

authProvider = AuthProvider(
  authService: authService,
  verifyAdminUserUseCase: verifyAdminUserUseCase,
);
```

## Manejo de Errores

- Si el token es inválido o expirado, se lanza una excepción
- Si hay un error de red, se captura y se registra en consola
- El estado `isAdmin` se establece en `false` en caso de error
- El estado `isCheckingAdmin` siempre se establece en `false` al finalizar

## Seguridad

- El ID Token de Google se refresca automáticamente antes de cada verificación
- El token tiene una validez limitada (generalmente 1 hora)
- El backend debe validar el token con los servidores de Google
- No se almacena información sensible en el cliente

## Testing

Para probar sin backend real, puedes:

1. Comentar temporalmente la llamada a `checkIfUserIsAdmin()` en `signInWithGoogle()`
2. Establecer manualmente `_isAdmin = true` para pruebas
3. Implementar un mock del `VerifyAdminUserUseCase` en tests

## Notas Importantes

- La verificación requiere conexión a internet
- El usuario debe estar autenticado con Google
- El backend debe estar configurado correctamente
- El token se obtiene de Firebase Auth, no de Google Sign-In directamente
