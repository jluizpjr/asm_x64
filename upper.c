#include <stdio.h>
#include <string.h>
#include <ctype.h> 


char* strupr(char* s)
{
char* p = s;
while(*p)
*p = toupper((int)*p);
return s;
}

int main(void)
{
    char str[ ] = "geeksforgeeks is the best";
    //converting the given string into uppercase.
    printf("%s\n", strupr (str));
    return 0;
}
