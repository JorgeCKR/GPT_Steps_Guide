#!/bin/bash
echo "🚀 Configurando el entorno del Taller de Creación..."

# ── 1. PostgreSQL ─────────────────────────────────────────────
echo "📦 Configurando PostgreSQL..."
sudo pg_ctlcluster 15 main start 2>/dev/null || true
sleep 2

sudo -u postgres psql -c "CREATE USER codespace WITH PASSWORD 'codespace123';" 2>/dev/null || true
sudo -u postgres psql -c "CREATE DATABASE taller_creacion OWNER codespace;" 2>/dev/null || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE taller_creacion TO codespace;" 2>/dev/null || true
sudo -u postgres psql -d taller_creacion -f database/schema.sql 2>/dev/null || true
echo "✅ PostgreSQL listo"

# ── 2. Backend Python ─────────────────────────────────────────
echo "🐍 Instalando dependencias Python..."
cd backend
python3.11 -m venv venv
source venv/bin/activate
pip install --quiet -r requirements.txt

if [ ! -f .env ]; then
  cp .env.example .env
fi
cd ..
echo "✅ Backend listo"

# ── 3. Web App ────────────────────────────────────────────────
echo "⚛️  Instalando dependencias Web..."
cd web && npm install --silent && cd ..
echo "✅ Web App lista"

# ── 4. App Móvil ──────────────────────────────────────────────
echo "📱 Instalando dependencias Mobile..."
cd mobile && npm install --silent && cd ..
echo "✅ App Móvil lista"

chmod +x ../start.sh 2>/dev/null || chmod +x start.sh 2>/dev/null || true

echo ""
echo "============================================="
echo "✅ ¡Entorno listo! Ejecuta: ./start.sh"
echo "============================================="
