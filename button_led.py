import RPi.GPIO as GPIO
import time
inPin = 8
ledPin = 38
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)
GPIO.setup(inPin, GPIO.IN)
GPIO.setup(ledPin, GPIO.OUT)
while True:
	value = GPIO.input(inPin)
	print(value)
	if value:
		print("Pressed")
		GPIO.output(ledPin, GPIO.HIGH)
	else:
		print("Not Pressed")
		GPIO.output(ledPin, GPIO.LOW)
	time.sleep(0.1)

GPIO.cleanup()
