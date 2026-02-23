#!/bin/bash
# ============================================================
# setup.sh — Se ejecuta automáticamente al crear el Codespace
# Instala todas las dependencias del proyecto
# ============================================================

echo "🚀 Configurando el entorno del Taller de Creación..."

# ── 1. Configurar PostgreSQL local ────────────────────────────────────────────
echo "📦 Configurando PostgreSQL..."
sudo service postgresql start
sudo -u postgres psql -c "CREATE USER codespace WITH PASSWORD 'codespace123';" 2>/dev/null || true
sudo -u postgres psql -c "CREATE DATABASE taller_creacion OWNER codespace;" 2>/dev/null || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE taller_creacion TO codespace;" 2>/dev/null || true

# Ejecutar el schema
sudo -u postgres psql -d taller_creacion -f database/schema.sql 2>/dev/null || true
echo "✅ PostgreSQL listo"

# ── 2. Backend Python ─────────────────────────────────────────────────────────
echo "🐍 Instalando dependencias de Python..."
cd backend
python -m venv venv
source venv/bin/activate
pip install --quiet -r requirements.txt

# Crear .env si no existe
if [ ! -f .env ]; then
  cp .env.example .env
  # Sobreescribir DATABASE_URL con la base de datos local del Codespace
  sed -i 's|DATABASE_URL=.*|DATABASE_URL=postgresql://codespace:codespace123@localhost:5432/taller_creacion|' .env
  echo "✅ Archivo .env creado con base de datos local"
fi

cd ..
echo "✅ Backend listo"

# ── 3. Web App ────────────────────────────────────────────────────────────────
echo "⚛️  Instalando dependencias de la Web App..."
cd web
npm install --silent

# Crear .env si no existe
if [ ! -f .env ]; then
  cp .env.example .env
  # Apuntar al backend del Codespace (el puerto se redirige automáticamente)
  sed -i 's|VITE_API_URL=.*|VITE_API_URL=http://localhost:8000|' .env
fi

cd ..
echo "✅ Web App lista"

# ── 4. App Móvil ──────────────────────────────────────────────────────────────
echo "📱 Instalando dependencias de la App Móvil..."
cd mobile
npm install --silent
cd ..
echo "✅ App Móvil lista"

# ── 5. Mensaje final ──────────────────────────────────────────────────────────
echo ""
echo "============================================="
echo "✅ ¡Entorno configurado correctamente!"
echo "============================================="
echo ""
echo "Para iniciar el proyecto:"
echo ""
echo "  Backend:  cd backend && source venv/bin/activate && uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"
echo "  Web App:  cd web && npm run dev -- --host"
echo ""
echo "  O simplemente escribe: ./start.sh"
echo ""
