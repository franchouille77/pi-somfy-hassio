# Pi-Somfy Home Assistant Add-on

This is a Home Assistant add-on that implements the [Pi-Somfy](https://github.com/Nickduino/Pi-Somfy) project to control Somfy motorized shutters using a Raspberry Pi's GPIO pins.

## Project Background

After encountering issues with an existing Pi-Somfy implementation, I developed this Home Assistant add-on to make it start on my setup and access web ui.
[pi-somfy-hassio](https://github.com/korrix/pi-somfy-hassio)

 The add-on features:

- GPIO-based control of Somfy shutters
- Web interface integration with Home Assistant
- Configuration through simple config files

### Version Note

This version has been cleaned up and documented with an AI assistant. It was uploaded some time after the project was initially developed. Some minor adjustments might be needed to achieve full functionality. I was able to measure signals on the GPIOs using my multimeter, while I was cliking buttons on the web UI. 

## Installation and Setup

For detailed installation and setup instructions, please refer to:
- [Pi-Somfy](https://github.com/Nickduino/Pi-Somfy) - Core functionality and hardware setup
- [pi-somfy-hassio](https://github.com/korrix/pi-somfy-hassio) - Home Assistant integration

## Hardware Setup

For testing and development, I used the following setup:

1. **Raspberry Pi 3B** running Home Assistant OS (Hass.io)
2. **GPIO Connection**:
   - Transmitter pin (GPIO 17) connected to a 433MHz transmitter
   - Tested with a multimeter to verify signal output
   - Used standard GPIO pins for up/down/my buttons (22, 23, 24)

## Development Environment

During development, I used:
- **Samba Add-on**: For file synchronization and easy access to configuration files
- **Terminal Add-on**: For running the add-on from CLI and debugging
- **Home Assistant Web UI**: For testing the add-on through the add-on manager

## Testing Results

During testing, I observed:
- Successfully measured signals on the output pin using a multimeter
- Web interface buttons triggered measurable signals
- However, the blinds did not respond to the signals
- Potential issues could be:
  - Signal strength/quality
  - Frequency mismatch
  - Rolling code synchronization
  - Remote ID configuration

## Configuration

The add-on requires proper configuration in two files:

1. `config.yaml`: Add-on configuration (permissions, ports, etc.)
2. `shutters.conf`: Shutter-specific settings (GPIO pins, remote IDs, etc.)

### Important Configuration Notes

- Ensure correct GPIO pin assignments in `shutters.conf`
- Verify remote IDs match your Somfy remotes
- Check rolling code synchronization
- Confirm proper transmitter setup


## License

This project is licensed under the MIT License - see the LICENSE file for details. 
