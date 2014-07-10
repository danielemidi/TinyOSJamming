#include "Timer.h"
#include "../JammingExp.h"
#include "message.h"

#define CC2420_NO_ACKNOWLEDGEMENTS
#define CC2420_NO_ADDRESS_RECOGNITION

module JammerC @safe() {
	uses {
		interface Leds;
		interface Boot;
		interface SplitControl as AMControl;
		interface RadioBackoff as CcaOverride;
		interface AMSend; 
		interface Timer<TMilli> as MilliTimer; 
		interface Packet;   
	}
}

implementation {

	message_t pkt;

	event void Boot.booted() {
		call AMControl.start();
	}
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS)
			call MilliTimer.startPeriodic(JAMMING_INTERVAL); 
		else
			call AMControl.start();
	}
	event void AMControl.stopDone(error_t err) { }

	event void MilliTimer.fired() {
		jamming_msg_t* jcm;
		jcm = (jamming_msg_t*)call Packet.getPayload(&pkt, sizeof(jamming_msg_t));
		jcm->useless = 0;
		if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(jamming_msg_t)) == SUCCESS) 
			call Leds.led0Toggle(); 
	}
	event void AMSend.sendDone(message_t* bufPtr, error_t error) { }

	async event void CcaOverride.requestCca(message_t *msg) {
		call CcaOverride.setCca(FALSE);
		call Leds.led1Toggle();
	}
	async event void CcaOverride.requestInitialBackoff(message_t *msg) { }
	async event void CcaOverride.requestCongestionBackoff(message_t *msg) { }

}
