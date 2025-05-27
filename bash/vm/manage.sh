#!/bin/bash
# Script de administración básica para sistemas Linux
# Autor: [Tu nombre]
# Fecha: [Fecha actual]

# ===== Configuración =====
backup_dir="$HOME/backups"
mkdir -p "$backup_dir"  # Crea el directorio si no existe

# ===== Funciones =====

mostrar_menu() {
    echo "=========== MENÚ DE ADMINISTRACIÓN ==========="
    echo "1) Listar procesos"
    echo "2) Top 5 procesos por CPU"
    echo "3) Top 5 procesos por Memoria"
    echo "4) Terminar proceso"
    echo "5) Listar usuarios"
    echo "6) Usuarios según vejez de contraseña"
    echo "7) Cambiar contraseña de usuario"
    echo "8) Realizar backup del directorio /home"
    echo "9) Ver backups en /home/ubuntu/backup"
    echo "10) Apagar el equipo"
    echo "0) Salir"
    echo "=============================================="
}

listar_procesos() {
    echo
    echo "--- Procesos Activos ---"
    ps aux | less
}

procesos_top_cpu() {
    echo
    echo "--- TOP 5 por Uso de CPU ---"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

procesos_top_mem() {
    echo
    echo "--- TOP 5 por Uso de Memoria ---"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}

terminar_proceso() {
    read -p "Ingrese el PID del proceso a terminar: " pid
    if kill "$pid" 2>/dev/null; then
        echo "Proceso $pid terminado correctamente."
    else
        echo "Error: no se pudo terminar el proceso."
    fi
}

listar_usuarios() {
    echo
    echo "--- Usuarios del Sistema ---"
    cut -d: -f1 /etc/passwd
}

vejez_contrasena() {
    echo
    echo "--- Vejez de contraseñas (usuarios reales) ---"
    awk -F: '$3 >= 1000 { print $1 }' /etc/passwd | while read -r user; do
        info=$(chage -l "$user" 2>/dev/null | grep "Last password change")
        if [ -n "$info" ]; then
            echo "Usuario $user: $info"
        fi
    done
}

cambiar_contrasena() {
    read -p "Nombre del usuario: " usuario
    sudo passwd "$usuario"
}

realizar_backup() {
    usuario=${SUDO_USER:-$USER}     # Si hay sudo, usa el usuario original, sino el actual
    home_dir=$(eval echo "~$usuario")  # Expande el home del usuario
    fecha=$(date +%Y%m%d)
    backup_dir="$home_dir/backup"
    mkdir -p "$backup_dir"
    archivo="backup_home_$fecha.tar.gz"
    tar -czf "$backup_dir/$archivo" "$home_dir" 2>/dev/null
    echo "Backup creado: $backup_dir/$archivo"
}

ver_backups() {
    echo
    echo "--- Lista de Backups en /home/ubuntu/backup ---"
    dir="/home/ubuntu/backup"
    if [ -d "$dir" ]; then
        ls -lh --time-style=long-iso "$dir"/*.tar.gz 2>/dev/null | awk '{printf "Archivo: %-40s  Fecha: %s %s\n", $9, $6, $7}'
    else
        echo "El directorio $dir no existe."
    fi
}



apagar_equipo() {
    echo "El sistema se apagará ahora..."
    sudo shutdown now
}

# ===== Menú Principal =====

while true; do
    mostrar_menu
    read -p "Seleccione una opción: " opcion
    case $opcion in
        1) listar_procesos ;;
        2) procesos_top_cpu ;;
        3) procesos_top_mem ;;
        4) terminar_proceso ;;
        5) listar_usuarios ;;
        6) vejez_contrasena ;;
        7) cambiar_contrasena ;;
        8) realizar_backup ;;
        9) ver_backups ;;
        10) apagar_equipo; break ;;
        0) echo "Saliendo del programa..."; break ;;
        *) echo "Opción inválida. Intente de nuevo." ;;
    esac
    echo ""
done
