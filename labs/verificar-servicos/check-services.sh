#!/bin/bash

# ==============================
# Configurações
# ==============================
SERVICES=("nginx" "ssh")
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/services.log"

mkdir -p "$LOG_DIR"

log() {
  echo "$(date '+%F %T') - $1" | tee -a "$LOG_FILE"
}

# ==============================
# Verificação dos serviços
# ==============================
for SERVICE in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "$SERVICE"; then
    log "OK: Serviço $SERVICE está ativo"
  else
    log "ERRO: Serviço $SERVICE está parado. Tentando reiniciar..."
    systemctl restart "$SERVICE"

    if systemctl is-active --quiet "$SERVICE"; then
      log "RECUPERADO: Serviço $SERVICE reiniciado com sucesso"
    else
      log "FALHA: Não foi possível reiniciar o serviço $SERVICE"
    fi
  fi
done
