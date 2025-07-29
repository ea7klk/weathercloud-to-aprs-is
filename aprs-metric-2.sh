#!/bin/bash

# Verifica que las variables requeridas estén definidas
: "${LATITUDE:?Variable LATITUDE no definida}"
: "${LONGITUDE:?Variable LONGITUDE no definida}"
: "${CALLSIGN:?Variable CALLSIGN no definida}"
: "${USERNAME:?Variable USERNAME no definida}"
: "${PASSWORD:?Variable PASSWORD no definida}"

# Ejecuta script Node.js (se espera que imprima JSON)
weather_json=$(node index.js)

# Verifica si la salida es JSON válido
if ! echo "$weather_json" | jq . >/dev/null 2>&1; then
  echo "❌ Error: la salida de index.js no es JSON válido:"
  echo "$weather_json"
  exit 1
fi

# Extrae datos del JSON
pressure=$(echo "$weather_json" | jq -r '.bar')
temp_c=$(echo "$weather_json" | jq -r '.temp')
humidity=$(echo "$weather_json" | jq -r '.hum')
[ "$humidity" -eq 0 ] && humidity=1

wind_speed_ms=$(echo "$weather_json" | jq -r '.wspdavg')
wind_gust_ms=$(echo "$weather_json" | jq -r '.wspdhi')
wind_dir=$(echo "$weather_json" | jq -r '.wdir')
luminosity=$(echo "$weather_json" | jq -r '.solarrad')
rain_today_mm=$(echo "$weather_json" | jq -r '.rain')
rain_last_hour_mm=$(echo "$weather_json" | jq -r '.rainrate')

# Conversiones a km/h
wind_speed_kmh=$(printf "%.1f" "$(echo "$wind_speed_ms * 3.6" | bc -l)")
wind_gust_kmh=$(printf "%.1f" "$(echo "$wind_gust_ms * 3.6" | bc -l)")

# Servidor APRS-IS (puedes cambiarlo si lo deseas)
SERVER="${SERVER:-euro.aprs2.net}"
PORT="${PORT:-14580}"

# Llamada a aprs-weather-submit
aprs-weather-submit \
  -k "$CALLSIGN" \
  -n "$LATITUDE" \
  -e "$LONGITUDE" \
  -b "$pressure" \
  -T "$temp_c" \
  -h "$humidity" \
  -S "$wind_speed_kmh" \
  -g "$wind_gust_kmh" \
  -c "$wind_dir" \
  -L "$(printf "%.0f" "$luminosity")" \
  -P "$rain_today_mm" \
  -r "$rain_last_hour_mm" \
  -I "$SERVER" \
  -o "$PORT" \
  -u "$USERNAME" \
  -d "$PASSWORD"

status=$?

# Función de log de estado
log_result() {
  timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
  if [ "$status" -eq 0 ]; then
    echo "$timestamp ✅ Enviado: T=$temp_c°C, RH=$humidity%, P=$pressure hPa, Viento=${wind_speed_kmh}km/h dir=$wind_dir°, Lluvia=${rain_today_mm}mm"
  else
    echo "$timestamp ❌ Error al enviar paquete APRS (exit code $status)"
  fi
}

log_result

