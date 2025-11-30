# Guía de Configuración de Google Maps

## Pasos para obtener API Key de Google Maps

### 1. Crear proyecto en Google Cloud Console

1. Ir a [Google Cloud Console](https://console.cloud.google.com/)
2. Crear un nuevo proyecto o seleccionar uno existente
3. Nombrar el proyecto (ej: "Paquexpress")

### 2. Habilitar APIs necesarias

1. En el menú, ir a **APIs y servicios > Biblioteca**
2. Buscar y habilitar las siguientes APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geocoding API** (opcional, para búsqueda de direcciones)

### 3. Crear credenciales (API Key)

1. Ir a **APIs y servicios > Credenciales**
2. Clic en **Crear credenciales > Clave de API**
3. Se generará una API Key
4. Copiar la API Key generada

### 4. Restringir la API Key (Recomendado para producción)

#### Para Android:
1. Editar la API Key
2. En "Restricciones de aplicación", seleccionar **Aplicaciones de Android**
3. Agregar el nombre del paquete y la huella digital SHA-1:

```bash
# Obtener SHA-1 (ejecutar en la raíz del proyecto Flutter)
cd android
./gradlew signingReport

# En Windows:
gradlew.bat signingReport
```

4. Copiar el SHA-1 que aparece en la salida

#### Para iOS:
1. Editar la API Key
2. En "Restricciones de aplicación", seleccionar **Aplicaciones de iOS**
3. Agregar el Bundle ID de tu app (ej: `com.paquexpress.app`)

### 5. Configurar en la aplicación

#### Android

Editar `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY_AQUI"/>
```

#### iOS

1. Editar `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps  // Agregar este import

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("TU_API_KEY_AQUI")  // Agregar esta línea
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

2. Editar `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Esta app necesita acceso a tu ubicación para registrar las entregas</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Esta app necesita acceso a tu ubicación para registrar las entregas</string>
```

### 6. Verificar configuración

Ejecutar la aplicación:

```bash
flutter run
```

Si Google Maps no se muestra:
- Verificar que la API Key esté correctamente configurada
- Verificar que las APIs estén habilitadas en Google Cloud Console
- Verificar los logs de la aplicación para errores específicos

### Costos

Google Maps ofrece **$200 USD de crédito gratuito mensual**, lo cual es suficiente para:
- ~28,000 cargas de mapa
- ~40,000 solicitudes de geocodificación

Para uso de desarrollo y pruebas, esto es más que suficiente.

### Alternativas gratuitas

Si no quieres usar Google Maps, puedes usar:
- **OpenStreetMap** con el paquete `flutter_map`
- **Mapbox** (también tiene una capa gratuita generosa)

## Problemas comunes

### "Google Maps no se muestra"
- Verificar API Key
- Verificar que Maps SDK for Android/iOS esté habilitado
- Revisar logs: `flutter logs`

### "Error de autenticación"
- Verificar que la API Key sea correcta
- Verificar restricciones de la API Key
- Verificar que el SHA-1 coincida (Android)

### "Mapa gris/blanco"
- API Key no configurada
- APIs no habilitadas en Google Cloud Console
- Problemas de conexión a internet
