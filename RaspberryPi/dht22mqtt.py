import paho.mqtt.client as mqtt
import time
import sys
import Adafruit_DHT

time.sleep(30) #Sleep to allow wireless to connect before starting MQTT

username = 'emqx'
password = 'public'
clientid = f'python-mqtt-{random.randint(0, 1000)}'

mqttc = mqtt.Client(client_id=clientid)
mqttc.username_pw_set(username, password=password)
mqttc.connect("broker.emqx.io", port=1883, keepalive=60)
mqttc.loop_start()

#topic_dht11_temp = "v1/" + username + "/things/" + clientid + "/data/1"
#topic_dht11_humidity = "v1/" + username + "/things/" + clientid + "/data/2"
topic_dht22_temp = "v1/" + username + "/things/" + clientid + "/data/3"
topic_dht22_humidity = "v1/" + username + "/things/" + clientid + "/data/4"

while True:
    try:
        #humidity11, temp11 = Adafruit_DHT.read_retry(11, 17) #11 is the sensor type, 17 is the GPIO pin number (not physical pin number)
        humidity22, temp22 = Adafruit_DHT.read_retry(22, 14)
            
            mqttc.publish(topic_dht22_temp, payload=temp22, retain=True)
        if humidity22 is not None:
            humidity22 = "rel_hum,p=" + str(humidity22)
            mqttc.publish(topic_dht22_humidity, payload=humidity22, retain=True)
        time.sleep(5)
    except (EOFError, SystemExit, KeyboardInterrupt):
        mqttc.disconnect()
        sys.exit()