from time import sleep
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)     # set up BCM GPIO numbering
# Set up input pin
GPIO.setup(21, GPIO.IN)
# Set up LED output
GPIO.setup(20, GPIO.OUT)
def motionSensor(channel):

    GPIO.output(20, GPIO.LOW)
    if GPIO.input(21):     # True = Rising

        print 'Motion Detected'

        GPIO.output(20, GPIO.HIGH)  
    else:
        
        print 'No Motion'

       
# add event listener on pin 21
GPIO.add_event_detect(21, GPIO.BOTH, callback=motionSensor, bouncetime=300) 

try:
    while True:
        # GPIO.output(20, GPIO.LOW)
        # if GPIO.input(21):     # True = Rising

        #     print 'Motion Detected'
        #     GPIO.output(20, GPIO.HIGH)
        # else:
        #     print 'No Motion'
        sleep(1)         # wait 1 second
finally:                   # run on exit
    GPIO.cleanup()         # clean up
    print "All cleaned up." 