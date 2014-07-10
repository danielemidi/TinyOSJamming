#include "../JammingExp.h"
#include "printf.h" 

configuration JReceiverAppC { }

implementation {
	components MainC, JReceiverC as App, LedsC, CC2420ActiveMessageC;
	components PrintfC, SerialStartC;
	components new AMReceiverC(AM_JAMMING_EXP_MSG);
	components ActiveMessageC;

	App.Boot -> MainC.Boot;
	App.CC2420Packet -> CC2420ActiveMessageC.CC2420Packet;	
	App.Receive -> AMReceiverC;
	App.AMControl -> ActiveMessageC;
	App.Leds -> LedsC; 
}
