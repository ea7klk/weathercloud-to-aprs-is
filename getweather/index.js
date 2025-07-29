import { getWeather } from 'weathercloud-js';

// Obtener el parámetro desde la línea de comandos
// const stationId = process.argv[2];

// Obtener Station ID desde variable de entorno
const stationId = process.env.STATION_ID;

if (!stationId) {
  console.error("❌ Error: Debes indicar un Station ID como argumento.");
  console.error("Uso: node index.js <STATION_ID>");
  process.exit(1);
}

async function main() {
  try {
    const weather = await getWeather(stationId);
    console.log(JSON.stringify(weather)); // Solo JSON limpio para parseo con jq
  } catch (err) {
    console.error("❌ Error al obtener datos de WeatherCloud:", err.message || err);
    process.exit(1);
  }
}

main();

