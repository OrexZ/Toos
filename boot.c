typedef void (* init_func)(void);

extern void init_mmu_pt(void);
extern void enable_mmu(void);
extern void test_mmu(void);
extern void test_printk(void);
extern void timer04_init(void);
extern void umask_int(unsigned int);
extern void enable_irq(void);
extern void printk(const char*fmt, ...);

#define UFCON0 ((volatile unsigned int *)(0x50000020))
void hello(void){
    const char *p = "DarlingOS! >>.o0\n";
    while(*p)
        *UFCON0 = *p++;
}

void test_mmu(void){
    const char *p = "> test_mmu\n";
    while(*p)
        *(volatile unsigned int *)(0xd0000020) = *p++;
}

void test_printk(void){
    char *p = "this is a %s test";
    char c = 'H';
    int d = -256;
    int k = 0;
    printk("testing printk\n");
    printk("test string ::: %s\ntest char ::: %c\ntest digit ::: %d\ntest X ::: %x\ntest unsigned ::: %u\ntest zero ::: %d\n",
            p, c, d, d, d, k);
}


void timer04_init(void)
{
#define TIMER_BASE (0xd1000000)
#define TCFG0  ((volatile unsigned int *)(TIMER_BASE+0x0))
#define TCFG1  ((volatile unsigned int *)(TIMER_BASE+0x4))
#define TCON   ((volatile unsigned int *)(TIMER_BASE+0x8))
#define TCONB4 ((volatile unsigned int *)(TIMER_BASE+0x3c))
    *TCFG0 |= 0x800;
    *TCON &= (~(7<<20));
    *TCON |= (1<<22);
    *TCON |= (1<<21);
    *TCONB4 = 10000;
    *TCON |= (1<<20);
    *TCON &= ~(1<<21);

    umask_int(14);
    enable_irq();
}

static init_func init[] ={
    hello,
    init_mmu_pt,
    enable_mmu,

    0,// end of NULL
};

void platform_bootup(void){
    int i;
    for (i=0; init[i]; i++){
        init[i]();
    }

    test_mmu();
    test_printk();
    timer04_init();

    while(1);
}
