ifeq ($(CONFIG_ASH_HALL),y)
obj-y += HALLsensor.o
endif
obj-y += IRsensor.o

DEBUG = n

ifeq ($(DEBUG),y)
	DEBFLAGS = -O -g -DASH_ALGO_DEBUG
else
	DEBFLAGS = -O -g
endif
ccflags-y += $(DEBFLAGS)
