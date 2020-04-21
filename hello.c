#define UFCON0 ((volatile unsigned int *)(0x50000020))

void hello(void){
    const char *p = "DarlingOS! >>.o0";
    while(*p)
        *UFCON0 = *p++;
}
