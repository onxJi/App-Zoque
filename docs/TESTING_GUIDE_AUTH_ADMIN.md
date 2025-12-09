# Guía de Pruebas Rápidas - Autenticación Admin

## ✅ Checklist de Verificación

### 1. Verificar Compilación
```bash
flutter analyze
```
**Resultado esperado**: No errores críticos (solo warnings de `print` existentes)

### 2. Verificar Imports
Todos los archivos deben importarse correctamente sin errores de compilación.

### 3. Verificar Inyección de Dependencias
En `lib/core/di/dependency_injection.dart`:
- ✅ Imports de auth agregados
- ✅ Propiedad `authProvider` declarada
- ✅ Inicialización en método `init()`

### 4. Verificar main.dart
En `lib/main.dart`:
- ✅ Usa `di.authProvider` en lugar de crear nueva instancia
- ✅ Import de `AuthProvider` removido

---

## 🧪 Pruebas Manuales

### Prueba 1: Login Básico
1. Ejecutar la app
2. Hacer login con Google
3. **Verificar en consola**:
   - ✅ "POST /api/admin/actions - Fetching admin actions" (o similar)
   - ✅ "Usuario es admin: false" (si no eres admin)
   - ✅ "Usuario es admin: true" (si eres admin)

### Prueba 2: Estado de Admin
```dart
// En cualquier widget
final authProvider = Provider.of<AuthProvider>(context);
print('Is Admin: ${authProvider.isAdmin}');
print('Is Checking: ${authProvider.isCheckingAdmin}');
```

### Prueba 3: Widget de Ejemplo
1. Importar el widget de ejemplo:
```dart
import 'package:appzoque/features/auth/presentation/widgets/admin_protected_widget.dart';
```

2. Usar en una ruta:
```dart
// En tu router
GoRoute(
  path: '/test-admin',
  builder: (context, state) => const AdminProtectedWidget(),
),
```

3. Navegar a `/test-admin` y verificar:
   - ✅ Muestra login si no está autenticado
   - ✅ Muestra loading durante verificación
   - ✅ Muestra panel de admin si es admin
   - ✅ Muestra acceso denegado si no es admin

---

## 🔍 Debugging

### Ver logs en consola
```dart
// En AuthProvider.checkIfUserIsAdmin()
print('VerifyAdminUserUseCase no está disponible'); // Si usecase es null
print('No se pudo obtener el ID Token'); // Si token es null
print('Usuario es admin: $isAdmin'); // Resultado de verificación
print('Error verificando si el usuario es admin: $e'); // Si hay error
```

### Verificar ID Token
```dart
// Agregar temporalmente en AuthProvider
final idToken = await _authService.getIdToken();
print('ID Token: ${idToken?.substring(0, 50)}...'); // Primeros 50 chars
```

### Simular Admin (Solo para pruebas locales)
```dart
// En AuthProvider.checkIfUserIsAdmin()
// Comentar la verificación real y establecer manualmente:
_isAdmin = true; // SOLO PARA PRUEBAS
_isCheckingAdmin = false;
notifyListeners();
return;
```

---

## 🌐 Pruebas con Backend

### Opción 1: Backend Real
1. Configurar `.env`:
```env
API_BASE_URL=https://tu-backend.com/v1
USE_MOCK_DATA=false
```

2. Implementar endpoint en backend (ver `BACKEND_ADMIN_VERIFICATION.md`)

3. Ejecutar app y hacer login

4. Verificar en logs del backend:
   - ✅ Recibe POST /auth/verify-admin
   - ✅ Header Authorization presente
   - ✅ Token válido
   - ✅ Responde correctamente

### Opción 2: Mock Server (Postman/Mockoon)
1. Crear mock endpoint:
```
POST /auth/verify-admin
Response: { "isAdmin": true }
Status: 200
```

2. Configurar `.env` con URL del mock

3. Probar flujo completo

### Opción 3: Sin Backend (Desarrollo)
```dart
// En AuthProvider.checkIfUserIsAdmin()
// Comentar la llamada al backend:
if (_verifyAdminUserUseCase == null) {
  print('VerifyAdminUserUseCase no está disponible');
  // Simular respuesta para pruebas
  _isAdmin = true; // o false según necesites
  _isCheckingAdmin = false;
  notifyListeners();
  return;
}
```

