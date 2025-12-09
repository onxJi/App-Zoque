# Diagrama de Flujo: Autenticación Admin con JWT

## Flujo Completo de Autenticación

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          USUARIO INICIA SESIÓN                          │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  Google Sign-In Flow   │
                    │  (Firebase Auth)       │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  UserCredential        │
                    │  generado              │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  AuthProvider          │
                    │  signInWithGoogle()    │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  checkIfUserIsAdmin()  │
                    │  (automático)          │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  AuthService           │
                    │  getIdToken()          │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  Firebase Auth         │
                    │  user.getIdToken(true) │
                    │  (force refresh)       │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  Google ID Token (JWT) │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  VerifyAdminUserUseCase│
                    │  call(idToken)         │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  AdminAuthRepository   │
                    │  verifyAdminUser()     │
                    └────────────┬───────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  AdminAuthDataSource   │
                    │  HTTP POST Request     │
                    └────────────┬───────────┘
                                 │
                                 ▼
        ┌────────────────────────────────────────────┐
        │  POST /auth/verify-admin                   │
        │  Headers:                                  │
        │    Authorization: Bearer {idToken}         │
        │    Content-Type: application/json          │
        └────────────────────┬───────────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────────┐
        │           BACKEND API SERVER               │
        │  1. Recibe el JWT                          │
        │  2. Valida con Firebase Admin SDK          │
        │  3. Verifica si es admin (Custom Claims    │
        │     o Base de Datos)                       │
        └────────────────────┬───────────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────────┐
        │  Response:                                 │
        │  200 OK: { "isAdmin": true/false }         │
        │  401 Unauthorized: Token inválido          │
        │  403 Forbidden: No es admin                │
        └────────────────────┬───────────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────────┐
        │  AdminAuthDataSource                       │
        │  Parsea respuesta                          │
        └────────────────────┬───────────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────────┐
        │  AuthProvider                              │
        │  _isAdmin = resultado                      │
        │  _isCheckingAdmin = false                  │
        │  notifyListeners()                         │
        └────────────────────┬───────────────────────┘
                             │
                             ▼
        ┌────────────────────────────────────────────┐
        │  UI REACCIONA AL CAMBIO                    │
        │  Consumer<AuthProvider>                    │
        └────────────────────┬───────────────────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
    ┌───────────────────┐    ┌───────────────────┐
    │  isAdmin = true   │    │  isAdmin = false  │
    │  Mostrar Panel    │    │  Mostrar Acceso   │
    │  de Admin         │    │  Denegado         │
    └───────────────────┘    └───────────────────┘
```

## Estados del AuthProvider

```
┌─────────────────────────────────────────────────────────────┐
│                    ESTADOS DEL AUTH PROVIDER                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐                                           │
│  │ isSignedIn  │  false → true (después de login)          │
│  └─────────────┘                                           │
│                                                             │
│  ┌─────────────────┐                                       │
│  │ isCheckingAdmin │  false → true → false                 │
│  └─────────────────┘         (durante verificación)        │
│                                                             │
│  ┌─────────────┐                                           │
│  │   isAdmin   │  false → true/false (después de verificar)│
│  └─────────────┘                                           │
│                                                             │
│  ┌─────────────┐                                           │
│  │  userName   │  null → "Nombre Usuario"                  │
│  └─────────────┘                                           │
│                                                             │
│  ┌─────────────┐                                           │
│  │  userEmail  │  null → "email@example.com"               │
│  └─────────────┘                                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Arquitectura de Capas (Clean Architecture)

```
┌──────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│  ┌────────────────┐  ┌──────────────┐  ┌──────────────────┐    │
│  │  AuthProvider  │  │  AuthService │  │  UI Widgets      │    │
│  │  (State Mgmt)  │  │  (Firebase)  │  │  (Screens)       │    │
│  └────────┬───────┘  └──────┬───────┘  └──────────────────┘    │
└───────────┼──────────────────┼───────────────────────────────────┘
            │                  │
            ▼                  │
┌──────────────────────────────┼───────────────────────────────────┐
│           DOMAIN LAYER       │                                   │
│  ┌────────────────────────────▼──────────────────┐              │
│  │  VerifyAdminUserUseCase                       │              │
│  │  (Business Logic)                             │              │
│  └────────────────────┬──────────────────────────┘              │
│                       │                                          │
│  ┌────────────────────▼──────────────────────────┐              │
│  │  AdminAuthRepository (Interface)              │              │
│  └────────────────────┬──────────────────────────┘              │
└───────────────────────┼──────────────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                               │
│  ┌────────────────────────────────────────────────┐             │
│  │  AdminAuthRepositoryImpl                       │             │
│  │  (Repository Implementation)                   │             │
│  └────────────────────┬───────────────────────────┘             │
│                       │                                          │
│  ┌────────────────────▼───────────────────────────┐             │
│  │  AdminAuthDataSource                           │             │
│  │  (HTTP Client - API Calls)                     │             │
│  └────────────────────┬───────────────────────────┘             │
└───────────────────────┼──────────────────────────────────────────┘
                        │
                        ▼
            ┌───────────────────────┐
            │   BACKEND API SERVER  │
            │   /auth/verify-admin  │
            └───────────────────────┘
```

## Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUJO DE DATOS                           │
└─────────────────────────────────────────────────────────────────┘

UI Widget
   │
   │ 1. Usuario hace tap en "Login"
   │
   ▼
AuthProvider.signInWithGoogle()
   │
   │ 2. Llama a Firebase Auth
   │
   ▼
AuthService.signInWithGoogle()
   │
   │ 3. Retorna UserCredential
   │
   ▼
AuthProvider.checkIfUserIsAdmin()
   │
   │ 4. Obtiene ID Token
   │
   ▼
AuthService.getIdToken()
   │
   │ 5. Retorna JWT string
   │
   ▼
VerifyAdminUserUseCase.call(jwt)
   │
   │ 6. Ejecuta lógica de negocio
   │
   ▼
AdminAuthRepository.verifyAdminUser(jwt)
   │
   │ 7. Coordina la petición
   │
   ▼
AdminAuthDataSource.verifyAdminUser(jwt)
   │
   │ 8. POST /auth/verify-admin
   │    Headers: Authorization: Bearer {jwt}
   │
   ▼
Backend API
   │
   │ 9. Valida JWT con Firebase
   │ 10. Verifica si es admin
   │ 11. Retorna { "isAdmin": true/false }
   │
   ▼
AdminAuthDataSource
   │
   │ 12. Parsea respuesta JSON
   │
   ▼
AdminAuthRepository
   │
   │ 13. Retorna boolean
   │
   ▼
VerifyAdminUserUseCase
   │
   │ 14. Retorna resultado
   │
   ▼
AuthProvider
   │
   │ 15. Actualiza _isAdmin
   │ 16. notifyListeners()
   │
   ▼
UI Widget (Consumer<AuthProvider>)
   │
   │ 17. Rebuild con nuevo estado
   │ 18. Muestra UI apropiada
   │
   ▼
Usuario ve resultado
```

## Manejo de Errores

```
┌─────────────────────────────────────────────────────────────────┐
│                      MANEJO DE ERRORES                          │
└─────────────────────────────────────────────────────────────────┘

Error en getIdToken()
   │
   ├─→ Usuario no autenticado
   │   └─→ Retorna null
   │       └─→ AuthProvider: isAdmin = false
   │
   ├─→ Token expirado
   │   └─→ Firebase refresca automáticamente
   │       └─→ Retorna nuevo token
   │
   └─→ Error de red
       └─→ Captura excepción
           └─→ AuthProvider: isAdmin = false

Error en Backend Request
   │
   ├─→ 401 Unauthorized
   │   └─→ Token inválido
   │       └─→ Lanza Exception
   │           └─→ AuthProvider: isAdmin = false
   │
   ├─→ 403 Forbidden
   │   └─→ Usuario no es admin
   │       └─→ Retorna false
   │           └─→ AuthProvider: isAdmin = false
   │
   ├─→ 500 Server Error
   │   └─→ Error en backend
   │       └─→ Lanza Exception
   │           └─→ AuthProvider: isAdmin = false
   │
   └─→ Network Error
       └─→ Sin conexión
           └─→ Lanza Exception
               └─→ AuthProvider: isAdmin = false

Todos los errores:
   └─→ isCheckingAdmin = false (finally block)
   └─→ notifyListeners() (finally block)
   └─→ UI muestra estado apropiado
```

## Seguridad

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONSIDERACIONES DE SEGURIDAD                 │
└─────────────────────────────────────────────────────────────────┘

1. JWT (ID Token)
   ├─→ Generado por Firebase Auth
   ├─→ Firmado por Google
   ├─→ Validez: ~1 hora
   ├─→ Se refresca automáticamente
   └─→ Contiene claims del usuario

2. Transmisión
   ├─→ HTTPS obligatorio
   ├─→ Header Authorization
   └─→ Bearer token format

3. Backend
   ├─→ Valida token con Firebase Admin SDK
   ├─→ Verifica firma
   ├─→ Verifica expiración
   ├─→ Verifica issuer
   └─→ Extrae UID del usuario

4. Cliente (Flutter)
   ├─→ No almacena estado de admin en local
   ├─→ Verifica en cada sesión
   ├─→ No confía en datos del cliente
   └─→ Siempre consulta al backend

5. Custom Claims (Recomendado)
   ├─→ Almacenados en el token
   ├─→ Establecidos por Firebase Admin SDK
   ├─→ No modificables por el cliente
   └─→ Verificables sin DB query
```
