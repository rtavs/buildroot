#############################################################
#
# tiobench
#
#############################################################


TIOBENCH_VERSION = 0.3.3
TIOBENCH_SITE = http://downloads.sourceforge.net/project/tiobench/tiobench/$(TIOBENCH_VERSION)
TIOBENCH_SOURCE = tiobench-$(TIOBENCH_VERSION).tar.gz
TIOBENCH_LICENSE = GPLv2


define TIOBENCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) CFLAGS="$(TARGET_CFLAGS)" \
	CC="$(TARGET_CC)" LINK="$(TARGET_CC)" -C $(@D) all
endef


define TIOBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tiotest $(TARGET_DIR)/usr/bin/tiotest
endef

define TIOBENCH_UNINSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/usr/bin/tiotest
endef

define TIOBENCH_CLEAN_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) clean
endef

$(eval $(generic-package))
