#if 0
#define UFCON0 ((volatile unsigned int *)(0x50000020))

void hello(void){
    const char *p = "DarlingOS! >>.o0";
    while(*p)
        *UFCON0 = *p++;
}
#endif

#define UFCON0 ((volatile unsigned int *)(0xd0000020))
void test_mmu(void){
    const char *p = "> test_mmu\n";
    while(*p)
        *UFCON0 = *p++;
}

extern void printk(const char*fmt, ...);
void test_printk(void){
    char *p = "this is a %s test";
    char c = 'H';
    int d = -256;
    int k = 0;
    printk("testng printk\n");
    printk("test string ::: %s\ntest char ::: %c\ntest digit ::: %d\ntest X ::: %x\ntest unsigned ::: %u\ntest zero ::: %d\n",
            p, c, d, d, d, k);
}
