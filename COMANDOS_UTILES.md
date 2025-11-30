# Comandos Útiles - Paquexpress

## Backend (FastAPI)

### Configuración inicial
```bash
cd backend

# Crear entorno virtual
python -m venv venv

# Activar entorno virtual
# Windows PowerShell:
.\venv\Scripts\Activate.ps1
# Windows CMD:
venv\Scripts\activate.bat

# Instalar dependencias
pip install -r requirements.txt

# Inicializar base de datos
python database/init_db.py
```

### Ejecución
```bash
# Modo desarrollo (auto-reload)
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Modo producción
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4

# Con logs detallados
uvicorn main:app --reload --log-level debug
```

### Base de datos

```bash
# Conectar a MySQL
mysql -u root -p

# Usar base de datos
USE paquexpress_db;

# Ver usuarios
SELECT id, username, nombre, apellido, email FROM usuarios;

# Ver paquetes de un agente
SELECT * FROM paquetes WHERE agente_id = 1;

# Ver entregas realizadas
SELECT e.*, p.numero_rastreo, u.nombre
FROM entregas e
JOIN paquetes p ON e.paquete_id = p.id
JOIN usuarios u ON e.agente_id = u.id;

# Resetear un paquete a pendiente (para pruebas)
UPDATE paquetes SET estado = 'pendiente', fecha_entrega = NULL WHERE id = 1;
DELETE FROM entregas WHERE paquete_id = 1;

# Crear nuevo usuario
INSERT INTO usuarios (username, password_hash, nombre, apellido, email)
VALUES ('nuevo_agente', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5LS3JqK3ybYQ2', 
        'Nuevo', 'Agente', 'nuevo@paquexpress.com');

# Asignar paquete a agente
UPDATE paquetes SET agente_id = 1, fecha_asignacion = NOW() WHERE id = 7;

# Ver estadísticas
SELECT 
    u.nombre, 
    COUNT(e.id) as entregas_completadas
FROM usuarios u
LEFT JOIN entregas e ON u.id = e.agente_id
GROUP BY u.id;
```

### Pruebas con curl

```bash
# Login
curl -X POST "http://localhost:8000/api/auth/login" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"agente1\",\"password\":\"password123\"}"

# Guardar token en variable (PowerShell)
$token = (Invoke-RestMethod -Method Post -Uri "http://localhost:8000/api/auth/login" ^
  -ContentType "application/json" ^
  -Body '{"username":"agente1","password":"password123"}').access_token

# Obtener paquetes (con token)
curl -X GET "http://localhost:8000/api/paquetes/agente/1" ^
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

## Flutter

### Configuración inicial
```bash
# Instalar dependencias
flutter pub get

# Generar código
flutter pub run build_runner build --delete-conflicting-outputs

# Ver dispositivos disponibles
flutter devices
```

### Ejecución
```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# Ejecutar en modo release
flutter run --release

# Con hot reload automático
flutter run --hot
```

### Debugging
```bash
# Ver logs en tiempo real
flutter logs

# Limpiar caché y rebuild
flutter clean
flutter pub get
flutter run

# Analizar rendimiento
flutter run --profile

# Ver información del dispositivo
flutter doctor -v
```

### Build
```bash
# Android APK (debug)
flutter build apk --debug

# Android APK (release)
flutter build apk --release

# Android App Bundle (para Play Store)
flutter build appbundle --release

# iOS (requiere Mac)
flutter build ios --release
```

### Generación de código
```bash
# Generar archivos .g.dart
flutter pub run build_runner build

# Regenerar forzado
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-genera al guardar)
flutter pub run build_runner watch
```

## Git

### Configuración inicial
```bash
# Inicializar repositorio
git init

# Agregar todos los archivos
git add .

# Primer commit
git commit -m "Initial commit: Paquexpress app completa"

# Conectar con repositorio remoto
git remote add origin <URL_DEL_REPO>
git push -u origin main
```

### Workflow diario
```bash
# Ver estado
git status

# Agregar cambios
git add .

# Commit
git commit -m "Descripción del cambio"

# Push
git push

# Pull (actualizar)
git pull

# Ver historial
git log --oneline

# Crear rama
git checkout -b feature/nueva-funcionalidad

# Cambiar de rama
git checkout main

# Merge
git merge feature/nueva-funcionalidad
```

## Testing

### Backend
```bash
cd backend

# Instalar pytest
pip install pytest pytest-asyncio httpx

# Ejecutar tests
pytest

# Con coverage
pytest --cov=. --cov-report=html
```

### Flutter
```bash
# Ejecutar todos los tests
flutter test

# Test específico
flutter test test/widget_test.dart

# Con coverage
flutter test --coverage

# Ver coverage
# Windows (requiere instalar lcov)
genhtml coverage/lcov.info -o coverage/html
```

## Docker (Opcional)

### Backend
```dockerfile
# Crear Dockerfile en backend/
FROM python:3.9
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

```bash
# Build
docker build -t paquexpress-backend .

# Run
docker run -p 8000:8000 paquexpress-backend

# Con docker-compose
docker-compose up -d
```

## Obtener información del sistema

### IP local (para dispositivos físicos)
```bash
# Windows PowerShell
ipconfig
# Buscar "IPv4 Address" en tu adaptador de red

# Linux/Mac
ifconfig
# o
ip addr show
```

### Verificar puertos
```bash
# Windows
netstat -ano | findstr :8000

# Linux/Mac
lsof -i :8000

# Ver si MySQL está corriendo
# Windows
Get-Service MySQL*

# Linux
systemctl status mysql
```

## Generar hash de contraseña

```python
# En Python (con passlib instalado)
from passlib.context import CryptContext
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
print(pwd_context.hash("tu_contraseña"))
```

## Backup de base de datos

```bash
# Exportar base de datos
mysqldump -u root -p paquexpress_db > backup.sql

# Importar backup
mysql -u root -p paquexpress_db < backup.sql

# Backup con fecha
mysqldump -u root -p paquexpress_db > backup_$(date +%Y%m%d).sql
```

## Verificar instalaciones

```bash
# Flutter
flutter --version
dart --version

# Python
python --version
pip --version

# MySQL
mysql --version

# Git
git --version

# Node (si lo usas)
node --version
npm --version
```

## Solución rápida de problemas

```bash
# Flutter: "Gradle build failed"
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run

# Backend: "Port already in use"
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:8000 | xargs kill -9

# MySQL: "Connection refused"
# Windows
net start MySQL80

# Linux
sudo systemctl start mysql

# Flutter: "Plugin not found"
flutter pub cache repair
flutter clean
flutter pub get

# Backend: "Module not found"
pip install -r requirements.txt --force-reinstall
```

## Comandos de mantenimiento

```bash
# Flutter: Actualizar dependencias
flutter pub upgrade

# Flutter: Auditar dependencias
flutter pub outdated

# Python: Listar paquetes instalados
pip list

# Python: Actualizar paquete
pip install --upgrade <paquete>

# Python: Generar requirements.txt
pip freeze > requirements.txt

# Limpiar archivos temporales
flutter clean
rm -rf backend/__pycache__
rm -rf backend/venv
```

## Variables de entorno útiles

```bash
# Flutter: Deshabilitar analytics
flutter config --no-analytics

# Flutter: Habilitar web
flutter config --enable-web

# Ver configuración de Flutter
flutter config
```

## Monitoreo

```bash
# Ver logs del backend en tiempo real
# Linux/Mac
tail -f logs/app.log

# Ver uso de recursos
# Windows
Get-Process -Name python | Select-Object CPU, WS

# Linux
top -p $(pgrep -f uvicorn)
```
