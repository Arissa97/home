import RPi.GPIO as GPIO
from time import sleep

GPIO.setmode(GPIO.BOARD)

GPIO.setup(37, GPIO.IN)

while True:

	sensor=GPIO.input(37)

	if sensor == 1:
		print("have signal")
		sleep(0.1)
		#v = (sensor(0) / 1023.0) * 3.3
       	#dist =16.2537*v**4–129.893*v**3+382.268*v**2–512.611*v+301.439
       	#print(“Distance {:.2f}”.format(dist))
       	#time.sleep(0.5)

	elif sensor == 0:
		print("no signal")
		sleep(0.1)
