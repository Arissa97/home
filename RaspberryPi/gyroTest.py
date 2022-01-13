From i2clibraries import i2c_itg3205
From time import *

Itg3205 = i2c_itg3205.i2c_itg3205 (0)

While true:
(Itgready, dataready) = itg3205.getinterruptstatus ()
If dataready:
Temp = itg3205.getdietemperature ()
(X, y, z) = itg3205.getdegpersecaxes ()
Print ("Temp:" + STR (temp ))
Print ("X:" + STR (x ))
Print ("Y:" + STR (y ))
Print ("Z:" + STR (z ))
Print ("")

Sleep (1)
