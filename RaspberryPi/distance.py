import time
import Adafruit_GPIO.SPI as SPI
import Adafruit_MCP3008

CLK = 18
MISO = 23
MOSI = 24
CS = 25
mcp = Adafruit_MCP3008.MCP3008(clk=CLK, cs=CS, miso=MISO, mosi=MOSI)

while True:

	v = (mcp.read_adc(0) / 1023.0) * 3.3
	dist =( 16.2537 * v**4 – 129.893 * v**3 + 382.268 * v**2 – 512.611 * v + 301.439)
	print(“Distance {:.2f}”.format(dist))
	time.sleep(0.5)
