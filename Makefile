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
LDLIBS=-L/opt/arm-none-eabi-gcc-4.8.2/lib/gcc/arm-none-eabi/4.8.2/

OBJS=start.o init.o boot.o exception.o hello.o

%.o : %.c
	$(CC) $(CFLAGS) -c $<
%.o : %.s
	$(CC) $(ASFLAGS) -c $<

Toos: $(OBJS)
	$(LD) -static -nostartfiles -nostdlib $(LDFLAGS) $^ -o $@ $(LDLIBS) -lgcc
	$(OBJCOPY) -O binary $@ Toos.bin

clean:
	rm -rf *.o Toos Toos.bin

up:
	$(EMULATOR) $(EMULATOR_ACTION)
