################################################################################
#
# uboot files for PS5000
#
################################################################################

UBOOT_PS5000_VERSION = 634b85f106c0eb3d5167c989729b564253d60816
UBOOT_PS5000_SITE = $(call github,mcerveny,caesar-u-boot,$(UBOOT_PS5000_VERSION))
UBOOT_PS5000_LICENSE = GPLv2

UBOOT_PS5000_DEPENDENCIES = host-toolchain-optional-linaro-arm rkbin

define UBOOT_PS5000_BUILD_CMDS
    cd $(@D) && RKBIN=$(BINARIES_DIR)/rkbin $(@D)/make.sh wx8-rk3128
endef

define UBOOT_PS5000_INSTALL_TARGET_CMDS
	cp $(@D)/sd_fuse/idbloader.img $(BINARIES_DIR)/idbloader.img
	cp $(@D)/sd_fuse/uboot.img     $(BINARIES_DIR)/uboot.img
	cp $(@D)/sd_fuse/trust.img     $(BINARIES_DIR)/trust.img
endef

$(eval $(generic-package))
