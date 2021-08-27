import drivers
import time
import RPi.GPIO as GPIO
display =drivers.Lcd()
ledPin = 38    # define the ledPin
sensorPin = 40    # define the sensorPin
def setup():
  print ('Program is starting...')
  GPIO.setwarnings(False)
  GPIO.setmode(GPIO.BOARD)         # Numbers GPIOs by physical location
  GPIO.setup(ledPin, GPIO.OUT)   # Set ledPin's mode is output
  GPIO.setup(sensorPin, GPIO.IN)
def loop():
    while True:

        display.lcd_clear()

        if GPIO.input(sensorPin)==GPIO.HIGH:
            GPIO.output(ledPin,GPIO.HIGH)
            print('led on...')
            display.lcd_display_string("On", 2)
            time.sleep(2)
        else: 
            GPIO.output(ledPin,GPIO.LOW)
            print ('led off...')
            display.lcd_display_string("Off", 1)
            time.sleep(2)

if __name__ =='__main__':
    setup()
    try:
        loop()
    except KeyboardInterrupt:
        GPIO.cleanup()
 
