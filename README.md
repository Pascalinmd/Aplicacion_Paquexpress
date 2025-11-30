# Paquexpress - Sistema de Entregas

## 📚 Documentación del Proyecto

| Documento | Descripción |
|-----------|-------------|
| **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** | ⚡ Checklist paso a paso para ejecutar el proyecto |
| **[RESUMEN.md](RESUMEN.md)** | 📄 Resumen ejecutivo de una página |
| **[README.md](README.md)** | 📖 Este archivo - Documentación completa |
| **[INSTALLATION.md](INSTALLATION.md)** | 🛠️ Guía detallada de instalación |
| **[GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md)** | 🗺️ Configuración de Google Maps |
| **[COMANDOS_UTILES.md](COMANDOS_UTILES.md)** | 💻 Comandos útiles de desarrollo |
| **[PROYECTO_COMPLETADO.md](PROYECTO_COMPLETADO.md)** | ✅ Resumen técnico completo |
| **[ARCHIVOS_CREADOS.md](ARCHIVOS_CREADOS.md)** | 📝 Lista de todos los archivos |
| **[backend/README.md](backend/README.md)** | 🔧 Documentación del backend |

---

## Descripción del Proyecto

Aplicación móvil desarrollada para **Paquexpress S.A. de C.V.**, empresa dedicada a la logística y distribución de paquetes a nivel nacional. El sistema permite a los agentes de entrega en campo gestionar y registrar entregas de paquetes con evidencia fotográfica y geolocalización GPS.

## Características Principales

### Funcionalidades Básicas (Mínimo Operativo)
- ✅ Selección de paquetes desde lista de entregas asignadas
- ✅ Identificación por ID único y dirección de destino
- ✅ Captura de fotografía como evidencia de entrega
- ✅ Obtención de ubicación GPS al momento de entrega
- ✅ Botón "Paquete Entregado" para guardar en BD

### Funcionalidades Avanzadas
- ✅ Inicio de sesión seguro con validación de credenciales
- ✅ Encriptación de contraseñas con bcrypt
- ✅ Manejo seguro de sesiones con JWT
- ✅ Visualización de dirección en mapa interactivo (Google Maps)
- ✅ Navegación y confirmación de punto de entrega
- ✅ Cálculo de distancia al destino
- ✅ Historial de entregas realizadas

## Stack Tecnológico

### Frontend (Aplicación Móvil)
- **Framework:** Flutter 3.9+
- **Lenguaje:** Dart
- **Paquetes principales:**
  - `http` - Peticiones HTTP
  - `image_picker` - Captura de fotos
  - `geolocator` - Geolocalización GPS
  - `google_maps_flutter` - Mapas interactivos
  - `flutter_secure_storage` - Almacenamiento seguro
  - `provider` - Gestión de estado

### Backend (API REST)
- **Framework:** FastAPI (Python)
- **Base de Datos:** MySQL
- **ORM:** SQLAlchemy
- **Autenticación:** JWT (JSON Web Tokens)
- **Encriptación:** Passlib con bcrypt

## Estructura del Proyecto

```
evaluacion_3/
├── lib/                          # Código Flutter
│   ├── models/                   # Modelos de datos
│   │   ├── usuario.dart
│   │   ├── paquete.dart
│   │   └── entrega.dart
│   ├── services/                 # Servicios
│   │   ├── api_service.dart      # Comunicación con API
│   │   ├── auth_service.dart     # Autenticación
│   │   └── location_service.dart # GPS
│   ├── screens/                  # Pantallas
│   │   ├── login_screen.dart     # Inicio de sesión
│   │   ├── packages_list_screen.dart # Lista de paquetes
│   │   ├── delivery_screen.dart  # Entrega de paquete
│   │   └── map_screen.dart       # Visualización de mapa
│   └── main.dart                 # Punto de entrada
├── backend/                      # Backend FastAPI
│   ├── database/                 # Configuración BD
│   │   ├── config.py
│   │   ├── schema.sql
│   │   └── init_db.py
│   ├── models/                   # Modelos SQLAlchemy
│   │   └── models.py
│   ├── routes/                   # Endpoints API
│   │   ├── auth.py
│   │   ├── paquetes.py
│   │   └── entregas.py
│   ├── utils/                    # Utilidades
│   │   ├── security.py
│   │   └── dependencies.py
│   ├── main.py                   # Aplicación FastAPI
│   └── requirements.txt          # Dependencias Python
└── README.md                     # Este archivo
```

