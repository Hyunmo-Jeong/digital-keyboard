module top_module (
	input PS2_KBCLK,		// Keyboard Clock
	input PS2_KBDAT,		// Keyboard Input Data
	input CLOCK_50,
	input [17:0] SW,
	input [3:0] KEY,
	// Sound Input (microphone)
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [17:0] LEDR
	output [6:0] Speaker	// Sound Output
	);
	
	/* Keyboard Input */
	wire [20:0] keyboard_key;
	wire [7:0] key_scan_code;
	wire key_sc_ready, key_letter_case;
	
	key2ascii SC2A (
		.letter_case(key_letter_case),	// Input
		.scan_code(key_scan_code),	// Input
		.key(keyboard_key)			// Output
	);
	
	keyboard kd (
		.clk(CLOCK_50),
		.reset(~resetn),
		.ps2d(PS2_KBDAT),
		.ps2c(PS2_KBCLK),
		.scan_code(key_scan_code),
		.scan_code_ready(key_sc_ready),
		.letter_case_out(key_letter_case)
	);
	
	/* Piano output */
	piano p(
		.clk(),
		.key(keyboard_key),
		.btn(),
		.n1(),
		.n2(),
		.n3(),
		.n4(),
		.n5(),
		.n6(),
		.n7(),
		.n8()
		);
	
	/* Metronome BPM Display */
	wire [7:0] metronome;
	
	hex_display hex5(
		.IN(metronome[7:4]),
		.OUT(HEX5[6:0]) 
		);
	
	hex_display hex4(
		.IN(metronome[3:0]),
		.OUT(HEX4[6:0])
		);
endmodule

module hex_display(IN, OUT);
	input [3:0] IN;
	output reg [7:0] OUT;
	 
	always @(*)
		begin
			case(IN[3:0])
				4'b0000: OUT = 7'b1000000;
				4'b0001: OUT = 7'b1111001;
				4'b0010: OUT = 7'b0100100;
				4'b0011: OUT = 7'b0110000;
				4'b0100: OUT = 7'b0011001;
				4'b0101: OUT = 7'b0010010;
				4'b0110: OUT = 7'b0000010;
				4'b0111: OUT = 7'b1111000;
				4'b1000: OUT = 7'b0000000;
				4'b1001: OUT = 7'b0011000;
				4'b1010: OUT = 7'b0001000;
				4'b1011: OUT = 7'b0000011;
				4'b1100: OUT = 7'b1000110;
				4'b1101: OUT = 7'b0100001;
				4'b1110: OUT = 7'b0000110;
				4'b1111: OUT = 7'b0001110;
			
				default: OUT = 7'b0111111;
			endcase

		end
endmodule