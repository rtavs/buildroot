################################################################################
#
# toybox
#
################################################################################

TOYBOX_VERSION = 0.5.2
TOYBOX_SITE = http://landley.net/toybox/downloads
TOYBOX_SOURCE = toybox-$(TOYBOX_VERSION).tar.gz
TOYBOX_LICENSE = Public domain, BSD-0c
TOYBOX_LICENSE_FILES = LICENSE


TOYBOX_CFLAGS = \
	$(TARGET_CFLAGS)

TOYBOX_LDFLAGS = \
	$(TARGET_LDFLAGS)


TOYBOX_BUILD_CONFIG = $(TOYBOX_DIR)/.config
# Allows the build system to tweak CFLAGS
TOYBOX_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	CFLAGS="$(TOYBOX_CFLAGS)"


TOYBOX_MAKE_OPTS = \
	CC=gcc \
	ARCH=$(KERNEL_ARCH) \
	PREFIX="$(TARGET_DIR)" \
	EXTRA_LDFLAGS="$(TOYBOX_LDFLAGS)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CONFIG_PREFIX="$(TARGET_DIR)" \
	SKIP_STRIP=y

ifndef TOYBOX_CONFIG_FILE
	TOYBOX_CONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_TOYBOX_CONFIG))
endif

TOYBOX_KCONFIG_FILE = $(TOYBOX_CONFIG_FILE)
TOYBOX_KCONFIG_EDITORS = menuconfig xconfig gconfig
TOYBOX_KCONFIG_OPTS = $(TOYBOX_MAKE_OPTS)


define TOYBOX_BUILD_CMDS
	$(TOYBOX) $(MAKE) $(TOYBOX_MAKE_OPTS) -C $(@D)
endef

define TOYBOX_INSTALL_TARGET_CMDS
	$(BUSYBOX_MAKE_ENV) $(MAKE) $(TOYBOX_MAKE_OPTS) -C $(@D) install
endef


$(eval $(kconfig-package))
