#include <stdio.h>
#include "prog.h"


int main(void)
{
    int var1 = 0;

    printf("Hello from %s\n", __func__);
    
    c_func1();
    var1 = c_func2("Hello from c_func2\n");
    printf("Return of c_func2: %d\n",var1);

    asm_func1();
    var1 = asm_func2("Hello from asm_func2\n");
    printf("Return of asm_func2: %d\n",var1);

    printf("%s", asm_func3("Hello from asm_func3\n"));
    
    return 0;
}