# Woonveilig GATE-03-to-MQTT
This service allows you to publish the state of your Woonveilig/Egardia GATE-03 system to MQTT. It calls the GATE-03 webpage and outputs to mqtt every 2 seconds.

# Requirements

 - `curl`
 - `mosquitto-pub` (`mosquitto-clients` package on Debian/Ubuntu)
 - `jq`

# Installation

 1. Copy `read_alarm.sh` to an appropriate location (like `/usr/local/bin`)
 2. Update the variables in the script to appropriate values
 3. Make the script executable (`chmod +x read_alarm.sh`)

 4. Copy the read-alarm.service file to `/etc/systemd/system/`
 5. Update the `ExecStart` line with the path to the script
 6. Reload systemd (`systemd daemon-reload`)
 7. Start and enable the service (`systemctl enable read-alarm; systemctl start read-alarm`)

# Monitoring
Since this is a systemd service, the status can be viewed with systemctl:

    systemctl status read-alarm

Logging is handled by journald:

    journalctl -u read-alarm

To check the messages published in MQTT, use:

    mosquitto_sub -h ip-of-mqtt-server -v -u mqtt-username -P mqtt-password -t mqtt-topic
