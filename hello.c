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
