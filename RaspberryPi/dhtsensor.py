import Adafruit_DHT as dht	#Arguments dht instead of Adafruit_DHT, DHT11 device, GPIO26
#import lcddriver
import time

#Assign to variables

pin = 14   					#GPIO pin we are communicating on CHANGE THIS
#h,t = dht.read_retry(dht.DHT22, pin)		#Refreshes the DHT sensor. ARG DHT11 or DHT22 sensor
#display = lcddriver.lcd()			#Refering to the LCD
#temp = 'Temp:{0:0.1f} C'			#Store temp string info 
#humid = 'Humidity:{1:0.1f}%'			#Store Humidity info

try:
	while True:
			h,t = dht.read_retry(dht.DHT22, pin)		#Loop the check sensor check DHT11 or DHT22 sensor 
			#temp = 'Temp:{0:0.1f} C'.format(t)			#Update variable temperature
			#humid = 'Humidity:{1:0.1f}%'.format(t,h)
			print('Temp={0:0.1f}*C  Humidity={1:0.1f}%'.format(t,h))						#Update variable humidity
			#display.lcd_clear()				#Clear screen
			#display.lcd_display_string(temp, 1)		#write temp to screen
			#display.lcd_display_string(humid, 2)		#write humdity to screen
			time.sleep(2)
 
except KeyboardInterrupt: # If there is a KeyboardInterrupt (when you press ctrl+c), exit the program and cleanup
    print("Cleaning up!")
   # display.lcd_clear()
