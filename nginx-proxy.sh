#!/bin/bash

# Configuración
DIR="."
NETWORK="gtv_net"
COMPOSE="docker compose"

# Validar acción
ACTION="$1"
if [[ -z "$ACTION" ]]; then
  echo "❗ Uso: $0 [start|restart|stop|delete]"
  exit 1
fi

# Verificar directorio
cd "$DIR" || { echo "❌ No se encontró el directorio $DIR"; exit 1; }

# Funciones
crear_red() {
  if ! docker network ls | grep -q "$NETWORK"; then
    echo "🌐 Creando red '$NETWORK'..."
    docker network create "$NETWORK"
  fi
}

case "$ACTION" in
  start)
    echo "🚀 Iniciando nginx-proxy..."
    crear_red
    $COMPOSE up -d --build
    echo "✅ Contenedor nginx-proxy iniciado."
    ;;

  restart)
    echo "♻️ Reiniciando nginx-proxy..."
    $COMPOSE down
    crear_red
    $COMPOSE up -d --build
    echo "✅ Contenedor nginx-proxy reiniciado."
    ;;

  stop)
    echo "🛑 Deteniendo nginx-proxy..."
    $COMPOSE stop
    echo "✅ Contenedor nginx-proxy detenido."
    ;;

  delete)
    echo "🧹 Eliminando nginx-proxy y recursos..."
    $COMPOSE down --volumes --remove-orphans
    echo "✅ Contenedor nginx-proxy eliminado completamente."
    ;;

  *)
    echo "❌ Opción no válida: $ACTION"
    echo "Uso: $0 [start|restart|stop|delete]"
    exit 1
    ;;
esac