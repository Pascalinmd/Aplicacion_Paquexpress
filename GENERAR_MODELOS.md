# Generar Archivos de Modelos

## ⚠️ IMPORTANTE: Generar archivos .g.dart

Los modelos de Flutter utilizan `json_serializable` para la serialización JSON. Antes de ejecutar la aplicación, **DEBES generar los archivos `.g.dart`**.

## 📋 Pasos para generar los archivos

### 1. Instalar dependencias
```powershell
flutter pub get
```

### 2. Generar los archivos .g.dart
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

Este comando generará:
- `lib/models/usuario.g.dart`
- `lib/models/paquete.g.dart`
- `lib/models/entrega.g.dart`

### 3. Verificar que se generaron correctamente
```powershell
ls lib/models/*.g.dart
```

Deberías ver 3 archivos listados.

## 🔄 Si necesitas regenerar los archivos

Si modificas algún modelo, ejecuta nuevamente:
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

O para regenerar automáticamente cuando cambies archivos:
```powershell
flutter pub run build_runner watch
```

## 🚨 Errores comunes

### Error: "part of 'usuario.g.dart' not found"
**Solución:** Ejecuta el comando de build_runner mencionado arriba.

### Error: "Conflicting outputs"
**Solución:** Usa la bandera `--delete-conflicting-outputs`:
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: "build_runner not found"
**Solución:** Asegúrate de haber ejecutado `flutter pub get` primero.

## 📝 Configuración en build.yaml

El archivo `build.yaml` en la raíz del proyecto configura las opciones de generación:
- `explicit_to_json: true` - Genera métodos toJson explícitos para objetos anidados

## ✅ Verificación

Una vez generados los archivos, deberías poder:
1. Compilar la aplicación sin errores
2. Ver los 3 archivos `.g.dart` en `lib/models/`
3. Usar `fromJson` y `toJson` en tus modelos sin problemas

## 🔗 Documentación oficial
- [json_serializable](https://pub.dev/packages/json_serializable)
- [build_runner](https://pub.dev/packages/build_runner)
