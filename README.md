# Digital Keyboard - CSCB58 Project
This project is an FPGA application on the Altera DE2-115 board that functions as a digital keyboard (piano) from keyboard and microphone input. It can play music using 3 lines of keyboard - 12345678, QWERTYUI, ASDFGHJK. The sounds will have 4 variations that can be changed using 2 switches. Also, the keyboard will contain BPM changeable metronome that keeps ticking while the metronome switch is turned on. The BPM will be displayed on the 7-segment display for users. The sound recorder will also be implemented two records while the record switch is turned on.

## Requirements
* Cyclone IV FPGA DE2 board
* Keyboard: Connect to PS/2 port
* Microphone: Connect to mic-in in DE2 board
* Speaker: Connect to line-out in DE2 board

## References
0. Pin Assignments
  * We used DE2.qsf file provided for labs to assign all pins on DE2 boards.
1. Keyboard Module
  * We used keyboard, key2ascii, and ps2_rx modules from https://github.com/jconenna/FPGA-Projects/tree/master/Keyboard_Interface. ps2_rx and keyboard modules are directly copied and key2ascii was modified to include octave below, octave middle, and octave above keys.
2. Piano Module
  * We used the piano module from https://github.com/mdelrosa/cafinalproject. Piano module was modified to input keyboard keys and add more counters.The frequency and period of each counter were modified, referring to https://pages.mtu.edu/~suits/notefreqs.html.
