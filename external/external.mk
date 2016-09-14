
#Generally only used to include the package .mk files

include $(sort $(wildcard $(BR2_EXTERNAL)/package/*/*.mk))
