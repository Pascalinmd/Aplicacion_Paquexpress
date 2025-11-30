# ✅ CHECKLIST DE INICIO - Paquexpress

Sigue estos pasos en orden para poner en marcha el proyecto por primera vez.

---

## 📋 Pre-requisitos (Instalar si no los tienes)

- [ ] Flutter SDK 3.9+ instalado → https://docs.flutter.dev/get-started/install
- [ ] Python 3.9+ instalado → https://www.python.org/downloads/
- [ ] MySQL Server 8.0+ instalado → https://dev.mysql.com/downloads/mysql/
- [ ] Visual Studio Code (recomendado) → https://code.visualstudio.com/
- [ ] Git (opcional, para versionamiento) → https://git-scm.com/

### Verificar instalaciones:

```bash
flutter --version
python --version
mysql --version
```

---

## 🗄️ PASO 1: Configurar Base de Datos

### 1.1 Iniciar MySQL

**Windows:**
```powershell
# Verificar si está corriendo
Get-Service MySQL*

# Si no está corriendo, iniciar:
Start-Service MySQL80
```

**Linux/Mac:**
```bash
sudo systemctl start mysql
# o
brew services start mysql
```

### 1.2 Configurar credenciales del backend

```bash
cd backend

# Copiar archivo de ejemplo
copy .env.example .env  # Windows
# cp .env.example .env  # Linux/Mac

# Editar .env con tus credenciales de MySQL
```

Contenido de `.env`:
```
MYSQL_USER=root
MYSQL_PASSWORD=tu_contraseña_mysql
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=paquexpress_db
SECRET_KEY=una_clave_secreta_muy_segura
```

### 1.3 Crear entorno virtual de Python

```bash
# Crear entorno virtual
python -m venv venv

# Activar
.\venv\Scripts\Activate.ps1  # Windows PowerShell
# venv\Scripts\activate.bat  # Windows CMD
# source venv/bin/activate    # Linux/Mac
```

### 1.4 Instalar dependencias de Python

```bash
pip install -r requirements.txt
```

### 1.5 Inicializar base de datos

```bash
python database/init_db.py
```

**Resultado esperado:**
```
✓ Conectado a MySQL
✓ Base de datos inicializada correctamente
✓ Tablas creadas
✓ Datos de prueba insertados

Usuarios de prueba:
  - Usuario: agente1 / Contraseña: password123
  - Usuario: agente2 / Contraseña: password123
  - Usuario: agente3 / Contraseña: password123
```

---

## 🚀 PASO 2: Iniciar Backend

```bash
# Asegúrate de estar en backend/ con venv activado
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Verificar que funciona:**

1. Abrir navegador → http://localhost:8000
2. Debería mostrar: `{"message": "Bienvenido a Paquexpress API", ...}`
3. Abrir documentación → http://localhost:8000/docs
4. Ver la interfaz Swagger UI

### Probar endpoint de login:

En Swagger UI (http://localhost:8000/docs):
1. Expandir `POST /api/auth/login`
2. Clic en "Try it out"
3. Ingresar:
   ```json
   {
     "username": "agente1",
     "password": "password123"
   }
   ```
4. Clic en "Execute"
5. Deberías recibir un `access_token`

**✅ Si ves el token, el backend funciona correctamente**

---

## 📱 PASO 3: Configurar Flutter

### 3.1 Volver a la raíz del proyecto

```bash
cd ..  # Salir de backend/
```

### 3.2 Instalar dependencias de Flutter

```bash
flutter pub get
```

### 3.3 Generar archivos de código

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Esto creará:
- `lib/models/usuario.g.dart`
- `lib/models/paquete.g.dart`
- `lib/models/entrega.g.dart`

### 3.4 Configurar URL del backend

Editar `lib/services/api_service.dart` línea 9:

**Para emulador Android:**
```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

**Para dispositivo físico Android/iOS:**
```dart
// Cambiar 192.168.1.X por tu IP local
static const String baseUrl = 'http://192.168.1.X:8000';
```

Para obtener tu IP:
```bash
# Windows PowerShell
ipconfig
# Buscar "IPv4 Address"

# Linux/Mac
ifconfig
# o
ip addr show
```

### 3.5 (Opcional) Configurar Google Maps

**Si quieres usar la función de mapas:**

