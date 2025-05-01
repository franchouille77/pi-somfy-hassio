# Base image from Home Assistant add-ons
# This allows the add-on to be built on top of Home Assistant's base image
ARG BUILD_FROM
FROM $BUILD_FROM

# Set environment variables for proper system configuration
# LANG=C.UTF-8 ensures proper character encoding
# S6_BEHAVIOUR_IF_STAGE2_FAILS=2 ensures container exits on critical errors
ENV LANG C.UTF-8
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Install Python 3 and essential build tools
# These packages are required for building and running the application
RUN apk add --no-cache python3

# Install Python virtual environment support
# This allows us to create an isolated Python environment
RUN apk add --no-cache py3-virtualenv

# Create and set up a virtual environment in /venv
# This isolates our Python dependencies from the system Python
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install pip3 for Python package management
RUN apk add --no-cache py3-pip

# Install Git for cloning repositories
RUN apk add --no-cache git

# Install build tools and development libraries
# These are required for compiling native extensions and building packages
RUN apk add --no-cache make
RUN apk add --no-cache gcc
RUN apk add --no-cache g++
RUN apk add --no-cache libc-dev
RUN apk add --no-cache linux-headers
RUN apk add --no-cache libffi-dev
RUN apk add --no-cache musl-dev

# Install setuptools for building Python packages
RUN /venv/bin/pip3 install --no-cache-dir setuptools

# Clone and prepare pigpio (Raspberry Pi GPIO library)
# This library is required for controlling GPIO pins
RUN git clone https://github.com/joan2937/pigpio.git /tmp/build/pigpio

# Apply necessary modifications to pigpio
# Disable ldconfig to avoid permission issues in container
RUN sed -i -e 's/ldconfig/echo ldconfig disabled/g' /tmp/build/pigpio/Makefile

# Modify device paths to use /tmp instead of /dev
# This is necessary for running in a container environment
RUN find /tmp/build/pigpio -type f -exec sed -i -re 's#/dev/pig(pio|out|err)#/tmp/pig\1#g' {} \;

# Update setup.py to use setuptools instead of distutils
RUN sed -i 's/from distutils.core import setup/from setuptools import setup/' /tmp/build/pigpio/setup.py

# Build and install pigpio
RUN make -C /tmp/build/pigpio
RUN make -C /tmp/build/pigpio install

# Clone and prepare Pi-Somfy repository
# This is the main application for controlling Somfy blinds
RUN git clone https://github.com/Nickduino/Pi-Somfy.git /Pi-Somfy

# Modify Pi-Somfy scripts for container environment
# Remove sudo commands and update Python compatibility
RUN sed -i -e 's/sudo //' /Pi-Somfy/operateShutters.py
RUN sed -i '1{/^#!\/usr\/bin\/python3/d}' /Pi-Somfy/operateShutters.py
RUN sed -i 's/self\.scheduler\.setDaemon(True)/self.scheduler.daemon = True/' /Pi-Somfy/operateShutters.py

# Install Python dependencies for Pi-Somfy
RUN /venv/bin/pip3 install -r /Pi-Somfy/requirements.txt

# Set the working directory to Pi-Somfy
WORKDIR /Pi-Somfy

# Copy and set up the run script
# This script will be executed when the container starts
COPY run.sh /
RUN chmod a+x /run.sh

# Define the command to run when the container starts
CMD [ "/run.sh" ]
