#include "../JammingExp.h"
#include "IEEE802154.h"
#include "message.h"
#include "CC2420.h"

configuration JammerAppC {  }

implementation {
	components MainC, JammerC as App, LedsC;
	components ActiveMessageC, CC2420ActiveMessageC;
	components new AMSenderC(AM_JAMMING_EXP_MSG);
	components new TimerMilliC();

	App.Boot -> MainC.Boot;
	App.Leds -> LedsC;
	App.AMControl -> ActiveMessageC;
	App.CcaOverride -> CC2420ActiveMessageC.RadioBackoff[AM_JAMMING_EXP_MSG];
	App.AMSend -> AMSenderC;
	App.MilliTimer -> TimerMilliC; 
	App.Packet -> AMSenderC;
}
