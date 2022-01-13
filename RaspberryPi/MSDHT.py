import RPi.GPIO as GPIO
import board
import adafruit_dht

dhtDevice = adafruit_dht.DHT22(board.D14)
temperature_c = dhtDevice.temperature
temperature_f = temperature_c * (9/5) + 32
humidity = dhtDevice.humidity
ledPin = 20    # define the ledPin
sensorPin = 21    # define the sensorPin

def setup():
  print ('Program is starting...')
  GPIO.setwarnings(False)
  GPIO.setmode(GPIO.BCM)         # Numbers GPIOs by physical location
  GPIO.setup(ledPin, GPIO.OUT)   # Set ledPin's mode is output
  GPIO.setup(sensorPin, GPIO.IN)
def loop():
  while True:
    temperature_c = dhtDevice.temperature 
    if GPIO.input(sensorPin)==GPIO.HIGH:
      GPIO.output(ledPin,GPIO.HIGH)
      print('led on...')
      print("Temp:{:.1f}F/{:.1f}C Humidity:{}%".format(temperature_f,temperature_c,humidity))
    else: 
      GPIO.output(ledPin,GPIO.LOW)
      print ('led off...')
if __name__ =='__main__':
  setup()
  try:
    loop()
  except KeyboardInterrupt:

    GPIO.cleanup()