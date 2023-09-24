#include <stdio.h>
#include "prog.h"

void c_func1(void)
{
    printf("Hello from %s\n", __func__);
}
