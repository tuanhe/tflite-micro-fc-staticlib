/***************************************
 * This is test demo usd for test static lib works or not 
 * by the build command :
 * "gcc -c fc_test.c -o fc_test.o"
 * Then
 * "g++ -o fc_lib_test fc_test.o -L. fully_connected_test"
 * Next
 * "./fc_lib_test"
 * **************************************/

#include <stdio.h> 
#include "fc_wrapper.h"

int main(void)
{
printf("begin to use FC C++ libary\n");
fc_test();
printf("After to use FC C++ libary\n");

return 0;


}
