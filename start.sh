#!/bin/bash
echo "🚀 Iniciando Taller de Creación..."

# Iniciar PostgreSQL
sudo pg_ctlcluster 15 main start 2>/dev/null || true
sleep 2

# Backend
echo "⚙️  Iniciando Backend FastAPI (puerto 8000)..."
cd backend
source venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
cd ..

sleep 3

# Web App
echo "⚛️  Iniciando Web App React (puerto 5173)..."
cd web
npm run dev -- --host &
WEB_PID=$!
cd ..

echo ""
echo "============================================="
echo "✅ ¡Todo corriendo!"
echo "============================================="
echo "  Backend + Swagger → pestaña PORTS → 8000"
echo "  Web App           → pestaña PORTS → 5173"
echo ""
echo "Ctrl+C para detener todo"

trap "kill $BACKEND_PID $WEB_PID 2>/dev/null; echo 'Detenido.'; exit 0" INT
wait
