#include "/courses/compx203/ex2/lib_ex2.h"

/**
 *  Counts from "START" to "END" (inclusive), 
 *  showing progress on the seven segment displays.
**/

void count(int start, int end){
    while(start != end){

        writessd(start);
        delay();

    	if(start>end) start--;
        else start++;
        
    }
    if(start==end){
        writessd(start);
    } 
}
