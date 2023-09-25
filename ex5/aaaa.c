#include "wramp.h"

void parallel_main() {
	int switches = 0;
	int button = 0;
	int base = 10; 

	while(1){
		switches = WrampParallel->Switches;
		button = WrampParallel->Buttons;
        
			if(button == 1){
				base = 10;
			}
			if(button == 2){
				base = 16;
			}
			else if(button == 4){
				return;
			}

            if (switches < 0 || switches >= (base*base*base*base)) return;
            WrampParallel->UpperLeftSSD = (switches / (base*base*base)) % base;
            WrampParallel->UpperRightSSD = (switches / (base*base)) % base;
            WrampParallel->LowerLeftSSD = (switches / base) % base;
            WrampParallel->LowerRightSSD = switches % base;

    }
	//Wait for switch value to change.
	//Not necessary, but it makes the display look nicer :)
	while(switches == WrampParallel->Switches);
	return;
}
