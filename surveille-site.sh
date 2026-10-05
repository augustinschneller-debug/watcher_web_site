#!/bin/bash

MAIL="augustin.schneller@epita.fr"
URL="https://novelfrance.fr"
INTERVAL=60


echo "Surveillance de $URL..."
echo "Vérification toutes les $INTERVAL secondes."
echo "Appuie sur Ctrl+C pour arrêter."

while true; do
    CODE=$(curl -4 -L -s -o /dev/null -w "%{http_code}" \
        --connect-timeout 10 \
        --max-time 20 \
        "$URL")

    DATE=$(date '+%H:%M:%S')

    echo "[$DATE] HTTP $CODE"

    # Le site est considéré comme revenu si HTTP 2xx ou 3xx
    if [[ "$CODE" =~ ^[23][0-9][0-9]$ ]]; then
        echo "$URL est revenu ! HTTP $CODE"
        if [ -n "$MAIL" ]; then
            mail -s "$URL est de retour !" "$MAIL" <<< "Le site répond maintenant avec HTTP $CODE."
        fi
        for i in {1..3}; do
            printf '\a'
            sleep 1
        done
        notify-send \
            -u critical \
            -i network-transmit-receive \
            "$URL est de retour !" \
            "Le site répond maintenant avec HTTP $CODE."

        # Son en plus de la notification


        
        exit 0
    fi

    sleep "$INTERVAL"
done