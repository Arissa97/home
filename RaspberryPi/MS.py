import RPi.GPIO as GPIO
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
    if GPIO.input(sensorPin)==GPIO.HIGH:
      GPIO.output(ledPin,GPIO.HIGH)
      print('led on...')
    else: 
      GPIO.output(ledPin,GPIO.LOW)
      print ('led off...')
if __name__ =='__main__':
  setup()
  try:
    loop()
  except KeyboardInterrupt:

    GPIO.cleanup()
 