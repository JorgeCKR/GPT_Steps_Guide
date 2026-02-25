#!/bin/bash
set -e
echo "🚀 Configurando entorno del Taller de Creación..."

# ── 1. Instalar PostgreSQL directamente (sin feature) ─────────────────────────
echo "📦 Instalando PostgreSQL 15..."
sudo apt-get update -qq
sudo apt-get install -y -qq postgresql postgresql-contrib

# Iniciar servicio
sudo service postgresql start
sleep 3

# Crear usuario y base de datos
sudo -u postgres psql -c "CREATE USER codespace WITH PASSWORD 'codespace123';" 2>/dev/null || true
sudo -u postgres psql -c "CREATE DATABASE taller_creacion OWNER codespace;" 2>/dev/null || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE taller_creacion TO codespace;" 2>/dev/null || true

# Ejecutar schema
sudo -u postgres psql -d taller_creacion -f /workspaces/GPT_Steps_Guide/database/schema.sql 2>/dev/null || true
echo "✅ PostgreSQL listo"

# ── 2. Backend Python ──────────────────────────────────────────────────────────
echo "🐍 Instalando dependencias Python..."
cd /workspaces/GPT_Steps_Guide/backend
python3 -m venv venv
source venv/bin/activate
pip install --quiet -r requirements.txt

# Crear .env si no existe
if [ ! -f .env ]; then
  cp .env.example .env
fi
echo "✅ Backend listo"

# ── 3. Web App ─────────────────────────────────────────────────────────────────
echo "⚛️  Instalando dependencias Web..."
cd /workspaces/GPT_Steps_Guide/web
npm install --silent
if [ ! -f .env ]; then
  cp .env.example .env
fi
echo "✅ Web App lista"

# ── 4. App Móvil ───────────────────────────────────────────────────────────────
echo "📱 Instalando dependencias Mobile..."
cd /workspaces/GPT_Steps_Guide/mobile
npm install --silent
echo "✅ App Móvil lista"

# ── 5. Permisos ────────────────────────────────────────────────────────────────
chmod +x /workspaces/GPT_Steps_Guide/start.sh

echo ""
echo "============================================="
echo "✅ ¡Entorno listo! Ejecuta: ./start.sh"
echo "============================================="
