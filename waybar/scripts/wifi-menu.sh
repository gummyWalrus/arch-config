#!/usr/bin/env bash
# ~/.config/waybar/scripts/wifi-menu.sh
# Sélecteur Wi-Fi pour Waybar : wofi + nmcli + notifications (swaync).
# - notification "chargement" pendant le scan puis pendant la connexion
# - une seule bulle réutilisée (scan -> connexion -> résultat) via -p / -r
# - gestion des erreurs avec message d'erreur en notification

set -uo pipefail

APP="Wi-Fi"
ICON="network-wireless"
NOTIF_ID=0

# Envoie OU met à jour la notification courante (remplacement en place).
# $1 urgence (low|normal|critical)  $2 titre  $3 corps  $4 timeout ms (0 = persistant)
notify() {
    local urgency="$1" summary="$2" body="${3:-}" timeout="${4:-5000}"
    NOTIF_ID=$(notify-send -a "$APP" -i "$ICON" -p -r "$NOTIF_ID" \
        -u "$urgency" -t "$timeout" "$summary" "$body")
}

# --- 1. Scan des réseaux -----------------------------------------------------
notify low "Recherche des réseaux…" "Scan Wi-Fi en cours" 0
nmcli dev wifi rescan 2>/dev/null   # échoue si un scan vient d'avoir lieu -> ignoré
sleep 1                             # le rescan est asynchrone : on laisse remonter les résultats

# SSID<TAB>libellé (signal + sécurité). On dédoublonne et on ignore les SSID vides.
networks=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list \
    | awk -F: '!seen[$1]++ && $1 != "" {
        sec = ($3 == "" ? "ouvert" : $3)
        printf "%s\t%s  %s%%  [%s]\n", $1, $1, $2, sec
      }')

if [ -z "$networks" ]; then
    notify critical "Aucun réseau trouvé" "Le Wi-Fi est-il activé ?" 6000
    exit 1
fi

# --- 2. Sélection via wofi ----------------------------------------------------
# Colonne 1 = SSID brut (utilisé), colonne 2 = libellé affiché.
chosen=$(printf '%s\n' "$networks" \
    | wofi --dmenu -i -p "Wi-Fi"  \
           --pre-display-cmd 'echo "%s" | cut -f2' \
    | cut -f1)

# wofi fermé sans choix -> on referme la bulle de scan et on sort.
if [ -z "$chosen" ]; then
    notify normal "Annulé" "" 1500
    exit 0
fi

# --- 3. Connexion -------------------------------------------------------------
notify low "Connexion…" "Connexion à « $chosen »" 0

if nmcli -t -f NAME connection show | grep -qx "$chosen"; then
    # Profil déjà enregistré : reconnexion directe, pas de mot de passe.
    output=$(nmcli connection up "$chosen" 2>&1); status=$?
else
    pass=$(wofi --dmenu --password -p "Mot de passe ($chosen)")
    if [ -z "$pass" ]; then
        # Champ vide : on tente en réseau ouvert.
        output=$(nmcli dev wifi connect "$chosen" 2>&1); status=$?
    else
        output=$(nmcli dev wifi connect "$chosen" password "$pass" 2>&1); status=$?
    fi
fi

# --- 4. Résultat --------------------------------------------------------------
if [ "$status" -eq 0 ]; then
    notify normal "Connecté ✓" "Réseau : $chosen" 4000
else
    # nmcli est verbeux : on nettoie et on ne garde que la 1re ligne utile.
    msg=$(printf '%s' "$output" | sed 's/^Error: //' | head -n1)
    notify critical "Échec de connexion ✗" "${msg:-Impossible de se connecter à « $chosen »}" 7000
    exit 1
fi