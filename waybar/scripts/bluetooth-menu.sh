#!/usr/bin/env bash
#
# bt-connect.sh — Sélecteur de périphériques Bluetooth via wofi.
# Gère les temps de scan / de connexion et remonte progression et erreurs
# via des notifications swaync (notify-send).
#
# Dépendances : bluetoothctl (bluez), wofi, notify-send (libnotify + swaync)

set -euo pipefail

# ─── Configuration ──────────────────────────────────────────────────────────
SCAN_TIME=8            # Durée du scan de découverte (secondes)
CONNECT_TIMEOUT=25     # Délai max pour appairer / connecter / déconnecter (s)
APP_NAME="Bluetooth"
ICON="bluetooth"       # Icône libnotify affichée par swaync

WOFI_ARGS=(
    --dmenu
    --prompt "Bluetooth"
    --insensitive
    --width 460
    --lines 12
)

# Icônes d'état — nécessitent une Nerd Font.
# Sans Nerd Font, remplacez par des emoji : 🟢  🔵  ⚪  🔄
IC_CONNECTED=""      # Connecté (une sélection déconnectera)
IC_PAIRED=""         # Appairé, non connecté
IC_NEW=""            # Découvert, non appairé
IC_SCAN="Relancer un scan"           # Relancer un scan
SEP="  "               # Séparateur icône / nom (double espace)

# ─── Notifications (une seule bulle mise à jour via replace-id) ──────────────
NOTIFY_ID=0
notify() {
    # notify <urgency: low|normal|critical> <titre> <corps>
    NOTIFY_ID=$(notify-send \
        --app-name="$APP_NAME" \
        --icon="$ICON" \
        --print-id \
        --replace-id="$NOTIFY_ID" \
        --urgency="$1" \
        "$2" "$3")
}

die() {
    notify critical "Erreur" "$1"
    exit 1
}

# ─── Vérification des dépendances ───────────────────────────────────────────
for cmd in bluetoothctl wofi notify-send; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Dépendance manquante : $cmd" >&2
        notify-send --urgency=critical "$APP_NAME" "Dépendance manquante : $cmd" 2>/dev/null || true
        exit 1
    fi
done

# ─── Adaptateur sous tension ────────────────────────────────────────────────
if ! bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    notify normal "Activation" "Mise sous tension de l'adaptateur…"
    bluetoothctl power on >/dev/null 2>&1 || die "Impossible d'activer le Bluetooth (adaptateur bloqué ? essayez : rfkill unblock bluetooth)."
fi

# ─── Scan de découverte ─────────────────────────────────────────────────────
scan() {
    notify normal "Recherche…" "Scan des périphériques ($SCAN_TIME s)"
    # --timeout bloque pendant SCAN_TIME puis coupe le scan proprement
    bluetoothctl --timeout "$SCAN_TIME" scan on >/dev/null 2>&1 || true
}

# ─── Construction du menu wofi ──────────────────────────────────────────────
declare -A DEV_MAP=()   # texte affiché -> MAC
declare -A ACT_MAP=()   # texte affiché -> action (connect|disconnect)

build_menu() {
    MENU=""
    DEV_MAP=()
    ACT_MAP=()

    while read -r _ mac name; do
        [[ -z "${mac:-}" ]] && continue
        info=$(bluetoothctl info "$mac" 2>/dev/null || true)

        if grep -q "Connected: yes" <<<"$info"; then
            display="${IC_CONNECTED}${SEP}${name}"
            ACT_MAP["$display"]="disconnect"
        elif grep -q "Paired: yes" <<<"$info"; then
            display="${IC_PAIRED}${SEP}${name}"
            ACT_MAP["$display"]="connect"
        else
            display="${IC_NEW}${SEP}${name}"
            ACT_MAP["$display"]="connect"
        fi

        DEV_MAP["$display"]="$mac"
        MENU+="${display}"$'\n'
    done < <(bluetoothctl devices 2>/dev/null)

    # Entrée toujours présente pour relancer une recherche
    MENU+="${IC_SCAN}${SEP}"$'\n'
}

# ─── Déroulé principal ──────────────────────────────────────────────────────
scan
build_menu

chosen=$(printf '%s' "$MENU" | wofi "${WOFI_ARGS[@]}") || exit 0
[[ -z "$chosen" ]] && exit 0

# Relance du script (nouveau scan) si l'entrée dédiée est choisie
if [[ "$chosen" == "${IC_SCAN}${SEP}"* ]]; then
    exec "$0"
fi

mac="${DEV_MAP[$chosen]:-}"
action="${ACT_MAP[$chosen]:-connect}"
name="${chosen#*"$SEP"}"   # retire l'icône + le séparateur pour l'affichage

[[ -z "$mac" ]] && die "Périphérique introuvable."

# ─── Déconnexion ────────────────────────────────────────────────────────────
if [[ "$action" == "disconnect" ]]; then
    notify normal "Déconnexion…" "Déconnexion de $name…"
    if timeout "$CONNECT_TIMEOUT" bluetoothctl disconnect "$mac" >/dev/null 2>&1; then
        notify low "Déconnecté" "$name est déconnecté."
    else
        die "Échec de la déconnexion de $name."
    fi
    exit 0
fi

# ─── Connexion (avec appairage si nécessaire) ───────────────────────────────
notify normal "Connexion…" "Connexion à $name en cours…"

info=$(bluetoothctl info "$mac" 2>/dev/null || true)
if ! grep -q "Paired: yes" <<<"$info"; then
    notify normal "Appairage…" "Appairage de $name…"
    if ! timeout "$CONNECT_TIMEOUT" bluetoothctl pair "$mac" >/dev/null 2>&1; then
        die "Échec de l'appairage de $name (délai dépassé ou refus)."
    fi
    bluetoothctl trust "$mac" >/dev/null 2>&1 || true
fi

if timeout "$CONNECT_TIMEOUT" bluetoothctl connect "$mac" >/dev/null 2>&1 \
   && bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
    notify low "Connecté" "$name est connecté ✓"
else
    die "Impossible de se connecter à $name (délai dépassé ou hors de portée)."
fi