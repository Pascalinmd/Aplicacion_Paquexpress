# ===================================================================
# Script de Verificación y Preparación - Paquexpress
# ===================================================================
# Este script verifica que todo esté configurado correctamente
# y genera los archivos necesarios para ejecutar la aplicación

Write-Host "`n🚀 PAQUEXPRESS - Verificación del Proyecto`n" -ForegroundColor Cyan

# Variables de control
$errores = 0
$advertencias = 0

# ===================================================================
# 1. Verificar Flutter
# ===================================================================
Write-Host "📱 [1/6] Verificando Flutter..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
    if ($flutterVersion) {
        Write-Host "   ✅ Flutter instalado: $flutterVersion" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Flutter no encontrado" -ForegroundColor Red
        $errores++
    }
} catch {
    Write-Host "   ❌ Error al verificar Flutter" -ForegroundColor Red
    $errores++
}

# ===================================================================
# 2. Verificar dependencias de Flutter
# ===================================================================
Write-Host "`n📦 [2/6] Verificando dependencias de Flutter..." -ForegroundColor Yellow
if (Test-Path "pubspec.yaml") {
    Write-Host "   ✅ pubspec.yaml encontrado" -ForegroundColor Green
    
    Write-Host "   ⏳ Instalando dependencias..." -ForegroundColor Cyan
    flutter pub get
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Dependencias instaladas correctamente" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Error al instalar dependencias" -ForegroundColor Red
        $errores++
    }
} else {
    Write-Host "   ❌ pubspec.yaml no encontrado" -ForegroundColor Red
    $errores++
}

# ===================================================================
# 3. Verificar archivos de modelos
# ===================================================================
Write-Host "`n🗂️  [3/6] Verificando modelos..." -ForegroundColor Yellow
$modelos = @("lib/models/usuario.dart", "lib/models/paquete.dart", "lib/models/entrega.dart")
$modelosOk = $true

foreach ($modelo in $modelos) {
    if (Test-Path $modelo) {
        Write-Host "   ✅ $modelo" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $modelo no encontrado" -ForegroundColor Red
        $modelosOk = $false
        $errores++
    }
}

# ===================================================================
# 4. Generar archivos .g.dart
# ===================================================================
Write-Host "`n⚙️  [4/6] Generando archivos de serialización..." -ForegroundColor Yellow

# Verificar si ya existen
$archivosG = @("lib/models/usuario.g.dart", "lib/models/paquete.g.dart", "lib/models/entrega.g.dart")
$todosExisten = $true

foreach ($archivo in $archivosG) {
    if (-not (Test-Path $archivo)) {
        $todosExisten = $false
        break
    }
}

if ($todosExisten) {
    Write-Host "   ⚠️  Archivos .g.dart ya existen" -ForegroundColor Yellow
    $respuesta = Read-Host "   ¿Desea regenerarlos? (s/n)"
    
    if ($respuesta -eq 's' -or $respuesta -eq 'S') {
        Write-Host "   ⏳ Regenerando archivos..." -ForegroundColor Cyan
        flutter pub run build_runner build --delete-conflicting-outputs
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Archivos regenerados correctamente" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Error al regenerar archivos" -ForegroundColor Red
            $errores++
        }
    } else {
        Write-Host "   ⏭️  Omitiendo regeneración" -ForegroundColor Cyan
    }
} else {
    Write-Host "   ⏳ Generando archivos por primera vez..." -ForegroundColor Cyan
    flutter pub run build_runner build --delete-conflicting-outputs
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Archivos generados correctamente" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Error al generar archivos" -ForegroundColor Red
        $errores++
    }
}

# Verificar que se generaron
Write-Host "`n   Verificando archivos generados:" -ForegroundColor Cyan
foreach ($archivo in $archivosG) {
    if (Test-Path $archivo) {
        Write-Host "   ✅ $archivo" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $archivo no generado" -ForegroundColor Red
        $errores++
    }
}

