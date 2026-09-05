#!/usr/bin/env bash
#
# bt-toggle.sh — Bascule l'adaptateur Bluetooth ON/OFF.
# À l'extinction, déconnecte proprement les appareils connectés avant le power off.
# Notifie l'état via swaync (notify-send).
#
# Dépendances : bluetoothctl (bluez), notify-send (libnotify + swaync)

set -euo pipefail

APP_NAME="Bluetooth"
DISCONNECT_TIMEOUT=10   # Délai max pour déconnecter chaque appareil (secondes)

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

# ─── Déconnexion propre des appareils connectés ─────────────────────────────
disconnect_all() {
    local macs mac name

    # Filtre "Connected" dispo sur BlueZ ≥ 5.65 ; sinon on liste tout et on vérifie.
    macs=$(bluetoothctl devices Connected 2>/dev/null | awk '{print $2}')
    [[ -z "$macs" ]] && macs=$(bluetoothctl devices 2>/dev/null | awk '{print $2}')

    for mac in $macs; do
        # Revérifie l'état réel (au cas où le filtre n'est pas supporté)
        bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes" || continue

        name=$(bluetoothctl info "$mac" 2>/dev/null | awk -F': ' '/^\s*Name:/{print $2; exit}')
        [[ -z "$name" ]] && name="$mac"

        notify normal "bluetooth" "Déconnexion…" "Déconnexion de $name…"
        timeout "$DISCONNECT_TIMEOUT" bluetoothctl disconnect "$mac" >/dev/null 2>&1 || true
    done
}

# ─── Bascule ────────────────────────────────────────────────────────────────
if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    # ON → OFF : on déconnecte d'abord, puis on éteint
    disconnect_all

    if bluetoothctl power off >/dev/null 2>&1; then
        notify low      "bluetooth-disabled" "Bluetooth désactivé" "Appareils déconnectés, adaptateur éteint."
    else
        notify critical "bluetooth"          "Erreur" "Impossible d'éteindre le Bluetooth."
        exit 1
    fi
else
    # OFF → ON : on débloque rfkill si besoin, puis on allume
    if command -v rfkill >/dev/null 2>&1; then
        rfkill unblock bluetooth 2>/dev/null || true
    fi

    if bluetoothctl power on >/dev/null 2>&1; then
        notify low      "bluetooth-active" "Bluetooth activé" "L'adaptateur est allumé."
    else
        notify critical "bluetooth"        "Erreur" "Impossible d'allumer le Bluetooth."
        exit 1
    fi
fi
