#!/bin/bash
cd /usr/share/chia-blockchain; . ./activate;  telegram-send "$(chia wallet show)"; deactivate
