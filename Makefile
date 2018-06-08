NAME=oc-lora-gw-pf-dev
VERSION=0.03-dev
MAINTAINER='Artur Balanuta'
DEPS :=
WORK_DIR=src
BOARDS := RAK831 RHF0M301 Blowfish
DESCRIPTION='Openchirp LoRa gateway Packet Forwarder'

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
	--verbose

.PHONY: package

build: force

	@echo "Compiling source"
	@cd lora_gateway; make clean; make
	@cd packet_forwarder; make clean; make

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

	@$(foreach board, $(BOARDS), \
	mkdir -p $(WORK_DIR)/$(board)/opt/$(NAME); \
	rm -r $(WORK_DIR)/$(board)/opt/$(NAME)/bin; \
	cp -r bin $(WORK_DIR)/$(board)/opt/$(NAME);)

	@rm -r bin
force:

package:
	@echo "\n"
	@$(foreach board, $(BOARDS), \
	echo Building $(NAME)-$(VERSION)-$(board); \
	fpm -s dir -t deb -C $(WORK_DIR)/$(board) --version $(VERSION)-$(board) $(COMMON_FPM_ARGS) $(foreach dep,$(DEPS),-d $(dep);); \
	echo "\n"; )
	mv $(NAME)_$(VERSION)-*.deb build/

clean:
	@$(foreach board, $(BOARDS), \
	rm -R src/$(board)/opt/oc-lora-gw-pf-dev/bin/;)