1. Obtener API Key → Ver [GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md)
2. Editar `android/app/src/main/AndroidManifest.xml` línea 13:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="TU_API_KEY_AQUI"/>
   ```

**Nota:** La app funciona sin Google Maps, solo no se verá el mapa.

---

## 🏃 PASO 4: Ejecutar la Aplicación

### 4.1 Conectar dispositivo o iniciar emulador

**Opción A: Emulador Android (Android Studio)**
- Abrir Android Studio → AVD Manager → Iniciar emulador

**Opción B: Dispositivo físico**
- Habilitar "Opciones de desarrollador" en el dispositivo
- Habilitar "Depuración USB"
- Conectar por USB

### 4.2 Verificar dispositivos disponibles

```bash
flutter devices
```

Deberías ver al menos un dispositivo listado.

### 4.3 Ejecutar la aplicación

```bash
flutter run
```

Si hay múltiples dispositivos:
```bash
flutter run -d <device_id>
```

---

## 🧪 PASO 5: Probar la Aplicación

### 5.1 Login

1. La app debería abrir con un splash screen
2. Luego mostrar la pantalla de login
3. Ingresar:
   - **Usuario:** `agente1`
   - **Password:** `password123`
4. Clic en "Iniciar Sesión"

### 5.2 Ver paquetes

Deberías ver una lista con 4 paquetes asignados al agente1:
- PKG001 - Ana López
- PKG002 - Roberto Martínez
- PKG003 - Laura Fernández
- PKG004 - Pedro Sánchez

### 5.3 Realizar una entrega

1. Clic en cualquier paquete (ej: PKG002)
2. Esperar a que se obtenga la ubicación GPS
3. Clic en "Capturar Foto"
4. Tomar una foto o seleccionar de galería
5. (Opcional) Clic en "Ver en Mapa" si configuraste Google Maps
6. (Opcional) Agregar observaciones
7. Clic en "PAQUETE ENTREGADO"
8. Confirmar en el diálogo
9. El paquete desaparecerá de la lista

### 5.4 Verificar en base de datos

```sql
-- Conectar a MySQL
mysql -u root -p

USE paquexpress_db;

-- Ver entregas registradas
SELECT 
    e.id,
    p.numero_rastreo,
    u.nombre as agente,
    e.fecha_entrega,
    e.latitud_entrega,
    e.longitud_entrega,
    e.foto_evidencia
FROM entregas e
JOIN paquetes p ON e.paquete_id = p.id
JOIN usuarios u ON e.agente_id = u.id;
```

---

## ✅ Verificación Final

### Backend ✓
- [ ] MySQL corriendo
- [ ] Backend ejecutándose en http://localhost:8000
- [ ] Swagger UI accesible en http://localhost:8000/docs
- [ ] Login funciona en Swagger UI

### Flutter ✓
- [ ] Dependencias instaladas (`flutter pub get`)
- [ ] Archivos .g.dart generados
- [ ] URL del backend correcta en `api_service.dart`
- [ ] Dispositivo/emulador conectado
- [ ] App ejecutándose sin errores

### Funcionalidad ✓
- [ ] Login exitoso con agente1
- [ ] Lista de paquetes se carga
- [ ] GPS obtiene ubicación
- [ ] Cámara funciona
- [ ] Entrega se registra correctamente
- [ ] Paquete desaparece de la lista después de entrega

---

## 🆘 Problemas Comunes

### "Unable to connect to MySQL"
```bash
# Verificar que MySQL está corriendo
Get-Service MySQL*

# Verificar credenciales en backend/.env
```

### "Error al conectar con API" en Flutter
```bash
# Verificar que backend está corriendo
# Verificar URL en lib/services/api_service.dart
# Para emulador: usar 10.0.2.2 en lugar de localhost
```

### "Location permission denied"
- Otorgar permisos cuando la app lo solicite
- O configurar manualmente en ajustes del dispositivo

### "Camera not working"
- Otorgar permisos de cámara
- En emulador: usar cámara virtual o foto de galería

### Google Maps no se muestra
- Ver [GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md)
- La app funciona sin mapas, es opcional

---

## 📚 Documentación Adicional

- [README.md](README.md) - Documentación completa del proyecto
- [INSTALLATION.md](INSTALLATION.md) - Guía detallada de instalación
- [GOOGLE_MAPS_SETUP.md](GOOGLE_MAPS_SETUP.md) - Configuración de Google Maps
- [COMANDOS_UTILES.md](COMANDOS_UTILES.md) - Comandos útiles de desarrollo
- [PROYECTO_COMPLETADO.md](PROYECTO_COMPLETADO.md) - Resumen del proyecto
- [backend/README.md](backend/README.md) - Documentación del backend

---

## 🎉 ¡Listo!

Si llegaste hasta aquí y todo funciona:

**¡Felicidades! 🎊**

Tu aplicación de Paquexpress está completamente funcional.

Puedes:
1. Probar con diferentes usuarios (agente1, agente2, agente3)
2. Registrar múltiples entregas
3. Ver los datos en MySQL
4. Explorar la API en Swagger UI
5. Modificar el código para agregar nuevas funcionalidades

---

**¿Necesitas ayuda?**

Revisa los archivos de documentación o los logs:
- Backend: terminal donde corre uvicorn
- Flutter: `flutter logs`
- MySQL: logs de MySQL
