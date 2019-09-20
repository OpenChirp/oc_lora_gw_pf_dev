# oc_lora_gw_pf_dev

## Install Procedure

## Standard version
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
