#include "/courses/compx203/ex2/lib_ex2.h"


    
void print(int k){
    int stack[5];
    int i;
    for(i=4; i>=0; i--){
        stack[i] = k % 10;
        k = k / 10;
    }
    // putc(stack[0]+'0');
    // putc(stack[1]+'0');
    // putc(stack[2]+'0');
    // putc(stack[3]+'0');
    // putc(stack[4]+'0');

    for(i=0; i<5; i++){
        putc(stack[i]+'0');
    }
}
