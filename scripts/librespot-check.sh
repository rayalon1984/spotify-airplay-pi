#!/bin/bash

STATUS_FILE="/tmp/librespot_status"
LAST_STATUS="unknown"
[ -f "$STATUS_FILE" ] && LAST_STATUS=$(cat "$STATUS_FILE")

# בדיקה אם השירות פעיל
systemctl --user is-active --quiet librespot.service
SERVICE_STATUS=$?

# בדיקה אם המכשיר משדר ברשת
avahi-browse -rt _spotify-connect._tcp 2>/dev/null | grep -q 'Pi'
ZC_VISIBLE=$?

if [[ "$SERVICE_STATUS" -ne 0 || "$ZC_VISIBLE" -ne 0 ]]; then
    echo "down" > "$STATUS_FILE"
    /usr/bin/curl -s \
      --form-string "token=your_pushover_app_token" \
      --form-string "user=your_user_key" \
      --form-string "title=Librespot Error" \
      --form-string "message=Librespot service failed or Pi not visible on Spotify" \
      https://api.pushover.net/1/messages.json
else
    if [[ "$LAST_STATUS" == "down" ]]; then
        echo "up" > "$STATUS_FILE"
        /usr/bin/curl -s \
          --form-string "token=your_pushover_app_token" \
          --form-string "user=your_user_key" \
          --form-string "title=Librespot Restored" \
          --form-string "message=Librespot service is back and Pi is visible on Spotify" \
          https://api.pushover.net/1/messages.json
    else
        echo "up" > "$STATUS_FILE"
    fi
fi
