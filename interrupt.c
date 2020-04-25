#define INT_BASE (0xca000000)
#define INTMSK (INT_BASE+0x8)
#define INTOFFSET (INT_BASE+0x14)
#define INTPND (INT_BASE+0x10)
#define SRCPND (INT_BASE+0x0)

extern void printk(const char*,...);

void enable_irq(void)
{
    asm volatile (
            "mrs r4, cpsr\n"
            "bic r4, r4, #0x80\n"
            "msr cpsr, r4\n"
            :::"r4"
            );
}

void disable_irq(void)
{
    asm volatile (
            "mrs r4,cpsr\n"
            "orr r4,r4,#0x80\n"
            "msr cpsr,r4\n"
            :::"r4"
            );
}

void umask_int(unsigned int offset)
{
    *(volatile unsigned int *) INTMSK &= ~(1<<offset);
}

void common_irq_handler(void)
{
    unsigned int tmp = (1<<(*(volatile unsigned int *)INTOFFSET));
    printk("%d \t", *(volatile unsigned int *) INTOFFSET);
    *(volatile unsigned int *) SRCPND |= tmp;
    *(volatile unsigned int *) INTPND |= tmp;
    enable_irq();
    printk("timer interrupt occured\n");
}
