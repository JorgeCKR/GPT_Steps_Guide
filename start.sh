#!/bin/bash
echo "🚀 Iniciando Taller de Creación..."

# Iniciar PostgreSQL
sudo service postgresql start
sleep 2

# Backend
echo "⚙️  Iniciando Backend FastAPI (puerto 8000)..."
cd /workspaces/GPT_Steps_Guide/backend
source venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
cd ..

sleep 3

# Web App
echo "⚛️  Iniciando Web App React (puerto 5173)..."
cd /workspaces/GPT_Steps_Guide/web
npm run dev -- --host &
WEB_PID=$!
cd ..

echo ""
echo "============================================="
echo "✅ ¡Todo corriendo!"
echo "  Backend → pestaña PORTS → puerto 8000"
echo "  Swagger → puerto 8000 → /docs"
echo "  Web App → pestaña PORTS → puerto 5173"
echo "============================================="
echo "Ctrl+C para detener"

trap "kill $BACKEND_PID $WEB_PID 2>/dev/null; echo 'Detenido.'; exit 0" INT
wait
