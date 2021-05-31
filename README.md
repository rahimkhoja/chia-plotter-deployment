# Rahim's Lazy Chia Deployer

This repo contains most of the scripts I use to deploy my Chia Plotters and Harvesters. It relies on the SWAR Plot Manager, Telegram-Send, and Ubuntu 20.04. I have broken the deployment scripts into groups depending what your reqiorements are.

## Requirements

## Hardware

## NVME & Softraid

## Telegram

To use the systemd scripts you must setup a Telegram Bot and connect the Bot to a Telegram Group and send a Message. You may need to give the bot permissions to read messages from the Telegram group.

### Telegram Steps

 - Go to https://core.telegram.org/bots and setup a bot with the Bot Father. Keep a copy of the API Key. ( Don't share this )
 - Create a Telegram Group and add yourself to it, along with anyone else you want to get the Bot Messages.
 - Add the Bot to the Telegram Group you just made.
 - Give the Bot Admin Access to the Telegram Group. (You may be able to set the permissions a little more securly)
 - Send a message on the Telegram Group so that the bot can find the group.
 - ( Optional ) Telegram-Send is installed as part of my deployment scripts so you may not need this. `sudo pip3 install telegram-send`
 - 



## Included Files
