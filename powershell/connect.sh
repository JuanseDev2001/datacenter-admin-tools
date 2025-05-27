#!/bin/bash

PEM_FILE="./linuxvm.pem"
USER_HOST="ubuntu@35.209.129.177"
SSH_CMD="ssh -t -i $PEM_FILE -o StrictHostKeyChecking=no -o ConnectTimeout=10 $USER_HOST"
CURL_URL="https://back.ticktopia.shop/api/gcp"
TARGET_MSG="ha sido encendida correctamente"

# Paso 1: Verifica estado actual con curl
echo "Consultando estado de la VM..."
RESPONSE=$(curl -s -X GET $CURL_URL)
echo "Respuesta del servidor: $RESPONSE"

# Paso 2: Intenta conectar por SSH
$SSH_CMD 'cd proyecto-final-jks && sudo ./manage.sh'
SSH_EXIT_CODE=$?

# Paso 3: Si SSH falla, inicia polling con curl hasta encontrar el mensaje deseado
if [ $SSH_EXIT_CODE -ne 0 ]; then
  echo "SSH falló. Iniciando verificación periódica..."

  while true; do
    RESPONSE=$(curl -s -X GET $CURL_URL)

    if echo "$RESPONSE" | grep -q "$TARGET_MSG"; then
      echo "La VM ha sido encendida correctamente. Intentando SSH nuevamente..."
      sleep 30
      break
    fi

    echo "VM en desaprovisionamiento, esperando que finalice..."
    sleep 60
  done

  # Vuelve a intentar SSH cuando la VM esté lista
  $SSH_CMD 'cd proyecto-final-jks && sudo ./manage.sh'
else
  echo "SSH exitoso. No se requiere acción adicional."
fi

