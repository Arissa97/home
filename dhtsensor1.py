#Libraries
import Adafruit_DHT as dht
from time import sleep
#Set DATA pin
DHT = 14
while True:
    #Read Temp and Hum from DHT22
    dhtDevice = dht.read_retry(dht.DHT22, DHT)
    temperature_c = dhtDevice.temperature
    humidity = dhtDevice.humidity
    #Print Temperature and Humidity on Shell window
    print("Temp={0:0.1f}*C  Humidity={1:0.1f}%".format(temperature_c,humidity))
    sleep(5) #Wait 5 seconds and read again