---

## 📊 Casos de Prueba

### Caso 1: Usuario Admin
**Setup**: Backend retorna `{ "isAdmin": true }`
**Pasos**:
1. Login con Google
2. Esperar verificación
**Resultado esperado**:
- ✅ `authProvider.isAdmin == true`
- ✅ UI muestra contenido de admin

### Caso 2: Usuario No Admin
**Setup**: Backend retorna `{ "isAdmin": false }`
**Pasos**:
1. Login con Google
2. Esperar verificación
**Resultado esperado**:
- ✅ `authProvider.isAdmin == false`
- ✅ UI muestra acceso denegado

### Caso 3: Token Inválido
**Setup**: Backend retorna `401 Unauthorized`
**Pasos**:
1. Login con Google
2. Esperar verificación
**Resultado esperado**:
- ✅ `authProvider.isAdmin == false`
- ✅ Error logueado en consola
- ✅ UI muestra acceso denegado

### Caso 4: Error de Red
**Setup**: Sin conexión a internet
**Pasos**:
1. Desconectar internet
2. Login con Google (puede fallar)
3. Si login exitoso, esperar verificación
**Resultado esperado**:
- ✅ `authProvider.isAdmin == false`
- ✅ Error logueado en consola
- ✅ `authProvider.isCheckingAdmin == false`

### Caso 5: Verificación Manual
**Pasos**:
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.checkIfUserIsAdmin();
```
**Resultado esperado**:
- ✅ Se ejecuta verificación
- ✅ Estado se actualiza
- ✅ UI reacciona al cambio

### Caso 6: Logout
**Pasos**:
1. Login como admin
2. Verificar `isAdmin == true`
3. Hacer logout
**Resultado esperado**:
- ✅ `authProvider.isAdmin == false`
- ✅ `authProvider.isSignedIn == false`
- ✅ UI vuelve a login

---

## 🐛 Problemas Comunes

### Problema 1: "VerifyAdminUserUseCase no está disponible"
**Causa**: DI no inicializado correctamente
**Solución**: Verificar que `DependencyInjection().init()` se llame en `main()`

### Problema 2: "No se pudo obtener el ID Token"
**Causa**: Usuario no autenticado o Firebase no inicializado
**Solución**: 
- Verificar que Firebase esté inicializado
- Verificar que el usuario haya hecho login exitosamente

### Problema 3: Error de red
**Causa**: Backend no disponible o URL incorrecta
**Solución**:
- Verificar `.env` tiene la URL correcta
- Verificar que el backend esté corriendo
- Verificar conexión a internet

### Problema 4: Token inválido
**Causa**: Configuración incorrecta de Firebase en backend
**Solución**:
- Verificar que el backend use Firebase Admin SDK
- Verificar credenciales de Firebase en backend
- Verificar que el proyecto de Firebase sea el mismo

### Problema 5: UI no se actualiza
**Causa**: No se está usando Consumer o Provider.of
**Solución**:
```dart
// Usar Consumer
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text('Is Admin: ${authProvider.isAdmin}');
  },
)

// O Provider.of con listen: true
final authProvider = Provider.of<AuthProvider>(context); // listen: true por defecto
```

---

## 📝 Checklist Pre-Producción

Antes de desplegar a producción:

- [ ] Backend implementado y probado
- [ ] Endpoint `/auth/verify-admin` funcionando
- [ ] Firebase Custom Claims configurados
- [ ] Variables de entorno configuradas
- [ ] HTTPS habilitado en backend
- [ ] Rate limiting implementado
- [ ] Logging de intentos de acceso admin
- [ ] Pruebas con usuarios reales
- [ ] Pruebas de seguridad realizadas
- [ ] Documentación actualizada
- [ ] Error handling probado
- [ ] UI/UX revisada

---

## 🚀 Comandos Útiles

```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
flutter run

# Ver logs en tiempo real
flutter logs

# Analizar código
flutter analyze

# Ejecutar en modo release
flutter run --release

# Ver dependencias
flutter pub deps
```

---

## 📞 Soporte

Si encuentras problemas:

1. Revisar logs en consola
2. Verificar configuración de Firebase
3. Verificar que el backend esté corriendo
4. Revisar documentación en `docs/`
5. Verificar que todas las dependencias estén instaladas

---

**Última actualización**: 2025-12-08
