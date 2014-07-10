#ifndef JAMMING_EXP_H
#define JAMMING_EXP_H

#define WARMUP_COUNT 2000
#define STEADY_COUNT 10000

#define JAMMING_INTERVAL 3
#define NORMAL_INTERVAL 7

typedef nx_struct jamming_msg {
	nx_uint16_t useless; 
} jamming_msg_t;

typedef nx_struct regular_msg {
	nx_uint16_t packet_num;
} regular_msg_t; // this message structure could also contain real sensed data

enum {
	AM_JAMMING_EXP_MSG = 6,
};

#endif
