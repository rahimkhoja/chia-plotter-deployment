#!/bin/bash
telegram-send "Restarting HPool Miner on ${HOSTNAME}"
systemctl stop hpool.service
