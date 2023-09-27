#include <stdio.h>
#include "prog.h"


int main(void)
{

    
    printf("Hello from %s\n", __func__);
    
    c_func1();
    
    int ret1 = 0;
    ret1 = c_func2("Hello from c_func2\n");
    printf("Return of c_func2: %d\n",ret1);

    asm_func1();

    ret1 = asm_func2("Hello from asm_func2\n");
    printf("Return of asm_func2: %d\n",ret1);

    printf("%s", asm_func3("Hello from asm_func3\n"));

    char *ret2;
    char data1[] = "Hello from asm_func4\n";
    ret2 = asm_func4(data1);
    printf("%s", ret2);


    return 0;
}