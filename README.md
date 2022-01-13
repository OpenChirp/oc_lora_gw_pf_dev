# oc_lora_gw_pf_dev

## Install Procedure

### Standard version
```
#RAK2245
curl -s https://api.github.com/repos/OpenChirp/oc_lora_gw_pf_dev/releases/latest \
| grep "browser_download_url.*RAK2245_armhf.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -

#RAK831
curl -s https://api.github.com/repos/OpenChirp/oc_lora_gw_pf_dev/releases/latest \
| grep "browser_download_url.*RAK831_armhf.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -

sudo apt update
sudo dpkg -i oc-lora-gw-pf_*.deb
sudo apt-get install -fy
rm oc-lora-gw-pf_*.deb

```

### OPR Version
```
#RAK2245
curl -s https://api.github.com/repos/OpenChirp/oc_lora_gw_pf_dev/releases/latest \
| grep "browser_download_url.*RAK2245-OPR.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -

#RAK831
curl -s https://api.github.com/repos/OpenChirp/oc_lora_gw_pf_dev/releases/latest \
| grep "browser_download_url.*RAK831-OPR.*deb" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -i -

sudo apt update
sudo dpkg -i oc-lora-gw-pf_*.deb
sudo apt-get install -fy
rm oc-lora-gw-pf_*.deb

```

# Pins

## RAK2287 (through [RAK Pi HAT](https://docs.rakwireless.com/Product-Categories/WisHat/RAK2287-RAK5146-Pi-HAT/Datasheet/#overview))
	- RESET_PIN 11 	GPIO17(GPIO_GEN0) Connect to SX1302’s RESET PIN, SX1302
	- Built in SPI0 (pin 19,21 24 23) to SX1302
	- GPS_RESET_PIN 22 		GPIO25(GPIO_GEN6)
	- Pin 26 GPIO7(SPI_CE1_N)	GPIO(6)_SX1302	IO	Connect to SX1302’s GPIO[6]
	- Pin 8  GPIO14(TXD0)		UART_RXD_ZOE-M8Q	DI	Connect RAK2287 built in GPS Module (ZOE-M8Q)’s UART_RXD
	- Pin 10 GPIO15(RXD0)		UART_TXD_ZOE-M8Q	DO	Connect to RAK2287 built in GPS Module (ZOE-M8Q)’s UART_TXD
	- Pin 32	GPIO12	STANDBY_GPS_ZOE-M8Q	DI	Connect to RAK2287 built in GPS Module (ZOE-M8Q)’s STANDBY, GPS module ZOE-M8Q external interrupt input, Active low

## Blowfish
	- RESET_PIN 5
	- GPS Reset line - run to GPIO6(pin31)	
	- Built in SPI0 (pin24,21,19,23) to SX1301
	- GPS UART (UART0-pin8,10)
	- 1PPS is connected to the GPIO4-pin7

## RAK2243
	- RESET_PIN 17 (13)

## RAK831
	- RESET_PIN 17 (13)
	- SPI0 (24, 21, 19, 23)
	- RST_PIN 22

## RHF0M301
	- RESET_PIN 7
