NAME=oc-lora-gw-pf
VERSION=0.07
MAINTAINER='Artur Balanuta'
DEPS :=
WORK_DIR=src
DESCRIPTION='OpenChirp.io LoRa gateway Packet Forwarder'

ARCH_FPM=armhf
# ARCH=arm
# CROSS_COMPILE=/pitools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-

POSTINSTALL_SCRIPT=deb/post-install.sh
PREINSTALL_SCRIPT=deb/pre-install.sh
POSTUNINSTALL_SCRIPT=deb/post-uninstall.sh

COMMON_FPM_ARGS=\
	--log error \
	--after-install $(POSTINSTALL_SCRIPT) \
	--before-install $(PREINSTALL_SCRIPT) \
	--after-remove $(POSTUNINSTALL_SCRIPT) \
	--name $(NAME) \
	--maintainer $(MAINTAINER) \
	--description $(DESCRIPTION) \
	--config-files=/opt/$(NAME)/ \
	--verbose \
	-a $(ARCH_FPM)

#export ARCH=$(ARCH)
#export CROSS_COMPILE=$(CROSS_COMPILE)

NO_COLOR = \e[0m
BLUE_COLOR = \e[1;34m
GREEN_COLOR=\e[32;01m
RED_COLOR=\e[31;01m
ORANGE_COLOR=\e[33;01m

default: build
 
build: RAK831 RAK2245 RAK2287
#RHF0M301 Blowfish

install_tools:
	@echo "$(GREEN_COLOR)"
	@echo "Installing ruby and fpm"
	@echo "$(NO_COLOR)"
	@sudo apt install ruby
	@sudo gem install fpm

%_echo:
	@touch makefile_clean
	@echo "$(GREEN_COLOR)"
	@echo "Echo $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus and DEBUG_OPR=$(DEBUG_OPR)"
	@echo "$(NO_COLOR)"
	@rm makefile_clean

%_compile:
	@echo "$(GREEN_COLOR)"
	@echo "Compiling $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus and DEBUG_OPR=$(DEBUG_OPR)"
	@echo "$(NO_COLOR)"	

	cd src/$(BOARD); \
	rm -rf lora_gateway; \
	git clone https://github.com/Lora-net/lora_gateway.git; \
	cd lora_gateway; \
	cp ../config/loragw_hal_opr.c ./libloragw/src/loragw_hal.c; \
	cp ../config/library.cfg ./libloragw/library.cfg; \
	perl -pi -e 's/#define DEBUG_OPR\s+\d+/#define DEBUG_OPR $(DEBUG_OPR)/g' ./libloragw/src/loragw_hal.c; \
	perl -pi -e 's/#define SPI_SPEED\s+\d+/#define SPI_SPEED $(SPI_SPEED)/g' ./libloragw/src/loragw_hal.c; \
	perl -pi -e 's/#define SPI_SPEED\s+\d+/#define SPI_SPEED $(SPI_SPEED)/g' ./libloragw/src/loragw_spi.native.c; \
	cd src/$(BOARD)/lora_gateway; \
	make

	cd src/$(BOARD); \
	rm -rf packet_forwarder; \
	git clone https://github.com/Lora-net/packet_forwarder.git; \
	cd packet_forwarder; \
	cp ../config/lora_pkt_fwd.c ./lora_pkt_fwd/src/lora_pkt_fwd.c; \
	make

%_copy:
	@echo "$(GREEN_COLOR)"
	@echo "Copying $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus and DEBUG_OPR=$(DEBUG_OPR)"
	@echo "$(NO_COLOR)"

	cd src/$(BOARD); mkdir -p bin bin/tests bin/utils

	@cp src/$(BOARD)/packet_forwarder/lora_pkt_fwd/lora_pkt_fwd src/$(BOARD)/bin
	@cp src/$(BOARD)/lora_gateway/libloragw/test_loragw_* src/$(BOARD)/bin/tests

	@cp src/$(BOARD)/lora_gateway/util_lbt_test/util_lbt_test src/$(BOARD)/bin/utils
	@cp src/$(BOARD)/lora_gateway/util_pkt_logger/util_pkt_logger src/$(BOARD)/bin/utils
	@cp src/$(BOARD)/lora_gateway/util_spectral_scan/util_spectral_scan src/$(BOARD)/bin/utils
	@cp src/$(BOARD)/lora_gateway/util_spi_stress/util_spi_stress src/$(BOARD)/bin/utils
	@cp src/$(BOARD)/lora_gateway/util_tx_continuous/util_tx_continuous src/$(BOARD)/bin/utils
	@cp src/$(BOARD)/lora_gateway/util_tx_test/util_tx_test src/$(BOARD)/bin/utils

	@cp src/$(BOARD)/packet_forwarder/util_ack/util_ack src/$(BOARD)/bin/utils
	@cp src/$(BOARD)/packet_forwarder/util_sink/util_sink src/$(BOARD)/bin/utils
	@cp src/$(BOARD)/packet_forwarder/util_tx_test/util_tx_test src/$(BOARD)/bin/utils

	rm -rf src/$(BOARD)/fs_root/opt/$(NAME)/bin
	cp -r src/$(BOARD)/bin src/$(BOARD)/fs_root/opt/$(NAME)

	rm -rf src/$(BOARD)/bin
	rm -rf src/$(BOARD)/lora_gateway
	rm -rf src/$(BOARD)/packet_forwarder

%_package:
	@echo "$(GREEN_COLOR)"
	@echo "Packaging $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus and DEBUG_OPR=$(DEBUG_OPR)"
	@echo "$(NO_COLOR)"

	if [ $(DEBUG_OPR) -eq 0 ]; \
	then fpm -s dir -t deb -C src/$(BOARD)/fs_root --version $(VERSION)-$(BOARD) $(COMMON_FPM_ARGS) $(foreach dep,$(DEPS),-d $(dep);); \
	else fpm -s dir -t deb -C src/$(BOARD)/fs_root --version $(VERSION)-$(BOARD)-OPR $(COMMON_FPM_ARGS) $(foreach dep,$(DEPS),-d $(dep);); \
	fi;

	@mkdir -p build
	mv $(NAME)_$(VERSION)-$(BOARD)*.deb build/



RAK2287_compile:
	@set -e
	@echo "$(GREEN_COLOR)"
	@echo "Compiling $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus and DEBUG_OPR=$(DEBUG_OPR)"
	@echo "$(NO_COLOR)"	

	cd src/$(BOARD); \
	rm -rf sx1302_hal; \
	git clone -b V2.1.0 https://github.com/Lora-net/sx1302_hal.git; \
	sleep 1

	perl -pi -e 's/ttyS0/ttyAMA0/g' src/$(BOARD)/sx1302_hal/libloragw/tst/test_loragw_gps.c

	cd src/$(BOARD); \
	cp config/loragw_stts751.c sx1302_hal/libloragw/src/ -f; \
	cp config/loragw_hal.c sx1302_hal/libloragw/src/ -f; \
	cp config/lora_pkt_fwd.c sx1302_hal/packet_forwarder/src/ -f

	perl -pi -e 's/ttyS0/ttyAMA0/g' src/$(BOARD)/sx1302_hal/libloragw/tst/test_loragw_gps.c
	perl -pi -e 's/#define SPI_SPEED\s+\d+/#define SPI_SPEED $(SPI_SPEED)/g' src/$(BOARD)/sx1302_hal/libloragw/inc/loragw_spi.h

	cd src/$(BOARD)/sx1302_hal; \
	make

RAK2287_copy:
	@echo "$(GREEN_COLOR)"
	@echo "Copying $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus and DEBUG_OPR=$(DEBUG_OPR)"
	@echo "$(NO_COLOR)"

	cd src/$(BOARD); mkdir -p tmp_dir tmp_dir/bin tmp_dir/service
	
	@cp src/$(BOARD)/sx1302_hal/packet_forwarder/lora_pkt_fwd src/$(BOARD)/tmp_dir/bin
	@cp src/$(BOARD)/sx1302_hal/libloragw/test_loragw_* src/$(BOARD)/tmp_dir/bin
	
	@cp src/$(BOARD)/sx1302_hal/util_boot/boot src/$(BOARD)/tmp_dir/bin
	@cp src/$(BOARD)/sx1302_hal/util_chip_id/chip_id src/$(BOARD)/tmp_dir/bin
	@cp src/$(BOARD)/sx1302_hal/util_net_downlink/net_downlink src/$(BOARD)/tmp_dir/bin
	@cp src/$(BOARD)/sx1302_hal/util_spectral_scan/spectral_scan src/$(BOARD)/tmp_dir/bin
	@cp src/$(BOARD)/sx1302_hal/util_spectral_scan/plot_rssi_histogram.py src/$(BOARD)/tmp_dir/bin

	@cp src/$(BOARD)/config/scripts/* src/$(BOARD)/tmp_dir/bin/
	@cp src/$(BOARD)/config/configs/* src/$(BOARD)/tmp_dir/bin/
	@cp -r src/$(BOARD)/config/service src/$(BOARD)/tmp_dir

	@rm -rf src/$(BOARD)/fs_root/opt/$(NAME)
	@cp -r src/$(BOARD)/tmp_dir src/$(BOARD)/fs_root/opt/$(NAME)
	@rm -rf src/$(BOARD)/tmp_dir
	
	@rm -rf src/$(BOARD)/bin
	@rm -rf src/$(BOARD)/sx1302_hal

RAK2287: export BOARD=RAK2287
RAK2287: export SPI_SPEED=2000000
RAK2287: export DEBUG_OPR=0
RAK2287: RAK2287_echo
RAK2287: RAK2287_compile
RAK2287: RAK2287_copy
RAK2287: RAK2287_package

RAK2245: export BOARD=RAK2245
RAK2245: export SPI_SPEED=2000000
RAK2245: export DEBUG_OPR=0
RAK2245: RAK2245_echo
RAK2245: RAK2245_compile
RAK2245: RAK2245_copy
RAK2245: RAK2245_package

RAK831: export BOARD=RAK831
RAK831: export SPI_SPEED=6500000
RAK831: export DEBUG_OPR=0
RAK831: RAK831_echo
RAK831: RAK831_compile
RAK831: RAK831_copy
RAK831: RAK831_package