## Instalación y Configuración

### Prerrequisitos

- Flutter SDK 3.9 o superior
- Dart 3.0 o superior
- Python 3.9 o superior
- MySQL Server 8.0 o superior
- Android Studio / Xcode (para desarrollo móvil)
- Visual Studio Code (recomendado)

### Configuración del Backend

1. **Navegar a la carpeta del backend:**
   ```bash
   cd backend
   ```

2. **Crear y activar entorno virtual:**
   ```bash
   python -m venv venv
   # Windows
   venv\Scripts\activate
   # Linux/Mac
   source venv/bin/activate
   ```

3. **Instalar dependencias:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configurar base de datos:**
   - Crear base de datos MySQL: `paquexpress_db`
   - Copiar `.env.example` a `.env`
   - Configurar credenciales en `.env`:
     ```
     MYSQL_USER=root
     MYSQL_PASSWORD=tu_contraseña
     MYSQL_HOST=localhost
     MYSQL_PORT=3306
     MYSQL_DATABASE=paquexpress_db
     ```

5. **Inicializar base de datos:**
   ```bash
   python database/init_db.py
   ```

6. **Ejecutar servidor:**
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

   API disponible en: http://localhost:8000
   
   Documentación: http://localhost:8000/docs

### Configuración de Flutter

1. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

2. **Generar código de serialización:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Configurar URL del API:**
   
   Editar `lib/services/api_service.dart`:
   ```dart
   // Para emulador Android
   static const String baseUrl = 'http://10.0.2.2:8000';
   
   // Para dispositivo físico (cambiar por tu IP local)
   // static const String baseUrl = 'http://192.168.1.X:8000';
   
   // Para iOS Simulator
   // static const String baseUrl = 'http://localhost:8000';
   ```

4. **Configurar Google Maps:**
   
   **Android:** Editar `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="TU_API_KEY_DE_GOOGLE_MAPS"/>
   ```
   
   **iOS:** Editar `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("TU_API_KEY_DE_GOOGLE_MAPS")
   ```

5. **Ejecutar aplicación:**
   ```bash
   flutter run
   ```

## Credenciales de Prueba

### Usuarios del Sistema

| Usuario | Contraseña | Nombre Completo |
|---------|-----------|-----------------|
| agente1 | password123 | Juan Pérez |
| agente2 | password123 | María González |
| agente3 | password123 | Carlos Rodríguez |

## Uso de la Aplicación

### 1. Inicio de Sesión
- Abrir la aplicación
- Ingresar usuario y contraseña
- El token JWT se almacena de forma segura

### 2. Lista de Paquetes
- Ver paquetes asignados (pendientes y en tránsito)
- Información de cada paquete:
  - Número de rastreo
  - Destinatario
  - Dirección
  - Estado actual

### 3. Proceso de Entrega
- Seleccionar un paquete
- **Capturar foto:** Tomar foto o seleccionar de galería
- **GPS:** Ubicación se obtiene automáticamente
- **Ver mapa:** Visualizar ubicación de destino y calcular distancia
- **Observaciones:** Agregar notas opcionales
- **Confirmar:** Botón "PAQUETE ENTREGADO"

### 4. Visualización en Mapa
- Marker rojo: Ubicación de destino
- Marker azul: Ubicación actual del agente
- Cálculo automático de distancia
- Controles para centrar y ajustar vista

## API Endpoints

### Autenticación
- `POST /api/auth/login` - Iniciar sesión

