Use Raspbian Lite OS for the process.

connect sbc to the network

Update raspbian
```
sudo apt-get update
sudo apt update
sudo apt upgrade -y
sudo apt install git
```

git clone this repository.

Compile example-api-use
```
make -C examples-api-use
```

```
sudo chmod +x displayPRICE.sh
sudo apt install jq -y
sudo pip install get-mac
```

get path by ```pwd```
navigate to cd etc\
```
sudo nano profile
```
add `/home/pi/rpi-rgb-led-matrix/examples-api-use` in the path
then add ```/home/pi/rpi-rgb-led-matrix/examples-api-use/displayPRICE.sh``` to the end of the line

install nodejs and npm 
```
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt install nodejs
```
crontab node app, add this at end of `crontab -e`
```
@reboot sudo node /home/pi/rpi-rgb-led-matrix/examples-api-use/app.js
```
setup ngrok
