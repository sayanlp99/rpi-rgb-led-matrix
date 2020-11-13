#!/bin/bash
function fetchData(){
        mac_address=$(getmac)
        echo $mac_address
        base_url="http://sda.gssgtechsolution.com/esp.php?mac_address=${mac_address}"
        echo $base_url
        response_json=$(curl $base_url)
        echo $response_json
        if [[ -z "$response_json" ]]; then
                local_json=$(<response_from_server.json)
        else
                truncate -s 0 response_from_server.json
                echo $response_json >> response_from_server.json
                local_json=$(<response_from_server.json)
        fi
        if [[ -f "/output_local_network.json" ]]; then
                echo "output_local_network.json exists."
                petrol_price=$(cat output_local_network.json | jq -r '.["petrol_price"]')
                if [[ -z "$petrol_price" ]]; then
                        petrol_price=$(echo $local_json | jq -r '.[0]["petrol_price"]')
                fi
                diesel_price=$(cat output_local_network.json | jq -r '.["diesel_price"]')
                if [[ -z "$diesel_price" ]]; then
                        diesel_price=$(echo $local_json | jq -r '.[0]["diesel_price"]')
                fi
                xp_price=$(cat output_local_network.json | jq -r '.["xp_price"]')
                if [[ -z "$xp_price" ]]; then
                        xp_price=$(echo $local_json | jq -r '.[0]["xp_price"]')
                fi
                msg=$(cat output_local_network.json | jq -r '.["msg"]')
                if [[ -z "$msg" ]]; then
                        msg=$(echo $local_json | jq -r '.[0]["msg"]')
                fi
                truncate -s 0 output_local_network.json
        else
                petrol_price=$(echo $local_json | jq -r '.[0]["petrol_price"]')
                diesel_price=$(echo $local_json | jq -r '.[0]["diesel_price"]')
                xp_price=$(echo $local_json | jq -r '.[0]["xml_price"]')
                update_date=$(echo $local_json | jq -r '.[0]["update_date"]')
                msg=$(echo $local_json | jq -r '.[0]["msg"]')
        fi
}
online=1
while [ $online -eq 1 ]
do
        nc -z 8.8.8.8 53  >/dev/null 2>&1
        online=$?
        if [ $online -eq 0 ]; then
                echo "Online"
        else
                echo "Offline"
                if [[ -f "/output_local_network.json" ]]; then
                        echo "1: output_local_network.json exists."
                        online=0
                fi
                sudo pdx -f /home/pi/rpi-rgb-led-matrix/examples-api-use/bahnsc.bdf --led-no-hardware-pulse --led-gpio-mapping=regular --led-rows=16 --led-cols=32 --led-chain=12   --led-parallel=1 --led-multiplexing=4 --led-pwm-lsb-nanoseconds 1700 --led-pixel-mapper="V-mapper:Z;Rotate:90" -y -3 -C 255,0,0 -d 7000 -t "NO LINK"
        fi
done
fetchData
echo $petrol_price
while [ 1 ]
do
        if [[ -f "/output_local_network.json" ]]; then
                echo "2: output_local_network.json exists."
                sudo reboot
        fi
        current_loc_date=`date '+%d-%m-%Y'`
        echo $current_loc_date
        current_loc_time_sec=`date +"%H:%M:%S"`
        echo $current_loc_time_sec
        if [[ $current_loc_date -eq $update_date ]]; then
                echo "Same Date. All Perfect"
                sudo pdx -f /home/pi/rpi-rgb-led-matrix/examples-api-use/bahnsc.bdf --led-no-hardware-pulse --led-gpio-mapping=regular --led-rows=16 --led-cols=32 --led-chain=12   --led-parallel=1 --led-multiplexing=4 --led-pwm-lsb-nanoseconds 1700 --led-pixel-mapper="V-mapper:Z;Rotate:90" -y -3 -C 0,255,0 -d 7000 -t "PETROL:${petrol_price}"
                sudo pdx -f /home/pi/rpi-rgb-led-matrix/examples-api-use/bahnsc.bdf --led-no-hardware-pulse --led-gpio-mapping=regular --led-rows=16 --led-cols=32 --led-chain=12   --led-parallel=1 --led-multiplexing=4 --led-pwm-lsb-nanoseconds 1700 --led-pixel-mapper="V-mapper:Z;Rotate:90" -y -3 -C 0,0,255 -d 7000 -t "DIESEL:${diesel_price}"
                sudo pdx -f /home/pi/rpi-rgb-led-matrix/examples-api-use/bahnsc32.bdf --led-no-hardware-pulse --led-gpio-mapping=regular --led-rows=16 --led-cols=32 --led-chain=12   --led-parallel=1 --led-multiplexing=4 --led-pwm-lsb-nanoseconds 1700 --led-pixel-mapper="V-mapper:Z;Rotate:90" -y 2 -C 255,0,0 -d 7000 -t "SERVO  LUBRICANT"
        else
                echo "Date Not Matching"
                current_hour=`date +"%H"`
                current_minute=`date +"%M"`
                if [ $current_hour -eq "6" ] && [ $current_minute -ge "15" ] && [ $current_minute -lt "30" ]; then
                        echo "DATA UPDATE IN PROGRESS. DO NOT TURN OFF DEVICE"
                        fetchData
                elif [ $current_hour -eq "6" ] && [ $current_minute -ge "15" ] || [ $current_hour -gt "6" ]; then
                        echo  "ELSEIF"
                        fetchData
                else
                        echo "SHOWING LAST DATA< YET TO BE UPDATED"
                        sudo pdx -f /home/pi/rpi-rgb-led-matrix/examples-api-use/bahnsc.bdf --led-no-hardware-pulse --led-gpio-mapping=regular --led-rows=16 --led-cols=32 --led-chain=12   --led-parallel=1 --led-multiplexing=4 --led-pwm-lsb-nanoseconds 1700 --led-pixel-mapper="V-mapper:Z;Rotate:90" -y -3 -C 0,255,0 -d 7000 -t "PETROL:${petrol_price}"
                        sudo pdx -f /home/pi/rpi-rgb-led-matrix/examples-api-use/bahnsc.bdf --led-no-hardware-pulse --led-gpio-mapping=regular --led-rows=16 --led-cols=32 --led-chain=12   --led-parallel=1 --led-multiplexing=4 --led-pwm-lsb-nanoseconds 1700 --led-pixel-mapper="V-mapper:Z;Rotate:90" -y -3 -C 0,0,255 -d 7000 -t "DIESEL:${diesel_price}"
                        sudo pdx -f /home/pi/rpi-rgb-led-matrix/examples-api-use/bahnsc32.bdf --led-no-hardware-pulse --led-gpio-mapping=regular --led-rows=16 --led-cols=32 --led-chain=12   --led-parallel=1 --led-multiplexing=4 --led-pwm-lsb-nanoseconds 1700 --led-pixel-mapper="V-mapper:Z;Rotate:90" -y 2 -C 255,0,0 -d 7000 -t "SERVO  LUBRICANT"
                fi
        fi
done
