typedef void (* init_func)(void);

extern void hello(void);

static init_func init[] ={
    hello,
    0,// end of NULL
};

void platform_bootup(void){
    int i;
    for (i=0; init[i]; i++)
        init[i]();
    while(1);
}
