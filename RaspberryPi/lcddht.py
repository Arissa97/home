import drivers
import time
import board
import adafruit_dht
dhtDevice = adafruit_dht.DHT22(board.D14)
temperature_c = dhtDevice.temperature
temperature_f = temperature_c * (9/5) + 32
humidity = dhtDevice.humidity

display =drivers.Lcd()

#main body

try:
    while True:
        display.lcd_clear()
        temperature_c = dhtDevice.temperature
        print("Writing to display")
        temp= "temp: " + str(temperature_c)
        hum= "humid: " + str(humidity)
        display.lcd_display_string(temp, 1)
        display.lcd_display_string(hum, 2)
        time.sleep(2)
       

except KeyboardInterrupt:
	print("Cleaning up")
	display.lcd_clear()

