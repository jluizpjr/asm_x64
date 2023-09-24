#include <stdio.h>
#include <string.h>
#include "prog.h"

void c_func1(void)
{
    printf("Hello from %s\n", __func__);
}

int c_func2(char *msg)
{
    printf("%s", msg);

    return strlen(msg);

}