# APRS Weather Gateway using WeatherCloud and LoRa

This project fetches weather data from **WeatherCloud** (via station ID), converts it to the APRS format, and sends it to an **APRS-IS server** using [`aprs-weather-submit`](https://github.com/rhymeswithmogul/aprs-weather-submit).

It supports:
- Metric system (°C, km/h, mm)
- Docker and Docker Compose
- Automated 2-minute intervals
- GitHub Actions for CI/CD
- Easy deployment via [Dockge](https://github.com/louislam/dockge)

---

## 📦 Requirements

- A [WeatherCloud](https://app.weathercloud.net/) station ID
- A valid APRS-IS **callsign** and **passcode** (get one [here](https://apps.magicbug.co.uk/passcode/))
- A valid lat/lon coordinate for your station
- Docker (or a local Linux environment with Node.js)

---

## 🌐 Environment Variables

Create a `.env` file (used by both Docker and the shell script):

```env
# WeatherCloud station
STATION_ID=5076070607

# APRS location
LATITUDE=37.389092
LONGITUDE=-5.984459

# APRS-IS credentials
CALLSIGN=EA7URS-13
USERNAME=EA7URS
PASSWORD=your_aprs_passcode

# (Optional) APRS-IS server settings
SERVER=euro.aprs2.net
PORT=14580


## Run with Docker locally:
docker build -t aprs-weather .
docker run --env-file .env aprs-weather```

## Deploy with Docker Compose:
docker compose up -d --build

