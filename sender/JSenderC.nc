#include "Timer.h"
#include "../JammingExp.h"
#include "message.h"
#include "CC2420TimeSyncMessage.h"

module JSenderC @safe() {
	uses {
		interface Leds;
		interface Boot;
		interface AMSend;
		interface CC2420Packet;	
		interface Timer<TMilli> as MilliTimer;
		interface SplitControl as AMControl;
		interface Packet;
	}
}

implementation {

	message_t pkt;
	bool lock;
	uint16_t counter = 0;
	
	event void Boot.booted() {
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS)
			call MilliTimer.startPeriodic(NORMAL_INTERVAL);
		else 
			call AMControl.start();
	}
	event void AMControl.stopDone(error_t err) { }
	
	event void MilliTimer.fired() {
		if (lock)
			return;
		
		regular_msg_t* rmsg = (regular_msg_t*)call Packet.getPayload(&pkt, sizeof(regular_msg_t));
		if (rmsg == NULL) return;
		rmsg->packet_num = ++counter;
		
		if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(regular_msg_t)) == SUCCESS) {
			call Leds.led1Toggle();
			lock = TRUE;
		}
	}
	event void AMSend.sendDone(message_t* bufPtr, error_t error) {
		if (&pkt == bufPtr)
			lock = FALSE;
	}

}
