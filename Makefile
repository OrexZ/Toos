WHICH_CROSS=arm-none-eabi
CC=$(WHICH_CROSS)-gcc
LD=$(WHICH_CROSS)-ld
OBJCOPY=$(WHICH_CROSS)-objcopy
TOP=$(shell pwd)

EMULATOR=skyeye
EMULATOR_ACTION=-c $(TOP)/skyeye.conf

CFLAGS= -O2 -g
ASFLAGS= -O2 -g
LDFLAGS= -T os.lds -Ttext 0x30000000

#NOTE: please export the seaching path of your libgcc.a.
# eg. export LIBGCC_A_PATH=/where/is/libgcc/path
LDLIBS=-L$(LIBGCC_A_PATH)

OBJS=start.o init.o boot.o exception.o hello.o mmu.o printk.o

%.o : %.c
	$(CC) $(CFLAGS) -c $<
%.o : %.s
	$(CC) $(ASFLAGS) -c $<

Toos: $(OBJS)
	#NOTE: Some division calculations require the support of the gcc library.
	#unless you implement it yourself.
	$(LD) -static -nostartfiles -nostdlib $(LDFLAGS) $^ -o $@ $(LDLIBS) -lgcc
	$(OBJCOPY) -O binary $@ Toos.bin

clean:
	rm -rf *.o Toos Toos.bin

up:
	$(EMULATOR) $(EMULATOR_ACTION)
