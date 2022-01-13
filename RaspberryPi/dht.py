from time import sleep
import Adafruit_DHT  as dht
from Adafruit_CharLCD import Adafruit_CharLCD
lcd = Adafruit_CharLCD(rs=25, en=24, d4=23, d5=18,d6=15,d7=14,
                       cols=16, lines=2)

while 1:
    h,t = dht.read_retry(dht.DHT22, 14)  # Poll DHT-22
    lcd.clear()
    # Confirm valid temp and humidity
    if isinstance(h, float) and isinstance(t, float):
        t = t * 9/5.0 + 32  # Convert to Fahrenheit
        lcd.message('    Temp: {0:0.1f}'.format(t))
        lcd.write8(223, True)  # Display degree symbol
        lcd.message('F\nHumidity: {0:0.1f}%'.format(h))
    else:
        lcd.message('Error...')
    sleep(4)
