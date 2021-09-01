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

def setup():
    print ('Program is starting...')
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)         # Numbers GPIOs by physical location
    GPIO.setup(ledPin, GPIO.OUT)   # Set ledPin's mode is output
    GPIO.setup(sensorPin, GPIO.IN)
def loop():
    while True:
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
        if GPIO.input(sensorPin)==GPIO.HIGH:
            GPIO.output(ledPin,GPIO.HIGH)
            print('led on...')
            print("Temp:{:.1f}F/{:.1f}C Humidity:{}%".format(temperature_f,temperature_c,humidity))
            print (adxl345)
            temp= "temp: " + str(temperature_c)
            hum= "humid: " + str(humidity)
            display.lcd_display_string(temp, 1)
            display.lcd_display_string(hum, 2)
        else: 
            GPIO.output(ledPin,GPIO.LOW)
            print ('led off...')
            print(hmc5883l)
            
        sleep(2)
if __name__ =='__main__':
    setup()
    try:
        loop()
    except KeyboardInterrupt:

        GPIO.cleanup()