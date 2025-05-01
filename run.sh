#!/usr/bin/with-contenv bashio

# Start pigpio daemon for GPIO access
pigpiod -g -f -l &

# Wait for pigpio daemon to initialize
sleep 0.5

# Run the Pi-Somfy script with the configuration file
cd /Pi-Somfy
/venv/bin/python3 operateShutters.py -c /config/shutters.conf -a
