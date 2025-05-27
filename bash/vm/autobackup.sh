#!/bin/bash
usuario=${SUDO_USER:-$USER}     # Si hay sudo, usa el usuario original, sino el actual
home_dir=$(eval echo "~$usuario")  # Expande el home del usuario
fecha=$(date +%Y%m%d)
backup_dir="$home_dir/backup"
mkdir -p "$backup_dir"
archivo="backup_home_$fecha.tar.gz"
tar -czf "$backup_dir/$archivo" "$home_dir" 2>/dev/null
echo "Backup creado: $backup_dir/$archivo"
