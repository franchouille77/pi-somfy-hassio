# Base image from Home Assistant add-ons
ARG BUILD_FROM
FROM $BUILD_FROM

# Environment variables!!!
ENV LANG C.UTF-8
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Make sure to run as root to avoid permission issues!!!
# USER root

# Install Python 3
RUN apk add --no-cache python3

#RUN apk add --no-cache sudo

# Install Python 3 venv support
RUN apk add --no-cache py3-virtualenv

# Create a virtual environment in /venv
RUN python3 -m venv /venv

# Activate the virtual environment
ENV PATH="/venv/bin:$PATH"

# Install pip3
RUN apk add --no-cache py3-pip

# # Install Git
RUN apk add --no-cache git

# Install make
RUN apk add --no-cache make

# Install GCC
RUN apk add --no-cache gcc

# Install G++
RUN apk add --no-cache g++

# Install libc-dev
RUN apk add --no-cache libc-dev

# Install linux-headers
RUN apk add --no-cache linux-headers

# Install libffi-dev
RUN apk add --no-cache libffi-dev

# Install musl-dev
RUN apk add --no-cache musl-dev

# Install setuptools for the make setup.py for pigpio
RUN /venv/bin/pip3 install --no-cache-dir setuptools

# Clone the pigpio repository using git
RUN git clone https://github.com/joan2937/pigpio.git /tmp/build/pigpio

# Apply the fix to disable ldconfig in the Makefile
RUN sed -i -e 's/ldconfig/echo ldconfig disabled/g' /tmp/build/pigpio/Makefile

# Modify device paths in the pigpio source code to use /tmp
RUN find /tmp/build/pigpio -type f -exec sed -i -re 's#/dev/pig(pio|out|err)#/tmp/pig\1#g' {} \;

RUN sed -i 's/from distutils.core import setup/from setuptools import setup/' /tmp/build/pigpio/setup.py

# Build pigpio
RUN make -C /tmp/build/pigpio

# Install pigpio
RUN make -C /tmp/build/pigpio install

# RUN pip3 install --no-cache-dir -e .

# Clean up the cloned pigpio repository
#RUN rm -rf /tmp/build

# Clone the Pi-Somfy repository
RUN git clone https://github.com/Nickduino/Pi-Somfy.git /Pi-Somfy

RUN sed -i -e 's/sudo //' /Pi-Somfy/operateShutters.py

RUN sed -i '1{/^#!\/usr\/bin\/python3/d}' /Pi-Somfy/operateShutters.py

RUN sed -i 's/self\.scheduler\.setDaemon(True)/self.scheduler.daemon = True/' /Pi-Somfy/operateShutters.py


# Install Python dependencies for Pi-Somfy
RUN /venv/bin/pip3 install -r /Pi-Somfy/requirements.txt

# Set the working directory to Pi-Somfy
WORKDIR /Pi-Somfy

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
