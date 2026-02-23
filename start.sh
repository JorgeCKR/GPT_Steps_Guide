#!/bin/bash
# ============================================================
# start.sh — Inicia backend y web app con un solo comando
# Úsalo desde la terminal del Codespace
# ============================================================

echo "🚀 Iniciando Taller de Creación..."

# Asegurarse que PostgreSQL está corriendo
sudo service postgresql start 2>/dev/null

# ── Backend en background ─────────────────────────────────────────────────────
echo "⚙️  Iniciando Backend FastAPI en puerto 8000..."
cd backend
source venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
cd ..

# Esperar a que el backend esté listo
echo "⏳ Esperando al backend..."
sleep 4

# ── Web App ───────────────────────────────────────────────────────────────────
echo "⚛️  Iniciando Web App React en puerto 5173..."
cd web
npm run dev -- --host &
WEB_PID=$!
cd ..

echo ""
echo "============================================="
echo "✅ ¡Todo corriendo!"
echo "============================================="
echo ""
echo "  Backend API:  puerto 8000"
echo "  Swagger docs: puerto 8000 → /docs"
echo "  Web App:      puerto 5173"
echo ""
echo "Codespaces redirige estos puertos automáticamente."
echo "Búscalos en la pestaña PORTS de la terminal."
echo ""
echo "Para detener todo: Ctrl+C"
echo ""

# Mantener el script activo hasta Ctrl+C
trap "kill $BACKEND_PID $WEB_PID 2>/dev/null; echo 'Servidores detenidos.'; exit 0" INT
wait
