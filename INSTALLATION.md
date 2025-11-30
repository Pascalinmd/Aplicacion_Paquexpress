# Guía de Instalación y Ejecución

## Configuración paso a paso

### 1. Clonar o descargar el proyecto

```bash
cd "c:\Aplicaciones de Flutter\evaluacion_3"
```

### 2. Configurar el Backend (FastAPI)

#### A. Instalar MySQL

1. Descargar e instalar [MySQL Community Server](https://dev.mysql.com/downloads/mysql/)
2. Durante la instalación, configurar:
   - Usuario: `root`
   - Contraseña: (la que prefieras, o dejar vacía)
   - Puerto: `3306`

#### B. Configurar el entorno Python

```bash
# Navegar a la carpeta del backend
cd backend

# Crear entorno virtual
python -m venv venv

# Activar entorno virtual
# Windows PowerShell:
.\venv\Scripts\Activate.ps1
# O en CMD:
venv\Scripts\activate.bat

# Instalar dependencias
pip install -r requirements.txt
```

#### C. Configurar variables de entorno

1. Copiar el archivo de ejemplo:
```bash
copy .env.example .env
```

2. Editar `.env` con tus credenciales de MySQL:
```
MYSQL_USER=root
MYSQL_PASSWORD=tu_contraseña_aqui
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=paquexpress_db
SECRET_KEY=cambia_esta_clave_por_una_segura_en_produccion
```

#### D. Inicializar la base de datos

```bash
# Asegúrate de que MySQL esté corriendo
python database/init_db.py
```

Deberías ver:
```
✓ Conectado a MySQL
✓ Base de datos inicializada correctamente
✓ Tablas creadas
✓ Datos de prueba insertados
```

#### E. Ejecutar el servidor

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Verificar que funciona:
- API: http://localhost:8000
- Documentación: http://localhost:8000/docs

### 3. Configurar Flutter

#### A. Verificar instalación de Flutter

```bash
flutter doctor
```

Resolver cualquier problema indicado.

#### B. Instalar dependencias

```bash
# Desde la raíz del proyecto
cd ..
flutter pub get
```

#### C. Generar código de serialización

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Esto generará los archivos:
- `lib/models/usuario.g.dart`
- `lib/models/paquete.g.dart`
- `lib/models/entrega.g.dart`

#### D. Configurar URL del backend

Editar `lib/services/api_service.dart`:

```dart
// Línea 9-11
// Para emulador Android:
static const String baseUrl = 'http://10.0.2.2:8000';

// Para dispositivo físico, usar tu IP local:
// En PowerShell: ipconfig
// Buscar "IPv4 Address" de tu adaptador WiFi/Ethernet
// static const String baseUrl = 'http://192.168.1.X:8000';

// Para iOS Simulator:
// static const String baseUrl = 'http://localhost:8000';
```

#### E. Configurar Google Maps (Opcional)

Ver [GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md) para instrucciones detalladas.

Editar `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_API_KEY_AQUI"/>
```

> **Nota:** La app funciona sin Google Maps, pero la funcionalidad de mapa no estará disponible.

### 4. Ejecutar la aplicación

#### Opción 1: Con Android Studio

1. Abrir Android Studio
2. Abrir el proyecto
3. Seleccionar dispositivo (emulador o físico)
4. Clic en "Run" (▶)

#### Opción 2: Desde terminal

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# O simplemente:
flutter run
```

### 5. Probar la aplicación

#### Credenciales de prueba:

| Usuario | Contraseña |
|---------|-----------|
| agente1 | password123 |
| agente2 | password123 |
| agente3 | password123 |

#### Flujo de prueba:

1. **Login:** Usar `agente1` / `password123`
2. **Ver paquetes:** Deberías ver 4 paquetes asignados
3. **Seleccionar paquete:** Clic en cualquier paquete pendiente
4. **Proceso de entrega:**
   - Esperar a que se obtenga GPS automáticamente
   - Capturar una foto (o seleccionar de galería)
   - Opcional: Ver en mapa (si Google Maps está configurado)
   - Opcional: Agregar observaciones
   - Clic en "PAQUETE ENTREGADO"
5. **Verificar:** El paquete desaparece de la lista

## Problemas comunes

### Backend

#### "Error al conectar a MySQL"
```bash
# Verificar que MySQL está corriendo
# Windows (en PowerShell como Admin):
Get-Service MySQL*

# Si no está corriendo, iniciar:
Start-Service MySQL80
```

#### "ModuleNotFoundError"
```bash
# Asegurarse de que el entorno virtual está activado
# Reinstalar dependencias:
pip install -r requirements.txt
```

### Flutter

#### "Unable to connect to API"
- Verificar que el backend esté corriendo (http://localhost:8000)
- Verificar la URL en `api_service.dart`
- Para emulador Android: usar `10.0.2.2` en lugar de `localhost`

#### "Location permission denied"
- En el emulador: Features > Location > Configurar ubicación
- En dispositivo físico: Ir a Ajustes > Permisos > Ubicación > Permitir

#### "Camera permission denied"
- Otorgar permisos cuando la app lo solicite
- O ir a configuración de la app y habilitar manualmente

#### "Google Maps no funciona"
- Ver [GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md)
- La app funciona sin Google Maps, solo no se verá el mapa

#### Error de compilación
```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Verificación de funcionamiento

### Backend
```bash
# Probar endpoint de login
curl -X POST "http://localhost:8000/api/auth/login" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"agente1\",\"password\":\"password123\"}"
```

Debería retornar un JSON con `access_token`.

### Base de datos
```sql
-- Conectar a MySQL y verificar datos
mysql -u root -p
USE paquexpress_db;
SELECT * FROM usuarios;
SELECT * FROM paquetes WHERE agente_id = 1;
```

## Despliegue

### Backend en producción

1. Usar un servidor web (Nginx + Gunicorn)
2. Configurar HTTPS
3. Usar variables de entorno para credenciales
4. Configurar backup de base de datos

### App móvil

```bash
# Android (APK)
flutter build apk --release

# Android (App Bundle para Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

Los archivos compilados estarán en `build/`.

## Recursos adicionales

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de FastAPI](https://fastapi.tiangolo.com/)
- [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter)

## Soporte

Para problemas o preguntas sobre el proyecto, revisar:
1. Los logs de la aplicación: `flutter logs`
2. Los logs del backend en la terminal donde corre uvicorn
3. La documentación de la API: http://localhost:8000/docs
