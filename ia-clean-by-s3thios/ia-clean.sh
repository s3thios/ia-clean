#!/bin/bash
# ia-clean - Mini IA de limpieza para Linux
# Autor: @s3thios (Instagram / YouTube)
# Licencia: MIT

clear
echo "╔════════════════════════════════════╗"
echo "║           🧠 IA-CLEAN             ║"
echo "║     Limpieza inteligente Linux    ║"
echo "║      por @s3thios - IG/YT         ║"
echo "╚════════════════════════════════════╝"

# Detectar idioma
LANG_SET=$(echo $LANG | cut -d'_' -f1)
case "$LANG_SET" in
    es) MSG="Idioma detectado: Español" ;;
    pt) MSG="Idioma detectado: Portugués" ;;
    en) MSG="Idioma detectado: Inglés" ;;
    *) MSG="Idioma desconocido. Usando inglés por defecto" ; LANG_SET="en" ;;
esac
echo "$MSG"

# Detectar arquitectura y distro
ARCH=$(uname -m)
DISTRO=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
echo "Arquitectura: $ARCH | Distro: $DISTRO"

function mini_help {
    echo -e "\n[IA-CLEAN Help]"
    echo "Describe lo que quieres borrar, ejemplos:"
    echo "- 'borrar gimp'"
    echo "- 'elimina kdenlive pero conserva mis videos'"
    echo "- 'limpiar cache y temporales'"
    echo "- 'quitar todo de vlc excepto subtitulos'"
    echo "Frases naturales en español, inglés o portugués"
    echo "Para salir, escribe: salir"
}

mini_help

while true; do
    echo -e "\n¿Qué deseas borrar?"
    read -rp "> " ENTRY

    [[ "$ENTRY" == "salir" ]] && echo "Hasta luego." && break

    # Convertir a minúsculas
    QUERY=$(echo "$ENTRY" | tr '[:upper:]' '[:lower:]')

    # Acciones generales
    case "$QUERY" in
        *help*|*ayuda*|*ajuda*) mini_help ;;
        *cache*|*caché*) echo "[🧹] Borrando cachés..."; sudo apt clean && sudo rm -rf ~/.cache/* ;;
        *temp*|*temporales*) echo "[🧼] Borrando temporales..."; sudo rm -rf /tmp/* ~/.tmp/* ;;
    esac

    # Extracción de paquetes clave
    for word in $QUERY; do
        case "$word" in
            *gimp*|*vlc*|*audacity*|*kdenlive*|*shotcut*|*inkscape*|*libreoffice*|*cheese*|*transmission*)
                echo "[❌] Detectado: $word. Buscando y eliminando..."
                sudo apt remove --purge -y "$word" 2>/dev/null
                flatpak uninstall -y "$word" 2>/dev/null
                snap remove "$word" 2>/dev/null
                ;;
        esac
    done

    echo "[✔️] Comando procesado."
done
