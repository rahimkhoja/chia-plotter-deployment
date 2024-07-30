# Rahim's Lazy Chia Deployer
### By: Rahim Khoja (rahim@khoja.ca)

This repo contains most of the scripts I use to deploy my Chia Plotters and Harvesters. It relies on the SWAR Plot Manager, Telegram-Send, and Ubuntu 20.04. I have broken the deployment scripts into groups depending what your reqiorements are.

## Requirements

## Hardware

## NVME & Softraid

## Telegram

To use the systemd scripts you must setup a Telegram Bot and connect the Bot to a Telegram Group and send a Message. You may need to give the bot permissions to read messages from the Telegram group.

### Telegram Steps

 - Go to https://t.me/botfather and setup a bot with the Bot Father. Keep a copy of the API Key. ( Don't share this ) (Here is a guide https://core.telegram.org/bots/#6-botfather)
 - Create a Telegram Group and add yourself to it, along with anyone else you want to get the Bot Messages.
 - Add the Bot to the Telegram Group you just made.
 - Give the Bot Admin Access to the Telegram Group. (You may be able to set the permissions a little more securly)
 - Send a message on the Telegram Group so that the bot can find the group.
 - ( Optional ) Telegram-Send is installed as part of my deployment scripts so you may not need this. (Requires pip or pip3 to install)
   `sudo pip3 install telegram-send`
 - Configure telegram-send. Type the following and follow instructions: (It will ask for API Key, and it will also ask you to type a code into the Telegram Group you just made)
   `telegram-send --configure`
 - Test by sending a message.
   `telegram-send "Rahim is Awesome"`



## Included Files





## Support

Since I am extremely lazy I am not going to offer any support. Well maybe every once-n-a while. It really depends on my mood. 

That being said, time was spent documenting each command in the scripts. This should allow the scripts to be easily understood and modified if needed. 


## Donations
Many Bothans died getting this Chia deployment to you, honor them by sending me some Crypto. ;)

ETH Mainnet: 0x1F4EABD7495E4B3D1D4F6dac07f953eCb28fD798   
BNB Chain: 0x1F4EABD7495E4B3D1D4F6dac07f953eCb28fD798   



## License
Released under the GNU General Public License v3. 

http://www.gnu.org/licenses/gpl-3.0.html
