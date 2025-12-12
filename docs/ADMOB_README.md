# 🎯 AdMob Integration - Complete Feature

## 📌 Descripción General

Feature completa de integración de AdMob para mostrar anuncios intersticiales y recompensados en la aplicación, implementada siguiendo Clean Architecture.

## ✨ Características

- ✅ **Anuncios Intersticiales**: Anuncios de pantalla completa
- ✅ **Anuncios Recompensados**: Anuncios que otorgan recompensas
- ✅ **Clean Architecture**: Código organizado y mantenible
- ✅ **Configuración Centralizada**: Fácil cambio entre test/producción
- ✅ **Gestión de Estado**: Provider pattern para UI reactiva
- ✅ **Manejo de Errores**: Gestión robusta de errores
- ✅ **Multiplataforma**: Android e iOS

## 🚀 Inicio Rápido

### Mostrar un anuncio intersticial
```dart
final adMobProvider = context.read<AdMobProvider>();
await adMobProvider.loadAndShowInterstitialAd();
```

### Mostrar un anuncio recompensado
```dart
final adMobProvider = context.read<AdMobProvider>();
await adMobProvider.loadRewardedAd();

if (adMobProvider.isRewardedAdReady) {
  await adMobProvider.showRewardedAd(
    onRewarded: () {
      // Dar recompensa al usuario
    },
  );
}
```

## 📚 Documentación

| Documento | Descripción |
|-----------|-------------|
| [ADMOB_FEATURE.md](ADMOB_FEATURE.md) | Documentación completa de la feature |
| [ADMOB_QUICK_REFERENCE.md](ADMOB_QUICK_REFERENCE.md) | Guía rápida con snippets de código |
| [ADMOB_ARCHITECTURE.md](ADMOB_ARCHITECTURE.md) | Diagramas de arquitectura y flujo de datos |
| [ADMOB_IMPLEMENTATION_SUMMARY.md](ADMOB_IMPLEMENTATION_SUMMARY.md) | Resumen de implementación |

## 📁 Estructura de Archivos

```
lib/features/admob/
├── config/
│   └── admob_config.dart              # ⚙️ Configuración de IDs
├── domain/
│   ├── entities/
│   │   └── ad.dart                    # 📦 Entidad Ad
│   └── repositories/
│       └── ad_repository.dart         # 📋 Interface
├── data/
│   ├── datasources/
│   │   └── admob_data_source.dart     # 🔌 SDK Integration
│   └── repositories/
│       └── ad_repository_impl.dart    # 🔨 Implementación
└── presentation/
    ├── providers/
    │   └── admob_provider.dart        # 🎨 State Management
    └── widgets/
        └── admob_example_widget.dart  # 📱 Ejemplo de UI
```

## 🎯 Implementación Actual

### Anuncio al Inicio de la App

Actualmente, la app muestra un anuncio intersticial automáticamente después del splash screen:

**Ubicación**: `lib/app.dart`

```dart
void initialization() async {
  print('Initializing app...');
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  
  // Load and show interstitial ad after splash screen
  if (mounted) {
    final adMobProvider = context.read<AdMobProvider>();
    await adMobProvider.loadAndShowInterstitialAd();
  }
}
```

## ⚙️ Configuración

### Modo de Desarrollo (Actual)
```dart
// lib/features/admob/config/admob_config.dart
static const bool useTestAds = true; // ✅ Usando IDs de prueba
```

### Para Producción

1. **Crear cuenta en AdMob**: https://admob.google.com/
2. **Registrar la aplicación**
3. **Crear unidades de anuncios**
4. **Actualizar configuración**:

```dart
// lib/features/admob/config/admob_config.dart
static const bool useTestAds = false; // ⚠️ Cambiar a false

// Actualizar con tus IDs reales
static const String _androidInterstitialId = 'ca-app-pub-XXXXX/YYYYY';
static const String _iosInterstitialId = 'ca-app-pub-XXXXX/YYYYY';
```

