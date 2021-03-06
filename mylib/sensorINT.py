import RPi.GPIO as GPIO
import board
import adafruit_dht
import sys
sys.path.insert(1,'./i2clibraries')
from i2c_hmc5883l import *
from i2c_adxl345 import *
from i2c_itg3205 import *
from time import *
import drivers
import time

dhtDevice = adafruit_dht.DHT22(board.D14)
temperature_c = dhtDevice.temperature
temperature_f = temperature_c * (9/5) + 32
humidity = dhtDevice.humidity
ledPin = 20    # define the ledPin
sensorPin = 21    # define the sensorPin

display =drivers.Lcd()

hmc5883l = i2c_hmc5883l(1)
#i = 1

hmc5883l.setContinuousMode ()
hmc5883l.setDeclination (2,4)

adxl345 = i2c_adxl345(1)

itg3205 = i2c_itg3205(1)


print ('Program is starting...')
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)         # Numbers GPIOs by GPIO
GPIO.setup(ledPin, GPIO.OUT)   # Set ledPin's mode is output
GPIO.setup(sensorPin, GPIO.IN)

while True:
    try:
        display.lcd_clear()
        (itgready, dataready) = itg3205.getInterruptStatus ()
        temperature_c = dhtDevice.temperature
        if dataready:
            temp = itg3205.getDieTemperature ()
            (x, y, z) = itg3205.getDegPerSecAxes ()
            print ("Temp:" + str (temp ))
            print ("X:" + str (x ))
            print ("Y:" + str (y ))
            print ("Z:" + str (z ))
            print ("")
            display.lcd_display_string(("Xg:" + str (x )) , 1)
            display.lcd_display_string(("Yg:" + str (y )) , 2)
            time.sleep(2)
            display.lcd_display_string(("Zg:" + str (z )) , 1)
        if GPIO.input(sensorPin)==GPIO.HIGH:
            GPIO.output(ledPin,GPIO.HIGH)
            print('led on...')
            print("Temp:{:.1f}F/{:.1f}C Humidity:{}%".format(temperature_f,temperature_c,humidity))
            print (adxl345)
            temp= "temp: " + str(temperature_c)
            hum= "humid: " + str(humidity)
            display.lcd_display_string(temp, 1)
            display.lcd_display_string(hum, 2)
            time.sleep(2)
            (xacc, yacc, zacc) = adxl345.getAxes()
            display.lcd_display_string(("Xa:" + str (xacc )) , 1)
            display.lcd_display_string(("Ya:" + str (yacc )) , 2)
            time.sleep(2)
            display.lcd_display_string(("Za:" + str (zacc )) , 1)
        else: 
            GPIO.output(ledPin,GPIO.LOW)
            print ('led off...')
            (xcom, ycom, zcom) = hmc5883l.getAxes()
            print(hmc5883l)
            display.lcd_display_string(("Xc:" + str (xcom )) , 1)
            display.lcd_display_string(("Yc:" + str (ycom )) , 2)
            time.sleep(2)
            display.lcd_display_string(("Zc:" + str (zcom )) , 1)
        sleep(2)

    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        print(error.args[0])
        time.sleep(2.0)
        continue
    except Exception as error:
        dhtDevice.exit()
        raise error

    time.sleep(2.0)   
if __name__ =='__main__':
    setup()
    try:
        loop()
    except KeyboardInterrupt:

        GPIO.cleanup()
