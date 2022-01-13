import drivers
import time

display =drivers.Lcd()

#main body

try:
  while True:
        
        print("Writing to display")
	display.lcd_display_string("Greeting Human", 1)
	display.lcd_display_string("Arissa Here", 2)
	time.sleep(12)
	display.lcd_clear()
	display.lcd_display_string("Display only", 2)
	time.sleep(12)
	display.lcd_display_string("Hermit Solution", 1)
	time.sleep(12)
	display.lcd_display_string("Data Receive", 2)
	time.sleep(2)
	display.lcd_clear()
	time.sleep(2)

except KeyboardInterrupt:
	print("Cleaning up")
	display.lcd_clear()

