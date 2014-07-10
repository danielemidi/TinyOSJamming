#include "Timer.h"
#include "../JammingExp.h"
#include "printf.h" 

module JReceiverC @safe() {
	uses {
		interface Leds;
		interface Boot;
		interface Receive;
		interface CC2420Packet; 
		interface SplitControl as AMControl;
	}
}

implementation {

	uint16_t received = 0, total = 0, startupreceived = 0, startuptotal = 0;
	int8_t rssi = 0, minrssi = 127, maxrssi = -127, avgrssi = 0;
	uint8_t lqi = 0, minlqi = 255, maxlqi = 0, avglqi = 0;
	
	event void Boot.booted() {
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err) {
		if (err != SUCCESS)
			call AMControl.start();
	}
	event void AMControl.stopDone(error_t err) { }
	
	event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
		regular_msg_t* rmsg = (regular_msg_t*)payload; 
		rssi = (int8_t)call CC2420Packet.getRssi(bufPtr) - 45; // adjust the RSS value by offset of 45
		lqi = (uint8_t)call CC2420Packet.getLqi(bufPtr);
		
		if(rmsg->packet_num != 0) {
			received++;
			total = rmsg->packet_num;
				
			if(total < WARMUP_COUNT+STEADY_COUNT) {
			
				if(total <= WARMUP_COUNT) {
					startuptotal = total;
					startupreceived = received;
				} else {
					if (rssi < minrssi) minrssi = rssi;
					else if (rssi > maxrssi) maxrssi = rssi;
					if (lqi < minlqi) minlqi = lqi;
					else if (lqi > maxlqi) maxlqi = lqi;
				}
				if((total % 10) == 0) {
					// every 10 packets, print transient statistics
					printf("%d / %d , RSSI: %d , LQI: %d \n", received, total, rssi, lqi);
					printfflush();
				}
				call Leds.led1Toggle();
				
			} else {
			
				// at the end, print final statistics and stop listening
				printf("\nGLOBAL STATS\nStartup: %d / %d\nSteady: %d / %d\n", startupreceived, startuptotal, received-startupreceived, total-startuptotal);
				printf("RSSI: min %d - max %d\nLQI: min %d - max %d\n", minrssi, maxrssi, minlqi, maxlqi);
				printfflush();
				call AMControl.stop();
				
			}
		}	
		
		return bufPtr;
		
	}
}
