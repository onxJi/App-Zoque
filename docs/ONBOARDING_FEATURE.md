# Feature: Onboarding

## Descripción

La funcionalidad de **Onboarding** proporciona una experiencia de bienvenida para los usuarios que abren la aplicación por primera vez. Muestra 3 pantallas interactivas que presentan las características principales de la aplicación antes de llegar a la pantalla de login.

## Estructura de Archivos

```
lib/
├── core/
│   └── services/
│       └── preferences_service.dart    # Servicio para manejar preferencias persistentes
└── features/
    └── onboarding/
        └── presentation/
            └── screens/
                └── onboarding_screen.dart    # Pantalla de onboarding con 3 páginas
```

## Componentes Principales

### 1. PreferencesService (`core/services/preferences_service.dart`)

Servicio singleton que gestiona el estado de "primera vez" usando `SharedPreferences`.

**Métodos principales:**
- `getInstance()`: Obtiene la instancia del servicio
- `isFirstTime`: Getter que retorna `true` si es la primera vez que se abre la app
- `setNotFirstTime()`: Marca que la app ya ha sido abierta
- `resetFirstTime()`: Resetea el flag (útil para testing)

### 2. OnboardingScreen (`features/onboarding/presentation/screens/onboarding_screen.dart`)

Pantalla con 3 páginas deslizables que muestran:

1. **Página 1 - Aprende Zoque**
   - Título: "Aprende Zoque"
   - Texto en Zoque: "Tsame Angpeng"
   - Descripción: Descubre y aprende el idioma Zoque de manera interactiva

2. **Página 2 - Diccionario Completo**
   - Título: "Diccionario Completo"
   - Texto en Zoque: "Tʉmʉ Angpoya"
   - Descripción: Accede a un diccionario completo con pronunciación y ejemplos

3. **Página 3 - Noticias y Cultura**
   - Título: "Noticias y Cultura"
   - Texto en Zoque: "Tsame Yomo"
   - Descripción: Mantente informado sobre la cultura y comunidad Zoque

**Características:**
- Navegación por deslizamiento (swipe)
- Indicadores de página animados
- Botón "Saltar" para omitir el onboarding
- Botón "Siguiente" que cambia a "Comenzar" en la última página
- Diseño con gradientes y animaciones suaves
- Colores de la paleta de la app (#1E92A1, #156572)

## Flujo de Navegación

```
App Inicio
    ↓
¿Es primera vez?
    ├─ Sí → /onboarding → (completar) → /auth (login)
    └─ No → /auth (login) → (autenticado) → /home
```

### Lógica de Redirección (en `app.dart`)

1. **Primera vez**: Redirige a `/onboarding`
2. **Onboarding completado**: Marca como "no primera vez" y redirige a `/auth`
3. **Subsecuentes aperturas**: Va directo a `/auth` o `/home` según estado de autenticación

## Integración con el Router

El router en `app.dart` incluye:

```dart
routes: [
  GoRoute(
    path: '/onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),
  GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
  GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
],
redirect: (context, state) async {
  // Lógica de redirección basada en isFirstTime
  final prefs = await PreferencesService.getInstance();
  final isFirstTime = prefs.isFirstTime;
  
  if (isFirstTime && location != '/onboarding') {
    return '/onboarding';
  }
  // ... resto de la lógica de autenticación
}
```

## Dependencias Agregadas

- `shared_preferences: ^2.2.2` - Para almacenar el estado de primera vez de forma persistente

## Cómo Probar

### Probar el Onboarding
1. Ejecuta la app por primera vez
2. Deberías ver las 3 pantallas de onboarding
3. Puedes:
   - Deslizar para navegar entre páginas
   - Presionar "Siguiente" para avanzar
   - Presionar "Saltar" para omitir
   - Presionar "Comenzar" en la última página

### Resetear para Ver el Onboarding Nuevamente

Para testing, puedes agregar temporalmente este código en algún lugar de la app:

```dart
// Resetear onboarding (solo para testing)
final prefs = await PreferencesService.getInstance();
await prefs.resetFirstTime();
```

O desinstalar y reinstalar la app.

## Personalización

### Cambiar el Contenido de las Páginas

Edita la lista `_pages` en `OnboardingScreen`:

```dart
final List<OnboardingPage> _pages = [
  OnboardingPage(
    title: 'Tu Título',
    subtitle: 'Tu descripción',
    zoqueText: 'Texto en Zoque',
    imagePath: 'assets/tu_imagen.svg',
    color: const Color(0xFF1E92A1),
  ),
  // ... más páginas
];
```

### Cambiar los Colores

Los colores están definidos en cada `OnboardingPage`. Puedes usar los colores de la paleta de la app:
- Primary: `#1E92A1`
- Secondary: `#FBB03B`
- Surface: `#F0F9FA`
- Dark: `#156572`

## Notas Técnicas

- El servicio `PreferencesService` es un singleton para evitar múltiples instancias
- La verificación de `isFirstTime` se hace de forma asíncrona en el router
- El estado se persiste automáticamente en el dispositivo
- Compatible con hot reload durante el desarrollo
