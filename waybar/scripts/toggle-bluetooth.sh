#!/usr/bin/env bash
#
# bt-toggle.sh — Bascule l'adaptateur Bluetooth ON/OFF.
# Notifie l'état via swaync (notify-send).
#
# Dépendances : bluetoothctl (bluez), notify-send (libnotify + swaync)

set -euo pipefail

APP_NAME="Bluetooth"

notify() {
    # notify <urgency> <icône> <titre> <corps>
    notify-send \
        --app-name="$APP_NAME" \
        --icon="$2" \
        --urgency="$1" \
        --expire-time=2000 \
        "$3" "$4"
}

# ─── Vérification des dépendances ───────────────────────────────────────────
for cmd in bluetoothctl notify-send; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Dépendance manquante : $cmd" >&2
        exit 1
    }
done

# ─── Débloquer l'adaptateur si nécessaire ───────────────────────────────────
if command -v rfkill >/dev/null 2>&1; then
    rfkill unblock bluetooth 2>/dev/null || true
fi

# ─── Bascule ────────────────────────────────────────────────────────────────
if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    if bluetoothctl power off >/dev/null 2>&1; then
        notify low    "bluetooth-disabled" "Bluetooth désactivé" "L'adaptateur est éteint."
    else
        notify critical "bluetooth" "Erreur" "Impossible d'éteindre le Bluetooth."
        exit 1
    fi
else
    if bluetoothctl power on >/dev/null 2>&1; then
        notify low    "bluetooth-active"   "Bluetooth activé" "L'adaptateur est allumé."
    else
        notify critical "bluetooth" "Erreur" "Impossible d'allumer le Bluetooth."
        exit 1
    fi
fi