typedef void (* init_func)(void);

//extern void hello(void);
extern void init_mmu_pt(void);
extern void enable_mmu(void);
extern void test_mmu(void);
extern void test_printk(void);

static init_func init[] ={
    init_mmu_pt,
    enable_mmu,
    //hello,
    0,// end of NULL
};

void platform_bootup(void){
    int i;
    for (i=0; init[i]; i++)
        init[i]();

    test_mmu();
    test_printk();

    while(1);
}
