TinyOSJamming
=============

**Jamming attack scenario for wireless sensor networks with CC2420 motes using only off-the-shelf motes.
The attack is able to cause a high percentage of packet droppings, as well as introduce interference that alters the Received Signal Strength of the received packets.**
Tested on TelosB motes.

This repository includes Sender, Receiver and Jammer applications for a Jamming attack scenario in TinyOS.

The Sender will continuously send packets, and the Jammer will also send packets with Carrier Sensing disabled, thus leading to collisions. The Receiver will receive the packets, keep track of the Packet Reception Rate (PRR), Received Signal Strenght Indicator (RSSI) and Link Quality Indicator (LQI), and compute useful statistics about the scenario with and without the Jamming attack in progress.

The Receiver application collects a customizable number of packets. By default, it collects the first 2000 packets as Warm-up packets (when statistics can heavily fluctuate), then the following 10000 as Steady-mode packets. These numbers are customizable in the `JammingExp.h` file shared by all the applications.

**Acknoledgments:** this work is based on previous work by [Ayon Chakraborty](http://www.cs.sunysb.edu/~aychakrabort/).

##RUNNING THE JAMMING ATTACK
#### INITIAL SETUP
1. Compile and deploy each one of the three application on a different sensor (Note: tested on the TelosB family platform).
2. Plug the Receiver node into a computer
3. Launch the PrintFClient script. This will allow to view the log in real time.

#### NO JAMMING SCENARIO
1. Power up the Sender node
2. Wait for the Global statistics to show the reception rate and RSSI/LQI statistics

#### JAMMING SCENARIO
1. Power up the Jammer and place it in between Sender and Receiver
2. Power up the Sender node
3. Wait for the Global statistics to show the reception rate and RSSI/LQI statistics

##STATISTICS LOG
The log shows statistics every 10 packets, in the form:
```
  [received packets] / [total packets] , RSSI: [RSSI] , LQI: [LQI]
```

In the end, global statistics will be output:
```
  GLOBAL STATS
  Startup: [received packets] / [total packets]
  Steady: [received packets] / [total packets]
  RSSI: [min] - [max]
  LQI: [min] - [max]
```
