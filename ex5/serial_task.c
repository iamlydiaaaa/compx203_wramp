#include "wramp.h"

int counter = 0;

void printChar(int c) {
	while(!(WrampSp2->Stat & 2));
	WrampSp2->Tx = c;
}


void serial_main() {
	char num = '1';
	char format = '1';
	int seconds = 0;
	int minutes = 0;
	int milli = 0;

	
	//Infinite loop
	while(1) {

		//Read current value from parallel switch register
		num = WrampSp2->Rx;

		if	   (num == '1') format = '1';
		else if(num == '2') format = '2';
		else if(num == '3') format = '3';
		else if(num == 'q') return;

		//Print carriage return to SP1
		printChar('\r');

		if(format == '1'){	// ssss.ss
			seconds = counter / 100;
			milli = counter ;

			printChar('0' + (seconds/1000)%10); 
			printChar('0' + (seconds/100)%10);
			printChar('0' + (seconds/10)%10); 
			printChar('0' + seconds%10);
			printChar('.'); 
			printChar('0' + (milli/10)%10); 
			printChar('0' + milli%10); 

		} else if(format == '2'){	// mm:ss
			seconds = counter / 100;
			minutes = counter / 6000;

			printChar('0' + (minutes/10) % 10); 
			printChar('0' + minutes % 10); 
			printChar(':');
			printChar('0' + (seconds/10) % 6); 
			printChar('0' + seconds % 10);
			printChar(' ');
			printChar(' ');
		}
		else if(format == '3'){		// tttttt (timer interrupts)
			printChar('0' + (counter/100000)%10); 
			printChar('0' + (counter/10000)%10); 
			printChar('0' + (counter/1000)%10); 
			printChar('0' + (counter/100)%10); 
			printChar('0' + (counter/10)%10); 
			printChar('0' + counter%10); 
			printChar(' ');
		}

	}
}
