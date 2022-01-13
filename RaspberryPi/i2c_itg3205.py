from i2clibraries import i2c_itg3205
from time import *

itg3205 = i2c_itg3205(1)

while True:
	(itgready, dataready) = itg3205.getinterruptstatus ()
	if dataready:
		temp = itg3205.getDieTemperature ()
		(x, y, z) = itg3205.getDegPerSecAxes ()
		print ("Temp:" + STR (temp ))
		print ("X:" + STR (x ))
		print ("Y:" + STR (y ))
		print ("Z:" + STR (z ))
		print ("")

Sleep (1)
