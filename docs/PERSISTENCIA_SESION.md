# Persistencia de Sesión - Documentación

## Descripción General

La aplicación ahora implementa persistencia de sesión automática utilizando Firebase Authentication. Esto significa que cuando un usuario inicia sesión, su sesión se mantiene activa incluso después de cerrar y volver a abrir la aplicación, hasta que:

1. El usuario cierre sesión manualmente
2. La sesión de Google expire (según la configuración de Google)
3. El token de autenticación sea revocado

## Componentes Implementados

### 1. AuthProvider (`lib/features/auth/providers/auth_provider.dart`)

**Cambios realizados:**
- Agregado flag `_isInitialized` para rastrear si el estado de autenticación ya fue verificado
- Agregado método `_checkCurrentUser()` que verifica si hay un usuario autenticado al iniciar
- El constructor ahora:
  1. Llama a `_checkCurrentUser()` para verificar sesión existente
  2. Escucha cambios en `authStateChanges` para actualizaciones en tiempo real

**Propiedades nuevas:**
- `isInitialized`: Indica si ya se verificó el estado de autenticación inicial

### 2. App Router (`lib/app.dart`)

**Cambios realizados:**
- Convertido el `GoRouter` en una función `createRouter()` que recibe el `AuthProvider`
- Agregado `refreshListenable: authProvider` para que el router escuche cambios de autenticación
- Implementada lógica de redirección mejorada:
  - Si no está inicializado: mantiene la ubicación actual
  - Si no está autenticado: redirige a `/` (login)
  - Si está autenticado en login: redirige a `/home`
- Agregada pantalla de carga (`SplashScreen`) mientras se verifica el estado inicial

### 3. SplashScreen (`lib/features/auth/presentation/screens/splash_screen.dart`)

**Nueva pantalla:**
- Muestra el logo de la aplicación
- Indicador de carga
- Mensaje "Verificando sesión..."
- Se muestra brevemente mientras Firebase verifica si hay una sesión activa

## Flujo de Funcionamiento

### Primer Inicio (Sin sesión previa)
1. App inicia → `AuthProvider` se crea
2. `_checkCurrentUser()` verifica: no hay usuario
3. `_isInitialized = true`
4. Router redirige a `/` (AuthScreen - Login)
5. Usuario ve pantalla de login

### Inicio de Sesión
1. Usuario presiona "Iniciar sesión con Google"
2. `signInWithGoogle()` se ejecuta
3. Firebase guarda el token automáticamente
4. `authStateChanges` emite el nuevo usuario
5. `AuthProvider` actualiza `_isSignedIn = true`
6. Router detecta el cambio y redirige a `/home`

### Cierre de Sesión
1. Usuario presiona "Cerrar Sesión" en AccountScreen
2. `signOut()` se ejecuta
3. Firebase elimina el token
4. `authStateChanges` emite `null`
5. `AuthProvider` actualiza `_isSignedIn = false`
6. `AccountScreen` navega a `/` usando `context.go('/')`
7. Usuario ve pantalla de login

### Reinicio de App (Con sesión activa)
1. App inicia → `AuthProvider` se crea
2. `_checkCurrentUser()` verifica: **hay usuario activo**
3. `_isSignedIn = true`, `_isInitialized = true`
4. SplashScreen se muestra brevemente
5. Router detecta `isSignedIn = true`
6. Router redirige automáticamente a `/home`
7. Usuario ve directamente el home (sin login)

## Ventajas de esta Implementación

1. **Experiencia de Usuario Mejorada**: No necesita iniciar sesión cada vez
2. **Seguridad**: Usa los tokens de Firebase que son seguros y tienen expiración
3. **Sincronización Automática**: Si el token expira, automáticamente cierra sesión
4. **Feedback Visual**: SplashScreen profesional durante la verificación
5. **Reactivo**: Usa `refreshListenable` para actualizar rutas automáticamente

## Configuración de Tiempo de Sesión

El tiempo de sesión es manejado por Google/Firebase:
- **Access Token**: ~1 hora
- **Refresh Token**: Se usa automáticamente para renovar el access token
- **Sesión persistente**: Hasta que el usuario cierre sesión o revoque permisos

Firebase maneja automáticamente la renovación de tokens, por lo que la sesión puede durar indefinidamente mientras el refresh token sea válido.

## Pruebas Recomendadas

1. **Iniciar sesión y cerrar app**: Verificar que al reabrir vaya directo al home
2. **Cerrar sesión**: Verificar que vaya al login y no persista
3. **Modo avión**: Verificar comportamiento sin conexión
4. **Expiración de token**: Esperar tiempo suficiente para que expire (difícil de probar)

## Notas Técnicas

- Firebase Auth persiste los tokens en el almacenamiento local del dispositivo
- En Android: SharedPreferences
- En iOS: Keychain
- En Web: LocalStorage/IndexedDB
- Los tokens están encriptados y son seguros
