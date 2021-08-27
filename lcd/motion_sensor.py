import drivers
display =drivers.Lcd()     # instantiate LCD Display
display.lcd_clear()
from time import sleep
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)     # set up BCM GPIO numbering
# Set up input pin
GPIO.setup(11, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
# Set up LED output
GPIO.setup(4, GPIO.OUT)
# Callback function to run when motion detected
def motionSensor(channel):
   display.lcd_clear()
   GPIO.output(4, GPIO.LOW)
   if GPIO.input(11):     # True = Rising
       global counter
       counter += 1
       lcd.message('Motion Detected\n{0}'.format(counter))
       GPIO.output(4, GPIO.HIGH)
# add event listener on pin 21
GPIO.add_event_detect(11, GPIO.BOTH, callback=motionSensor, bouncetime=300) 
counter = 0
try:
   while True:
       sleep(1)         # wait 1 second
finally:                   # run on exit
   GPIO.cleanup()         # clean up
   print "All cleaned up." 
