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


while True:
    try:
        display.lcd_clear()
        temperature_c = dhtDevice.temperature
        #temperature_f = temperature_c * (9/5) + 32
        print("Writing to display")
        temp= "temp: " + str(temperature_c)
        hum= "humid: " + str(humidity)
        display.lcd_display_string(temp, 1)
        display.lcd_display_string(hum, 2)
        time.sleep(2)
       

    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        print(error.args[0])
        time.sleep(2.0)
        continue
    except Exception as error:
        dhtDevice.exit()
        raise error

    time.sleep(2.0)

