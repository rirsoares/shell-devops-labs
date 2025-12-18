#!/usr/bin/env bash
set -euo pipefail

# ==========================
# Configurações
# ==========================
LIMITE_USO=80          # percentual
PARTICAO="/"           # partição monitorada

# ==========================
# Funções
# ==========================

erro() {
  echo "ERRO: $*" >&2
  exit 1
}

checar_dependencias() {
  for cmd in df awk sed; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      erro "Comando obrigatório '$cmd' não encontrado."
    fi
  done
}

obter_uso_disco() {
  df -h "$PARTICAO" | awk 'NR==2 {print $5}' | sed 's/%//'
}

# ==========================
# Execução
# ==========================

checar_dependencias

USO_ATUAL="$(obter_uso_disco)"

echo "Uso atual da partição $PARTICAO: ${USO_ATUAL}%"

if [ "$USO_ATUAL" -ge "$LIMITE_USO" ]; then
  echo "ALERTA: Uso de disco acima do limite (${LIMITE_USO}%)"
  exit 1
else
  echo "OK: Uso de disco dentro do limite"
  exit 0
fi
