// #include <stdio.h>


int pow(int n, int p)
{
    int c;
    int result = 1;
    if(p==0) return result;
    for(c=1;c<=p;c++) result = result * n;
    return result;
}


