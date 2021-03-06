import random
import time

from paho.mqtt import client as mqtt_client

import board
import adafruit_dht

dhtDevice = adafruit_dht.DHT22(board.D14)
temperature_c = dhtDevice.temperature
temperature_f = temperature_c * (9/5) + 32
humidity = dhtDevice.humidity

broker = '192.168.0.105' #broker.emqx.io 192.168.0.106
port = 1883
topic = "sensor"
# generate client ID with pub prefix randomly
client_id = f'python-mqtt-{random.randint(0, 1000)}'
#username = 'emqx'
#password = 'public'

def connect_mqtt():
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client = mqtt_client.Client(client_id)
    #client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client


def publish(client):
    #msg_count = 0
    while True:
        temperature_c = dhtDevice.temperature
        msg1 =temperature_c
        msg2 =temperature_f
        msg3 =humidity
        msg4= ","
        msg = str (msg1) + msg4 +str(msg2) + msg4 +str (msg3)
        result = client.publish(topic, msg)
        # result: [0, 1]
        status = result[0]
        if status == 0:
            print(f"Send `{msg}` to topic `{topic}`")
           # print(f"Send `{msg1}` to topic `{topic}`")
        else:
            print(f"Failed to send message to topic {topic}")
        #msg_count += 1
        time.sleep(2)

def run():
    client = connect_mqtt()
    client.loop_start()
    publish(client)


if __name__ == '__main__':
    run()
