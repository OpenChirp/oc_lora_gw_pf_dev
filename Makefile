NAME=oc-lora-gw-pf-dev
VERSION=0.05-dev
MAINTAINER='Artur Balanuta'
DEPS :=
WORK_DIR=src
DESCRIPTION='Openchirp LoRa gateway Packet Forwarder'

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

default: build
 
build: build_Blowfish build_RHF0M301 build_RAK831 build_RAK2245  

compile_%:
	@echo "Compiling $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus"
	@cd lora_gateway; make clean; make
	@cd packet_forwarder; make clean; make

copy_%:
	@echo "Copying $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus"
	
	@mkdir -p bin
	@mkdir -p bin/tests
	@mkdir -p bin/utils

	@cp packet_forwarder/lora_pkt_fwd/lora_pkt_fwd bin

	@cp lora_gateway/libloragw/test_loragw_cal bin/tests
	@cp lora_gateway/libloragw/test_loragw_gps bin/tests
	@cp lora_gateway/libloragw/test_loragw_hal bin/tests
	@cp lora_gateway/libloragw/test_loragw_reg bin/tests
	@cp lora_gateway/libloragw/test_loragw_spi bin/tests

	@cp lora_gateway/util_lbt_test/util_lbt_test bin/utils
	@cp lora_gateway/util_pkt_logger/util_pkt_logger bin/utils
	@cp lora_gateway/util_spectral_scan/util_spectral_scan bin/utils
	@cp lora_gateway/util_spi_stress/util_spi_stress bin/utils
	@cp lora_gateway/util_tx_continuous/util_tx_continuous bin/utils
	@cp lora_gateway/util_tx_test/util_tx_test bin/utils

	@cp packet_forwarder/util_ack/util_ack bin/utils
	@cp packet_forwarder/util_sink/util_sink bin/utils
	@cp packet_forwarder/util_tx_test/util_tx_test bin/utils

	@rm -r $(WORK_DIR)/$(BOARD)/opt/$(NAME)/bin
	@cp -r bin $(WORK_DIR)/$(BOARD)/opt/$(NAME)

	@rm -r bin

package_%:
	@echo "Packaging $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus"
	fpm -s dir -t deb -C $(WORK_DIR)/$(BOARD) --version $(VERSION)-$(BOARD) $(COMMON_FPM_ARGS) $(foreach dep,$(DEPS),-d $(dep);)
	@mkdir -p build
	mv $(NAME)_$(VERSION)-$(BOARD)*.deb build/

echo_%:
	@touch makefile_clean
	@echo "Echo $(NAME)-$(VERSION)-$(BOARD)\t at $(SPI_SPEED) SPI Bus"

build_Blowfish: export BOARD=Blowfish
build_Blowfish: export SPI_SPEED=6500000
build_Blowfish: export DEBUG_OPR=1
build_Blowfish: echo_Blowfish
build_Blowfish: compile_Blowfish
build_Blowfish: copy_Blowfish
build_Blowfish: package_Blowfish

build_RHF0M301: export BOARD=RHF0M301
build_RHF0M301: export SPI_SPEED=6500000
build_RHF0M301: export DEBUG_OPR=1
build_RHF0M301: echo_RHF0M301
build_RHF0M301: compile_RHF0M301
build_RHF0M301: copy_RHF0M301
build_RHF0M301: package_RHF0M301

build_RAK831: export BOARD=RAK831
build_RAK831: export SPI_SPEED=6500000
build_RAK831: export DEBUG_OPR=1
build_RAK831: echo_RAK831
build_RAK831: compile_RAK831
build_RAK831: copy_RAK831
build_RAK831: package_RAK831

build_RAK2245: export BOARD=RAK2245
build_RAK2245: export SPI_SPEED=2000000
build_RAK2245: export DEBUG_OPR=1
build_RAK2245: echo_RAK2245
build_RAK2245: compile_RAK2245
build_RAK2245: copy_RAK2245
build_RAK2245: package_RAK2245