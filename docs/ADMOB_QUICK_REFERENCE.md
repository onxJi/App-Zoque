# AdMob - Guía Rápida de Referencia

## 🚀 Inicio Rápido

### Mostrar Anuncio Intersticial
```dart
final adMobProvider = context.read<AdMobProvider>();
await adMobProvider.loadAndShowInterstitialAd();
```

### Mostrar Anuncio Recompensado
```dart
final adMobProvider = context.read<AdMobProvider>();
await adMobProvider.loadRewardedAd();

if (adMobProvider.isRewardedAdReady) {
  await adMobProvider.showRewardedAd(
    onRewarded: () {
      // Usuario ganó la recompensa
      print('¡Recompensa otorgada!');
    },
  );
}
```

## 📋 Checklist para Producción

- [ ] Crear cuenta en [AdMob](https://admob.google.com/)
- [ ] Registrar la aplicación en AdMob
- [ ] Crear unidades de anuncios (Interstitial, Rewarded)
- [ ] Actualizar App ID en `AndroidManifest.xml`
- [ ] Actualizar Ad Unit IDs en `admob_config.dart`
- [ ] Cambiar `useTestAds = false` en `admob_config.dart`
- [ ] Probar en dispositivo real
- [ ] Verificar políticas de AdMob

## 🔧 Archivos Clave

| Archivo | Propósito |
|---------|-----------|
| `lib/features/admob/config/admob_config.dart` | Configuración de IDs (Test/Producción) |
| `lib/features/admob/presentation/providers/admob_provider.dart` | Provider para usar en la UI |
| `android/app/src/main/AndroidManifest.xml` | App ID de AdMob |
| `docs/ADMOB_FEATURE.md` | Documentación completa |

## 💡 Snippets Útiles

### Verificar si un anuncio está listo
```dart
if (adMobProvider.isInterstitialAdReady) {
  // El anuncio está listo para mostrarse
}
```

### Cargar anuncio sin mostrarlo inmediatamente
```dart
await adMobProvider.loadInterstitialAd();
// Mostrar más tarde cuando sea necesario
await adMobProvider.showInterstitialAd();
```

### Manejar errores
```dart
final adMobProvider = context.watch<AdMobProvider>();
if (adMobProvider.error != null) {
  print('Error: ${adMobProvider.error}');
}
```

## 🎯 Casos de Uso

### Al completar un nivel
```dart
void onLevelCompleted() async {
  // Lógica del nivel
  saveProgress();
  
  // Mostrar anuncio cada 3 niveles
  if (currentLevel % 3 == 0) {
    await context.read<AdMobProvider>().loadAndShowInterstitialAd();
  }
  
  // Navegar a siguiente nivel
  goToNextLevel();
}
```

### Sistema de monedas con anuncios recompensados
```dart
void watchAdForCoins() async {
  final adMobProvider = context.read<AdMobProvider>();
  await adMobProvider.loadRewardedAd();
  
  if (adMobProvider.isRewardedAdReady) {
    await adMobProvider.showRewardedAd(
      onRewarded: () {
        setState(() {
          coins += 50; // Dar 50 monedas
        });
        saveCoins();
      },
    );
  }
}
```

### Anuncio al cambiar de sección
```dart
void navigateToSection(String section) async {
  // Mostrar anuncio antes de navegar
  await context.read<AdMobProvider>().loadAndShowInterstitialAd();
  
  // Navegar
  if (mounted) {
    context.go('/section/$section');
  }
}
```

## ⚙️ Configuración Rápida

### Modo de Prueba (Default)
```dart
// En admob_config.dart
static const bool useTestAds = true; // ✅ Usa IDs de prueba
```

### Modo de Producción
```dart
// En admob_config.dart
static const bool useTestAds = false; // ⚠️ Usa IDs reales
```

## 🐛 Troubleshooting

### El anuncio no se muestra
1. Verifica que AdMob esté inicializado
2. Verifica que el anuncio esté cargado (`isInterstitialAdReady`)
3. Revisa los logs en la consola
4. Asegúrate de tener conexión a internet

### Error de ID inválido
- En modo de prueba: Verifica que estés usando los IDs de prueba correctos
- En producción: Verifica que los IDs en `admob_config.dart` sean correctos

### El anuncio se muestra pero no genera ingresos
- Asegúrate de haber cambiado `useTestAds = false`
- Verifica que estés usando tus IDs de producción reales
- Los anuncios de prueba NO generan ingresos

## 📱 Testing

### Probar en Emulador
```bash
flutter run
```

### Probar en Dispositivo Real
```bash
flutter run -d <device-id>
```

### Build de Producción
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📚 Recursos

- [Documentación Completa](ADMOB_FEATURE.md)
- [Widget de Ejemplo](../lib/features/admob/presentation/widgets/admob_example_widget.dart)
- [AdMob Console](https://admob.google.com/)
- [Políticas de AdMob](https://support.google.com/admob/answer/6128543)

## ⚡ Tips

1. **Pre-carga anuncios**: Carga anuncios antes de mostrarlos para mejor UX
2. **Frecuencia**: No muestres anuncios muy seguido (molesta a los usuarios)
3. **Contexto**: Muestra anuncios en momentos naturales (fin de nivel, cambio de sección)
4. **Testing**: Siempre usa IDs de prueba durante desarrollo
5. **Políticas**: Lee y cumple las políticas de AdMob para evitar suspensiones