# ===================================================================
# 5. Verificar configuración de backend
# ===================================================================
Write-Host "`n🔧 [5/6] Verificando backend..." -ForegroundColor Yellow

if (Test-Path "backend") {
    Write-Host "   ✅ Directorio backend encontrado" -ForegroundColor Green
    
    # Verificar archivos importantes
    $archivosBackend = @(
        "backend/main.py",
        "backend/requirements.txt",
        "backend/database/schema.sql",
        "backend/database/init_db.py",
        "backend/.env.example"
    )
    
    foreach ($archivo in $archivosBackend) {
        if (Test-Path $archivo) {
            Write-Host "   ✅ $archivo" -ForegroundColor Green
        } else {
            Write-Host "   ❌ $archivo no encontrado" -ForegroundColor Red
            $errores++
        }
    }
    
    # Verificar si existe .env
    if (Test-Path "backend/.env") {
        Write-Host "   ✅ backend/.env configurado" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  backend/.env no encontrado" -ForegroundColor Yellow
        Write-Host "      Copia backend/.env.example a backend/.env y configúralo" -ForegroundColor Yellow
        $advertencias++
    }
    
} else {
    Write-Host "   ❌ Directorio backend no encontrado" -ForegroundColor Red
    $errores++
}

# ===================================================================
# 6. Verificar documentación
# ===================================================================
Write-Host "`n📚 [6/6] Verificando documentación..." -ForegroundColor Yellow

$documentos = @(
    "README.md",
    "INICIO_RAPIDO.md",
    "GENERAR_MODELOS.md",
    "backend/DATOS_ABUNDANTES.md"
)

foreach ($doc in $documentos) {
    if (Test-Path $doc) {
        Write-Host "   ✅ $doc" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  $doc no encontrado" -ForegroundColor Yellow
        $advertencias++
    }
}

# ===================================================================
# Resumen
# ===================================================================
Write-Host "`n" + "="*70 -ForegroundColor Cyan
Write-Host "📊 RESUMEN DE VERIFICACIÓN" -ForegroundColor Cyan
Write-Host "="*70 -ForegroundColor Cyan

if ($errores -eq 0 -and $advertencias -eq 0) {
    Write-Host "✅ TODO CORRECTO - El proyecto está listo para ejecutar" -ForegroundColor Green
    Write-Host "`nPróximos pasos:" -ForegroundColor Cyan
    Write-Host "1. Inicializar backend:" -ForegroundColor White
    Write-Host "   cd backend" -ForegroundColor Gray
    Write-Host "   python database/init_db.py" -ForegroundColor Gray
    Write-Host "   uvicorn main:app --reload" -ForegroundColor Gray
    Write-Host "`n2. Ejecutar Flutter:" -ForegroundColor White
    Write-Host "   flutter run" -ForegroundColor Gray
} elseif ($errores -eq 0) {
    Write-Host "⚠️  VERIFICACIÓN COMPLETADA CON ADVERTENCIAS" -ForegroundColor Yellow
    Write-Host "   Errores: $errores" -ForegroundColor White
    Write-Host "   Advertencias: $advertencias" -ForegroundColor Yellow
    Write-Host "`nEl proyecto puede funcionar pero revisa las advertencias." -ForegroundColor Yellow
} else {
    Write-Host "❌ VERIFICACIÓN FALLIDA" -ForegroundColor Red
    Write-Host "   Errores: $errores" -ForegroundColor Red
    Write-Host "   Advertencias: $advertencias" -ForegroundColor Yellow
    Write-Host "`nCorrige los errores antes de continuar." -ForegroundColor Red
}

Write-Host "`n📖 Para más información, consulta:" -ForegroundColor Cyan
Write-Host "   - INICIO_RAPIDO.md (guía de inicio)" -ForegroundColor White
Write-Host "   - GENERAR_MODELOS.md (problema con modelos)" -ForegroundColor White
Write-Host "   - backend/DATOS_ABUNDANTES.md (info de base de datos)" -ForegroundColor White

Write-Host "`n"
