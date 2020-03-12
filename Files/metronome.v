module metronome (
	input [17:0] in,		// SW[4:0]
	input clock,			// CLOCK50
	input reset,			// SW[5]
	input tapdown,			// KEY[2]
	input tapup,		    	// KEY[3]
	output speaker,	    		// Speaker
	output [7:0] led,	    	// LEDR[7:0]
	output reg [0:6] hex0, 		// HEX0
	output reg [0:6] hex10,		// HEX1 
	output reg [0:6] hex100		// HEX2
	);
	
	/* integer */
	integer counter1;
	integer counttap = 1;
	integer bpm;
	integer speed;
	
	/* reg */
	reg [7:0] state;
	
	assign led = state;
	assign speaker = state[0] | state[7];
	
	always @(in, tapup, tapdown)
		begin
			hex0 = 7'b0000001;
			
			// Displays tempo on 7-segment display from switches
			// Sets BPM to given tempo
			if (in[0] == 1)
				begin
					hex100 = 7'b0000001;	// 0
					hex10 = 7'b0100000;	// 6
					speed = 60;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[1] == 1) 
				begin
					hex100 = 7'b0000001;	// 0
					hex10 = 7'b0001111;	// 7
					speed = 70;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[2] == 1)
				begin
					hex100 = 7'b0000001;	// 0
					hex10 = 7'b0000000;	// 8
					speed = 80;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[3] == 1) 
				begin
					hex100 = 7'b0000001;	// 0
					hex10 = 7'b0001100;	// 9
					speed = 90;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[4] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b0000001;	// 0
					speed = 100;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[5] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b1001111;	// 1
					speed = 110;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[6] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b0010010;	// 2
					speed = 120;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[7] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b0000110;	// 3
					speed = 130;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[8] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b1001100;	// 4
					speed = 140;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[9] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b0100100;	// 5
					speed = 150;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[10] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b0100000;	// 6
					speed = 160;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[11] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b0001111;	// 7
					speed = 170;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[12] == 1) 
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b0000000;	// 8
					speed = 180;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[13] == 1)
				begin
					hex100 = 7'b1001111;	// 1
					hex10 = 7'b0001100;	// 9
					speed = 190;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[14] == 1)
				begin
					hex100 = 7'b0010010;	// 2
					hex10 = 7'b0000001;	// 0
					speed = 200;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[15] == 1) 
				begin
					hex100 = 7'b0010010;	// 2
					hex10 = 7'b1001111;	// 1
					speed = 210;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[16] == 1) 
				begin
					hex100 = 7'b0010010;	// 2
					hex10 = 7'b0010010;	// 2
					speed = 220;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[17] == 1)
				begin
					hex100 = 7'b0010010;	// 2
					hex10 = 7'b0000110;	// 3
					speed = 230;
					bpm = 49999999 / speed * 120;
				end
		    
			else 
				begin
					hex100 = 7'b0100100;	// s
					hex10 = 7'b0110000;	// e
					hex0 = 7'b1110001;	// l
					speed = 60;
					bpm = (49999999) / ((counttap / 49999999) * 32) * 160;
				end
	    
		end
    
	always @ (posedge clock) 
		begin
			counter1 <= counter1 + 1;
			
			// Increases or decreases tempo using keys
			if (reset == 0) 
				begin
					counttap = 1;
				end
		    
			if (tapup == 0) 
				begin
					counttap = counttap + 1;
				end
		    
			if(tapdown == 0) 
				begin
					counttap = counttap - 1;
				end
		    
			// Turns LEDs on in sequence
			if (counter1 <= bpm / 14 * 1) 
				begin
					state = 0;
					state[0] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 2) 
				begin
					state = 0;
					state[1] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 3) 
				begin
					state = 0;
					state[2] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 4) 
				begin
					state = 0;
					state[3] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 5) 
				begin
					state = 0;
					state[4] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 6) 
				begin
					state = 0;
					state[5] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 7) 
				begin
					state = 0;
					state[6] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 8) 
				begin
					state = 0;
					state[7] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 9) 
				begin
					state = 0;
					state[6] = 1;
				end
			
			else if (counter1 <= bpm / 14 * 10) 
				begin
					state = 0;
					state[5] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 11) 
				begin
					state = 0;
					state[4] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 12) 
				begin
					state = 0;
					state[3] = 1;
				end
		    
			else if (counter1 <= bpm / 14 * 13) 
				begin
					state = 0;
					state[2] = 1;
				end
		    
			else if (counter1 <= bpm) 
				begin
					state = 0;
					state[1] = 1;
				end
		    
			// Resets counter1 when it hits 50 million
		    
			else if (counter1 == bpm) 
				begin // 50M (2 seconds)
					state[0] = 0;
					counter1 <= 0;
				end
		    
			else 
				begin
					state[0] = 0;
					counter1 <= 0;
				end
	    
		end

endmodule