### Paquetes
- `GET /api/paquetes/agente/{agente_id}` - Obtener paquetes asignados
- `GET /api/paquetes/{paquete_id}` - Obtener paquete específico
- `PUT /api/paquetes/{paquete_id}/estado` - Actualizar estado

### Entregas
- `POST /api/entregas` - Registrar entrega
- `POST /api/entregas/upload-foto` - Subir foto de evidencia

Documentación completa: http://localhost:8000/docs

## Seguridad

### Encriptación de Contraseñas
- Algoritmo: bcrypt
- Salt rounds: 12
- Hashes almacenados en BD

### Tokens JWT
- Algoritmo: HS256
- Expiración: 7 días
- Incluye: user_id, username

### Comunicación
- HTTPS en producción (recomendado)
- Headers de autenticación: `Authorization: Bearer <token>`

### Almacenamiento Móvil
- `flutter_secure_storage` para tokens
- Datos encriptados en dispositivo

## Permisos Requeridos

### Android
- `CAMERA` - Captura de fotos
- `READ_EXTERNAL_STORAGE` - Galería
- `WRITE_EXTERNAL_STORAGE` - Guardar fotos
- `ACCESS_FINE_LOCATION` - GPS preciso
- `ACCESS_COARSE_LOCATION` - GPS aproximado
- `INTERNET` - Conexión a API

### iOS
- `NSCameraUsageDescription` - Uso de cámara
- `NSPhotoLibraryUsageDescription` - Acceso a galería
- `NSLocationWhenInUseUsageDescription` - Ubicación en uso

## Pruebas

### Probar Backend
```bash
# Ejecutar servidor
uvicorn main:app --reload

# Acceder a Swagger UI
# http://localhost:8000/docs

# Probar endpoint de login
curl -X POST "http://localhost:8000/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"agente1","password":"password123"}'
```

### Probar Flutter
```bash
# Ejecutar tests
flutter test

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release
```

## Problemas Comunes y Soluciones

### Backend no se conecta a MySQL
- Verificar que MySQL esté corriendo
- Revisar credenciales en `.env`
- Verificar puerto 3306

### Flutter no conecta con API
- Verificar URL en `api_service.dart`
- Para emulador Android: usar `10.0.2.2`
- Para dispositivo físico: usar IP local de tu PC

### Google Maps no muestra
- Verificar API Key configurada
- Habilitar Maps SDK en Google Cloud Console
- Revisar permisos de ubicación

### Error de permisos GPS/Cámara
- Solicitar permisos en tiempo de ejecución
- Verificar configuración en AndroidManifest.xml / Info.plist

## Arquitectura de Seguridad

```
┌─────────────┐      HTTPS/JWT      ┌─────────────┐      SQL       ┌─────────┐
│   Flutter   │ ◄─────────────────► │   FastAPI   │ ◄────────────► │  MySQL  │
│  App Móvil  │                     │   Backend   │                └─────────┘
└─────────────┘                     └─────────────┘
     │                                     │
     │ Secure Storage                     │ Bcrypt
     │ (Encrypted)                        │ (Hashing)
     ▼                                    ▼
  Dispositivo                          Servidor
```

## Desarrollo Futuro

### Mejoras Sugeridas
- [ ] Notificaciones push
- [ ] Modo offline con sincronización
- [ ] Firma digital del destinatario
- [ ] Escaneo de códigos QR/Barras
- [ ] Reportes y estadísticas
- [ ] Chat en tiempo real
- [ ] Rutas optimizadas
- [ ] Múltiples idiomas

## Licencia

Proyecto desarrollado para fines educativos - Evaluación Unidad 3

## Autor

Desarrollado como parte del caso práctico para Paquexpress S.A. de C.V.

---

**Nota:** Este es un proyecto educativo. Para uso en producción, se recomienda:
- Configurar HTTPS
- Implementar rate limiting
- Agregar logs detallados
- Configurar backups automáticos
- Implementar monitoreo
- Realizar pruebas de penetración

