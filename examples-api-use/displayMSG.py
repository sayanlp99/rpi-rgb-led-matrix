# import packages
import subprocess
import urllib.request
import json

#retrive mac address of active wireless interface
bashCommand = "getmac"
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()
mac_address = str(output,'utf-8').rstrip()
print(mac_address)

#url query
urlQuery = "http://sda.gssgtechsolution.com/esp.php?mac_address=" + mac_address
print(urlQuery)

#request query from server
with urllib.request.urlopen(urlQuery) as url:
	s = url.read()
queryResponse = str(s,'utf-8').rstrip()
print(queryResponse)

#json decode
jsonData = json.loads(queryResponse)

#scroll text
msg = jsonData[0]['msg']
bashCommand = "sudo ./scrolling-text-example -f ../fonts/texgyre-27.bdf --led-no-hardware-pulse --led-gpio-mapping=regular --led-rows=16 --led-cols=32 --led-chain=10   --led-parallel=1 --led-multiplexing=4 --led-pwm-lsb-nanoseconds 1700 -s 3 -y -10  --led-pixel-mapper=V-mapper:Z;Rotate:90 --led-brightness=100 " + msg
print(bashCommand)
process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
output, error = process.communicate()
