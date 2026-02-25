#!/bin/bash
set -e
echo "🚀 Configurando Taller de Creación..."

# ── 1. Instalar Python, Node, PostgreSQL ──────────────────────────────────────
echo "📦 Instalando herramientas base..."
sudo apt-get update -qq
sudo apt-get install -y -qq \
    python3.11 python3.11-venv python3-pip \
    postgresql postgresql-contrib \
    curl

# Instalar Node 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - 2>/dev/null
sudo apt-get install -y -qq nodejs

echo "✅ Python: $(python3.11 --version)"
echo "✅ Node:   $(node --version)"
echo "✅ npm:    $(npm --version)"

# ── 2. PostgreSQL ─────────────────────────────────────────────────────────────
echo "🗄️  Configurando PostgreSQL..."
sudo service postgresql start
sleep 3

sudo -u postgres psql -c "CREATE USER codespace WITH PASSWORD 'codespace123';" 2>/dev/null || true
sudo -u postgres psql -c "CREATE DATABASE taller_creacion OWNER codespace;" 2>/dev/null || true
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE taller_creacion TO codespace;" 2>/dev/null || true
sudo -u postgres psql -d taller_creacion -f /workspaces/GPT_Steps_Guide/database/schema.sql
echo "✅ PostgreSQL listo"

# ── 3. Backend Python ─────────────────────────────────────────────────────────
echo "🐍 Instalando backend Python..."
cd /workspaces/GPT_Steps_Guide/backend
python3.11 -m venv venv
source venv/bin/activate
pip install --quiet -r requirements.txt
if [ ! -f .env ]; then cp .env.example .env; fi
echo "✅ Backend listo"

# ── 4. Web App ────────────────────────────────────────────────────────────────
echo "⚛️  Instalando Web App..."
cd /workspaces/GPT_Steps_Guide/web
npm install --silent
if [ ! -f .env ]; then cp .env.example .env; fi
echo "✅ Web App lista"

# ── 5. App Móvil ──────────────────────────────────────────────────────────────
echo "📱 Instalando App Móvil..."
cd /workspaces/GPT_Steps_Guide/mobile
npm install --silent
echo "✅ App Móvil lista"

chmod +x /workspaces/GPT_Steps_Guide/start.sh

echo ""
echo "========================================="
echo "✅ ¡Todo listo! Ejecuta: ./start.sh"
echo "========================================="