5. **Actualizar AndroidManifest.xml**:
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXX~YYYYY"/>
```

## 🎨 Casos de Uso

### 1. Anuncio al Completar una Acción
```dart
void onActionCompleted() async {
  await performAction();
  await context.read<AdMobProvider>().loadAndShowInterstitialAd();
}
```

### 2. Sistema de Recompensas
```dart
void earnCoins() async {
  final adMobProvider = context.read<AdMobProvider>();
  await adMobProvider.loadRewardedAd();
  
  if (adMobProvider.isRewardedAdReady) {
    await adMobProvider.showRewardedAd(
      onRewarded: () {
        setState(() => coins += 50);
      },
    );
  }
}
```

### 3. Anuncio con Frecuencia Controlada
```dart
void showAdIfNeeded() async {
  if (actionCount % 5 == 0) { // Cada 5 acciones
    await context.read<AdMobProvider>().loadAndShowInterstitialAd();
  }
}
```

## 🧪 Testing

### Ejecutar la App
```bash
flutter pub get
flutter run
```

### Build de Producción
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📊 Estado del Provider

El `AdMobProvider` expone:

```dart
// Estado
bool isInitialized              // SDK inicializado
bool isInterstitialAdReady      // Anuncio intersticial listo
bool isRewardedAdReady          // Anuncio recompensado listo
String? error                   // Último error

// Métodos
Future<void> initialize()
Future<void> loadInterstitialAd()
Future<void> showInterstitialAd()
Future<void> loadAndShowInterstitialAd()
Future<void> loadRewardedAd()
Future<void> showRewardedAd({required Function onRewarded})
```

## 🔍 Debugging

### Ver Logs de AdMob
Los errores se imprimen automáticamente en modo debug:

```dart
if (kDebugMode) {
  print('Error loading interstitial ad: $e');
}
```

### Verificar Estado
```dart
final adMobProvider = context.watch<AdMobProvider>();
print('Initialized: ${adMobProvider.isInitialized}');
print('Ad Ready: ${adMobProvider.isInterstitialAdReady}');
print('Error: ${adMobProvider.error}');
```

## ⚠️ Importante

### ❌ NO Hacer en Producción
- Usar IDs de prueba (`useTestAds = true`)
- Mostrar anuncios muy frecuentemente
- Ignorar las políticas de AdMob

### ✅ Hacer en Producción
- Cambiar a IDs reales (`useTestAds = false`)
- Respetar la experiencia del usuario
- Seguir las políticas de AdMob
- Monitorear métricas en AdMob Console

## 📱 Plataformas

- ✅ Android (minSdk 23+)
- ✅ iOS (10.0+)

## 🔗 Enlaces Útiles

- [AdMob Console](https://admob.google.com/)
- [Políticas de AdMob](https://support.google.com/admob/answer/6128543)
- [Google Mobile Ads Plugin](https://pub.dev/packages/google_mobile_ads)
- [Documentación de AdMob](https://developers.google.com/admob)

## 🆘 Soporte

Si tienes problemas:

1. Revisa la [documentación completa](ADMOB_FEATURE.md)
2. Consulta la [guía rápida](ADMOB_QUICK_REFERENCE.md)
3. Verifica los logs de la consola
4. Asegúrate de tener conexión a internet
5. Verifica que los IDs sean correctos

## 📝 Notas de Versión

### v1.0.0 (2025-12-12)
- ✅ Implementación inicial
- ✅ Anuncios intersticiales
- ✅ Anuncios recompensados
- ✅ Configuración centralizada
- ✅ Documentación completa
- ✅ Widget de ejemplo

## 🚀 Próximas Mejoras

- [ ] Banner ads
- [ ] Native ads
- [ ] Frecuencia configurable
- [ ] Analytics integration
- [ ] Ad mediation
- [ ] A/B testing de frecuencia

---

**Desarrollado con** ❤️ **siguiendo Clean Architecture**
