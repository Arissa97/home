import random
import time

from paho.mqtt import client as mqtt_client

import board
import adafruit_dht

import sys
sys.path.insert(1,'./i2clibraries')
from i2c_hmc5883l import *
from i2c_adxl345 import *
from i2c_itg3205 import *
from time import *
import time

dhtDevice = adafruit_dht.DHT22(board.D14)
temperature_c = dhtDevice.temperature
temperature_f = temperature_c * (9/5) + 32
humidity = dhtDevice.humidity

hmc5883l = i2c_hmc5883l(1)
#i = 1

hmc5883l.setContinuousMode ()
hmc5883l.setDeclination (2,4)

adxl345 = i2c_adxl345(1)

itg3205 = i2c_itg3205(1)

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
        (itgready, dataready) = itg3205.getInterruptStatus ()
        (xgy, ygy, zgy) = itg3205.getDegPerSecAxes ()
        (xacc, yacc, zacc) = adxl345.getAxes()
        (xcom, ycom, zcom) = hmc5883l.getAxes()
        msg1 =temperature_c
        msg2 =temperature_f
        msg3 =humidity
        msg4= ","
        msg5= xacc
        msg6= yacc
        msg7= zacc
        msg8= xcom
        msg9= ycom
        msg10= zcom
        msg11= xgy
        msg12= ygy
        msg13= zgy
        msg = str (msg1) + msg4 +str(msg2) + msg4 +str (msg3) +msg4 + str(msg5) +msg4 + str(msg6)+msg4 + str(msg7)+msg4 + str(msg8)+msg4 + str(msg9)+msg4 + str(msg10)+msg4 + str(msg11)+msg4 + str(msg12)+msg4 + str(msg13)
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
