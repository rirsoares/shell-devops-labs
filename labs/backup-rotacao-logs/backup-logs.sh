#!/bin/bash

# ==============================
# Configurações
# ==============================
SOURCE_DIR="./logs"
BACKUP_DIR="./backups"
RETENTION_DAYS=7
mkdir -p "$BACKUP_DIR"

DATE=$(date '+%F_%H-%M-%S')
BACKUP_FILE="$BACKUP_DIR/logs_backup_$DATE.tar.gz"

# ==============================
# Backup
# ==============================
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
  echo "$(date '+%F %T') - Backup criado: $BACKUP_FILE"
else
  echo "$(date '+%F %T') - ERRO ao criar backup"
  exit 1
fi

# ==============================
# Rotação (cleanup)
# ==============================
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;

echo "$(date '+%F %T') - Backups com mais de $RETENTION_DAYS dias removidos"
