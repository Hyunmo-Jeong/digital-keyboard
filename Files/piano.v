module piano(
	input [20:0] key,
	input clk,
	output [6:0] speaker
	);

	reg [20:0] flipper;
	assign speaker = flipper;
	
	reg [17:0] counterC3;
	reg [17:0] counterD3;
	reg [17:0] counterE3;
	reg [17:0] counterF3;
	reg [17:0] counterG3;
	reg [17:0] counterA3;
	reg [17:0] counterB3;
	reg [17:0] counterC4;
	reg [17:0] counterD4;
	reg [17:0] counterE4;
	reg [17:0] counterF4;
	reg [17:0] counterG4;
	reg [17:0] counterA4;
	reg [17:0] counterB4;
	reg [17:0] counterC5;
	reg [17:0] counterD5;
	reg [17:0] counterE5;
	reg [17:0] counterF5;
	reg [17:0] counterG5;
	reg [17:0] counterA5;
	reg [17:0] counterB5;
 
 	/* A4 = 440 Hz, period = 100 * 10 ^ 6 / frequency (Hz) */
	always @(posedge clk) 
		begin
			/* key = 4'd1; a; Do (C3) */
			if (key[0])
				begin
					if (counterC3 == 764467) // 130.81 Hz => 764467 period
						begin
							counterC3 <= 0;
							flipper[0] <= ~flipper[0];
						end 
					else 
						counterC3 <= counterC3 + 1;
				end
			else 
				flipper[0] <= 0;
		
			/* key = 4'd2; s; Re (D3) */
			if (key[1])
				begin
					if (counterD3 == 681059) // 146.83 Hz => 681059 period
						begin
							counterD3 <= 0;
							flipper[1] <= ~flipper[1];
						end 
					else 
						counterD3 <= counterD3 + 1;
				end
			else 
				flipper[1] <= 0;
		
			/* key = 4'd3; d; Mi (E3) */
			if (key[2])
				begin
					if (counterE3 == 606391) // 164.91 Hz => 606391 period
						begin
							counterE3 <= 0;
							flipper[2] <= ~flipper[2];
						end 
					else 
						counterE3 <= counterE3 + 1;
				end
			else 
				flipper[2] <= 0;
		
			/* key = 4'd4; f; Fa (F3) */
			if (key[3])
				begin
					if (counterF3 == 572704)  // 174.61 Hz => 572704 period
						begin
							counterF3 <= 0;
							flipper[3] <= ~flipper[3];
						end 
					else 
						counterF3 <= counterF3 + 1;
				end
			else 
				flipper[3] <= 0;
		
			/* key = 4'd5; g; So (G3) */
			if (key[4])
				begin
					if (counterG3 == 510204) // 196.00 Hz => 510204 period
						begin
							counterG3 <= 0;
							flipper[4] <= ~flipper[4];
						end 
					else 
						counterG3 <= counterG3 + 1;
				end
			else 
				flipper[4] <= 0;
			
			/* key = 4'd6; h; La (A3) */
			if (key[5])
				begin
					if (counterA3 == 454545) // 220.00 Hz => 454545 period
						begin
							counterA3 <= 0;
							flipper[5] <= ~flipper[5];
						end 
					else 
						counterA3 <= counterA3 + 1;
				end 
			else 
				flipper[5] <= 0;
			
			/* key = 4'd7; j; Ti (B3) */
			if (key[6])
				begin
					if (counterB3 == 404956) // 246.94 Hz => 404956 period
						begin
							counterB3 <= 0;
							flipper[6] <= ~flipper[6];
						end 
					else 
						counterB3 <= counterB3 + 1;
				end 
			else 
				flipper[6] <= 0;
			
			/* key = 4'd8; q; Do (C4) */
			if (key[7])
				begin
					if (counterC3 == 382219) // 261.63 Hz => 382219 period
						begin
							counterC4 <= 0;
							flipper[7] <= ~flipper[7];
						end 
					else 
						counterC4 <= counterC4 + 1;
				end 
			else 
				flipper[7] <= 0;
			
			/* key = 4'd9; w; Re (D4) */
			if (key[8])
				begin
					if (counterD3 == 340529) // 293.66 Hz => 340529 period
						begin
							counterD4 <= 0;
							flipper[8] <= ~flipper[8];
						end 
					else 
						counterD4 <= counterD4 + 1;
				end 
			else 
				flipper[8] <= 0;
			
			/* key = 4'd10; e; Mi (E4) */
			if (key[9])
				begin
					if (counterE3 == 303370) // 329.63 Hz => 303370 period
						begin
							counterE4 <= 0;
							flipper[9] <= ~flipper[9];
						end 
					else 
						counterE4 <= counterE4 + 1;
				end 
			else 
				flipper[9] <= 0;
			
			/* key = 4'd11; r; Fa (F4) */
			if (key[10])
				begin
					if (counterF4 == 286344)  // 349.23 Hz => 286344 period
						begin
							counterF4 <= 0;
							flipper[10] <= ~flipper[10];
						end 
					else 
						counterF4 <= counterF4 + 1;
				end 
			else 
				flipper[10] <= 0;
			
			/* key = 4'd12; t; So (G4) */
			if (key[11])
				begin
					if (counterG4 == 255102) // 392.00 Hz => 255102 period
						begin
							counterG4 <= 0;
							flipper[11] <= ~flipper[11];
						end 
					else 
						counterG4 <= counterG4 + 1;
				end
			else 
				flipper[11] <= 0;
			
			/* key = 4'd13; y; La (A4) */
			if (key[12])
				begin
					if (counterA4 == 227272) // 440.00 Hz => 227272 period
						begin
							counterA4 <= 0;
							flipper[12] <= ~flipper[12];
						end 
					else 
						counterA4 <= counterA4 + 1;
				end 
			else 
				flipper[12] <= 0;
		
			/* key = 4'd14; u; Ti (B4) */
			if (key[13])
				begin
					if (counterB4 == 202478) // 493.88 Hz => 202478 period
						begin
							counterB4 <= 0;
							flipper[13] <= ~flipper[13];
						end 
					else 
						counterB4 <= counterB4 + 1;
				end 
			else 
				flipper[13] <= 0;
			
			/* key = 4'd15; 1; Do (C5) */
			if (key[14])
				begin
					if (counterC5 == 191113) // 523.25 Hz => 191113 period
						begin
							counterC5 <= 0;
							flipper[14] <= ~flipper[14];
						end 
					else 
						counterC5 <= counterC5 + 1;
				end 
			else 
				flipper[14] <= 0;
			
			/* key = 4'd16; 2; Re (D5) */
			if (key[15])
				begin
					if (counterD5 == 170262) // 587.33 Hz => 170262 period
						begin
							counterD5 <= 0;
							flipper[15] <= ~flipper[15];
						end 
					else 
						counterD5 <= counterD5 + 1;
				end 
			else 
				flipper[15] <= 0;
			
			/* key = 4'd17; 3; Mi (E5) */
			if (key[16])
				begin
					if (counterE5 == 151687) // 659.25 Hz => 151687 period
						begin
							counterE5 <= 0;
							flipper[16] <= ~flipper[16];
						end 
					else 
						counterE5 <= counterE5 + 1;
				end 
			else 
				flipper[16] <= 0;
			
			/* key = 4'd18; 4; Fa (F5) */
			if (key[17])
				begin
					if (counterF5 == 143172) // 698.46Hz => 143172 period
						begin
							counterF5 <= 0;
							flipper[17] <= ~flipper[17];
						end 
					else 
						counterF5 <= counterF5 + 1;
				end 
			else 
				flipper[17] <= 0;
			
			/* key = 4'd19; 5; So (G5) */
			if (key[18])
				begin
					if (counterG5 == 127552) // 783.99 Hz => 127552 period
						begin
							counterG5 <= 0;
							flipper[18] <= ~flipper[18];
						end 
					else 
						counterG5 <= counterG5 + 1;
				end
			else 
				flipper[18] <= 0;
			
			/* key = 4'd20; 6; La (A5) */
			if (key[19])
				begin
					if (counterA5 == 113636) // 880.00 Hz => 113636 period
						begin
							counterA5 <= 0;
							flipper[19] <= ~flipper[19];
						end 
					else 
						counterA5 <= counterA5 + 1;
				end 
			else 
				flipper[19] <= 0;
		
			/* key = 4'd21; u; Ti (B5) */
			if (key[20])
				begin
					if (counterB5 == 101238) // 987.77 Hz => 101238 period
						begin
							counterB5 <= 0;
							flipper[20] <= ~flipper[20];
						end 
					else 
						counterB5 <= counterB5 + 1;
				end 
			else 
				flipper[20] <= 0;
		end
endmodule