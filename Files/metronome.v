module metronome (
	input [17:0] in,		// SW[4:0]
	input clock,			// CLOCK50
	input reset,			// SW[5]
	input tapdown,			// KEY[2]
	input tapup,		    	// KEY[3]
	output speaker,	    		// Speaker
	output [7:0] led,	    	// LEDR[7:0]
	output reg [3:0] hex0, 		// HEX0
	output reg [3:0] hex10,		// HEX1 
	output reg [3:0] hex100		// HEX2
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
			hex0 = 4'b0000; // 0
			
			if (~SW[3] && ~SW[2] && ~SW[1] && ~SW[0])
				begin
					hex100 = 4'b0000;	// 0
					hex10 = 4'b0110;	// 6
					speed = 60;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (~SW[3] && ~SW[2] && ~SW[1] && SW[0]) 
				begin
					hex100 = 4'b0000;	// 0
					hex10 = 4'b0111;	// 7
					speed = 70;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (~SW[3] && ~SW[2] && SW[1] && ~SW[0])
				begin
					hex100 = 4'b0000;	// 0
					hex10 = 4'b1000;	// 8
					speed = 80;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (~SW[3] && ~SW[2] && SW[1] && SW[0]) 
				begin
					hex100 = 4'b0000;	// 0
					hex10 = 4'b1001;	// 9
					speed = 90;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (~SW[4] && ~SW[3] && SW[2] && ~SW[1] && ~SW[0]) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b0000;	// 0
					speed = 100;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[5] == 1) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b0001;	// 1
					speed = 110;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[6] == 1) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b0010;	// 2
					speed = 120;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[7] == 1) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b0011;	// 3
					speed = 130;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[8] == 1) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b0100;	// 4
					speed = 140;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[9] == 1) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b0101;	// 5
					speed = 150;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[10] == 1) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b0110;	// 6
					speed = 160;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[11] == 1) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b0111;	// 7
					speed = 170;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[12] == 1) 
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b1000;	// 8
					speed = 180;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[13] == 1)
				begin
					hex100 = 4'b0001;	// 1
					hex10 = 4'b1001;	// 9
					speed = 190;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[14] == 1)
				begin
					hex100 = 4'b0010;	// 2
					hex10 = 4'b0000;	// 0
					speed = 200;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[15] == 1) 
				begin
					hex100 = 4'b0010;	// 2
					hex10 = 4'b0001;	// 1
					speed = 210;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[16] == 1) 
				begin
					hex100 = 4'b0010;	// 2
					hex10 = 4'b0010;	// 2
					speed = 220;
					bpm = 49999999 / speed * 120;
				end
		    
			else if (in[17] == 1)
				begin
					hex100 = 4'b0010;	// 2
					hex10 = 4'b0011;	// 3
					speed = 230;
					bpm = 49999999 / speed * 120;
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
