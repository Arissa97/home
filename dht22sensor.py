import board
import adafruit_dht
dhtDevice = adafruit_dht.DHT22(board.D14)
temperature_c = dhtDevice.temperature
temperature_f = temperature_c * (9/5) + 32
humidity = dhtDevice.humidity
print("Temp:{:.1f}F/{:.1f}C Humidity:{}%".format(temperature_f,temperature_c,humidity))
