FROM debian:bookworm-slim

# Instala dependencias en una sola capa
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      build-essential \
      nodejs \
      npm \
      git \
      software-properties-common \
      autotools-dev \
      autoconf \
      m4 \
      jq \
      bc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clona y compila aprs-weather-submit
RUN git clone https://github.com/rhymeswithmogul/aprs-weather-submit.git /aprs-weather-submit && \
    cd /aprs-weather-submit && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Copia el código del proyecto
WORKDIR /app
COPY . .

# Instala dependencias y compila weathercloud-js
RUN cd getweather && \
    npm install && \
    cd node_modules/weathercloud-js && \
    npm install && \
    npm run build

# Define directorio de trabajo
WORKDIR /app/getweather

# Ejecuta el script cada 2 minutos en bucle infinito
CMD bash -c 'while true; do bash /app/aprs-metric-2.sh; sleep 120; done'

