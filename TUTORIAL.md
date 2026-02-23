# 🚀 Tutorial: Usar el Proyecto en GitHub Codespaces

> Todo funciona desde el navegador. Sin instalar nada en tu computadora.
> Solo necesitas una cuenta de GitHub.

---

## ¿Qué es GitHub Codespaces?

Es VS Code corriendo en la nube, dentro de tu repositorio de GitHub.
Tiene todo preinstalado: Python, Node.js, PostgreSQL, extensiones.
Abres el navegador → abres tu Codespace → todo funciona.

**Plan gratuito de GitHub incluye 120 horas de Codespace por mes.**

---

## PASO 1 — Crear el repositorio en GitHub

1. Ve a https://github.com e inicia sesión.
2. Clic en "+" → "New repository"
3. Configura: nombre `taller-de-creacion`, Private, sin README
4. Clic en "Create repository"

---

## PASO 2 — Subir los archivos

En la página del repositorio vacío → "uploading an existing file"
→ arrastra toda la carpeta del proyecto → Commit changes.

---

## PASO 3 — Configurar Secrets

Settings → Secrets and variables → Codespaces → "New repository secret"

| Secret | Valor mínimo para probar |
|---|---|
| `SECRET_KEY` | cualquier texto largo de 32+ caracteres |
| `GOOGLE_CLIENT_ID` | lo obtienes de Google Cloud Console |
| `STRIPE_SECRET_KEY` | sk_test_xxx de Stripe (modo test) |
| `HOTMART_WEBHOOK_SECRET` | tu Hottok de Hotmart |

Solo `SECRET_KEY` es obligatorio para empezar.

---

## PASO 4 — Abrir el Codespace

Botón verde "< > Code" → pestaña "Codespaces" → "Create codespace on main"

Espera 2-3 minutos. El entorno se configura automáticamente.

---

## PASO 5 — Iniciar el proyecto

En la terminal del Codespace:

```bash
chmod +x start.sh
./start.sh
```

Esto inicia el backend (puerto 8000) y la web app (puerto 5173).
Codespaces muestra una notificación — clic en "Open in Browser".

---

## PASO 6 — Probar el Backend (sin Postman)

Abre el archivo `api-tests.http` en VS Code.
Verás "Send Request" encima de cada endpoint — haz clic.

Flujo básico:
1. Health Check → confirma que el backend corre
2. REGISTRO → crea un usuario, copia el access_token
3. Pega el token en `@token = ` al inicio del archivo
4. MODULOS → verifica que devuelve los 8 módulos

O abre el puerto 8000 + /docs para ver Swagger.

---

## PASO 7 — Ver la Web App

Pestaña PORTS en la terminal → clic en el ícono junto al puerto 5173.

---

## PASO 8 — Detener y retomar

Cierra la pestaña. El Codespace se suspende solo.
Para retomar: https://github.com/codespaces → clic en tu Codespace.
Para reiniciar servidores: `./start.sh`

---

## Problemas comunes

**Permission denied:** `chmod +x start.sh`

**Puerto ocupado:** `pkill -f uvicorn && ./start.sh`

**Base de datos no existe:** `bash .devcontainer/setup.sh`

**Puerto 5173 no aparece:** `cd web && npm run dev -- --host`

---

*Taller de Creación — georgeparatodos.com*
