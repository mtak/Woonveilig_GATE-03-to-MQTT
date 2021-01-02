#!/bin/bash

ALARM_HOST='alarm.int.mtak.nl'
ALARM_USERNAME='MerijntjeTak'
ALARM_PASSWORD='xxx'

MQTT_HOST='dom2.int.mtak.nl'
MQTT_USERNAME='readalarm'
MQTT_PASSWORD='xxx'
MQTT_TOPIC='alarm/state'

DISARM_OUTPUT="0"
HOMEARM_OUTPUT="10"
FULLARM_OUTPUT="20"

# No need to replace stuff below this line
while true; do
  curlOutput=$(curl -squ "${ALARM_USERNAME}:${ALARM_PASSWORD}" "http://${ALARM_HOST}/action/panelCondGet" -H 'Accept: application/json, text/javascript, */*; q=0.01' --compressed -H 'X-Requested-With: XMLHttpRequest' | jq .updates.mode_a1 | tr -d '"')

  if [[ "$curlOutput" == "Disarm" ]]; then output="$DISARM_OUTPUT"; fi
  if [[ "$curlOutput" == "Home Arm 1" ]]; then output="$HOMEARM_OUTPUT"; fi
  if [[ "$curlOutput" == "Full Arm" ]]; then output="$FULLARM_OUTPUT"; fi

  if [[ ! -z "$curlOutput" ]]; then
    echo "`date --iso-8601=seconds` Alarm output: $output"
    mosquitto_pub -h "$MQTT_HOST" -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -t "$MQTT_TOPIC" -m "$output"
  else
    echo "`date --iso-8601=seconds` Alarm output error: $curlOutput"
  fi

  sleep 2
done

