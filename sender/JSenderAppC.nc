#include "../JammingExp.h"
#include "IEEE802154.h"
#include "message.h"
#include "CC2420.h"
#include "CC2420TimeSyncMessage.h"

configuration JSenderAppC { }

implementation {
	components MainC, JSenderC as App, LedsC, CC2420PacketP;
	components new AMSenderC(AM_JAMMING_EXP_MSG);
	components new TimerMilliC();
	components ActiveMessageC;

	App.Boot -> MainC.Boot;
	App.AMSend -> AMSenderC;
	App.CC2420Packet -> CC2420PacketP.CC2420Packet;	
	App.AMControl -> ActiveMessageC;
	App.Leds -> LedsC;
	App.MilliTimer -> TimerMilliC;
	App.Packet -> AMSenderC;
}
