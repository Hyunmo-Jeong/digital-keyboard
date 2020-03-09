// Module taken from Joe Armitage & co
module ps2_rx (
	input wire clk, reset, 
	input wire ps2d, ps2c, rx_en,	    // ps2 data and clock inputs, receive enable input
	output reg rx_done_tick,		    // ps2 receive done tick
	output wire [7:0] rx_data		    // data received 
	);
	
	// FSMD state declaration
	localparam 
		idle = 1'b0,
		rx   = 1'b1;
		
	// Internal signal declaration
	reg state_reg, state_next;	    // FSMD state register
	reg [7:0] filter_reg;		    // Shift register filter for ps2c
	wire [7:0] filter_next;		    // Next state value of ps2c filter register
	reg f_val_reg;				    // reg for ps2c filter value, either 1 or 0
	wire f_val_next;			    // Next state for ps2c filter value
	reg [3:0] n_reg, n_next;            // Register to keep track of bit number 
	reg [10:0] d_reg, d_next;	    // Register to shift in rx data
	wire neg_edge;			    // Negative edge of ps2c clock filter value
	
	// Register for ps2c filter register and filter value
	always @(posedge clk, posedge reset)
		if (reset)
			begin
				filter_reg <= 0;
				f_val_reg  <= 0;
			end
		else
			begin
				filter_reg <= filter_next;
				f_val_reg  <= f_val_next;
			end

	// Next state value of ps2c filter: right shift in current ps2c value to register
	assign filter_next = {ps2c, filter_reg[7:1]};
	
	// Filter value next state, 1 if all bits are 1, 0 if all bits are 0, else no change
	assign f_val_next = (filter_reg == 8'b11111111) ? 1'b1 :
					  (filter_reg == 8'b00000000) ? 1'b0 :
					  f_val_reg;
	
	// Negative edge of filter value: if current value is 1, and next state value is 0
	assign neg_edge = f_val_reg & ~f_val_next;
	
	// FSMD state, bit number, and data registers
	always @(posedge clk, posedge reset)
	    if (reset)
		begin
		    state_reg <= idle;
		    n_reg <= 0;
		    d_reg <= 0;
		end
	    else
		begin
		    state_reg <= state_next;
		    n_reg <= n_next;
		    d_reg <= d_next;
		end
	
	// FSMD next state logic
	always @(*)
	    begin
		// defaults
		state_next = state_reg;
		rx_done_tick = 1'b0;
		n_next = n_reg;
		d_next = d_reg;
			
		case (state_reg)
		    idle:
			if (neg_edge & rx_en)				   // Start bit received
			    begin
				n_next = 4'b1010;				   // Set bit count down to 10
				state_next = rx;				   // Go to rx state
			    end
			    
		    rx:								    // Shift in 8 data, 1 parity, and 1 stop bit
			begin
			    if (neg_edge)					    // If ps2c negative edge...
				begin
				    d_next = {ps2d, d_reg[10:1]};	    // Sample ps2d, right shift into data register
				    n_next = n_reg - 1;			    // Decrement bit count
				end
				
			    if (n_reg==0)					    // After 10 bits shifted in, go to done state
				begin
				    rx_done_tick = 1'b1;			    // Assert dat received done tick
				    state_next = idle;			    // Go back to idle
				end
			end
		endcase
	    end
		
	assign rx_data = d_reg[8:1]; // output data bits 
endmodule

// Module taken from Joe Armitage & co
module keyboard (
    input wire clk, reset,
    input wire ps2d, ps2c,			// ps2 data and clock lines
    output wire [7:0] scan_code,		// scan_code received from keyboard to process
    output wire scan_code_ready,	// Signal to outer control system to sample scan_code
    output wire letter_case_out		// Output to determine if scan code is converted to lower or upper ascii code for a key
    );
	
    // Constant declarations
    localparam  BREAK    = 8'hf0,		// Break code
			  SHIFT1   = 8'h12,		// First shift scan
			  SHIFT2   = 8'h59,	// Second shift scan
			  CAPS     = 8'h58;		// Caps lock

    // FSM symbolic states
    localparam [2:0] lowercase			= 3'b000,	// idle, process lower case letters
				   ignore_break		= 3'b001,	// Ignore repeated scan code after break code -F0- reeived
				   shift				= 3'b010,	// Process uppercase letters for shift key held
				   ignore_shift_break	= 3'b011,	// Check scan code after F0, either idle or go back to uppercase
				   capslock			= 3'b100,	// Process uppercase letter after capslock button pressed
				   ignore_caps_break	= 3'b101;	// Check scan code after F0, either ignore repeat, or decrement caps_num
                     
               
    // Internal signal declarations
    reg [2:0] state_reg, state_next;			    // FSM state register and next state logic
    wire [7:0] scan_out;						    // Scan code received from keyboard
    reg got_code_tick;						    // Asserted to write current scan code received to FIFO
    wire scan_done_tick;						    // Asserted to signal that ps2_rx has received a scan code
    reg letter_case;							    // 0 for lower case, 1 for uppercase, outputed to use when converting scan code to ascii
    reg [7:0] shift_type_reg, shift_type_next;	    // Register to hold scan code for either of the shift keys or caps lock
    reg [1:0] caps_num_reg, caps_num_next;	    // Keeps track of number of capslock scan codes received in capslock state (3 before going back to lowecase state)
   
    // Instantiate ps2 receiver
    ps2_rx ps2_rx_unit (.clk(clk), .reset(reset), .rx_en(1'b1), .ps2d(ps2d), .ps2c(ps2c), .rx_done_tick(scan_done_tick), .rx_data(scan_out));
	
    // FSM stat, shift_type, caps_num register 
    always @(posedge clk, posedge reset)
	if (reset)
	    begin
		state_reg <= lowercase;
		shift_type_reg <= 0;
		caps_num_reg   <= 0;
	    end
	else
	    begin    
		state_reg <= state_next;
		shift_type_reg <= shift_type_next;
		caps_num_reg   <= caps_num_next;
	    end
			
    // FSM next state logic
    always @(*)
	begin
	    // Defaults
	    got_code_tick   = 1'b0;
	    letter_case     = 1'b0;
	    caps_num_next   = caps_num_reg;
	    shift_type_next = shift_type_reg;
	    state_next      = state_reg;
	   
	    case(state_reg)
		// State to process lowercase key strokes, go to uppercase state to process shift/capslock
		lowercase:
		    begin  
			if(scan_done_tick)									// If scan code received
			    begin
				if(scan_out == SHIFT1 || scan_out == SHIFT2)		// If code is shift    
				    begin
					shift_type_next = scan_out;					// Record which shift key was pressed
					state_next = shift;							// Go to shift state
				    end
						    
				else if(scan_out == CAPS)						// If code is capslock
				    begin
					caps_num_next = 2'b11;					// Set caps_num to 3, num of capslock scan codes to receive before going back to lowecase
					state_next = capslock;						// Go to capslock state
				    end
	    
				else if (scan_out == BREAK)					// Else if code is break code
				    state_next = ignore_break;					// Go to ignore_break state
		     
				else											// Else if code is none of the above...            
				    got_code_tick = 1'b1;							// Assert got_code_tick to write scan_out to FIFO
			    end	
			end
		
		// State to ignore repeated scan code after break code FO received in lowercase state
		ignore_break:
		    begin
			if(scan_done_tick)				// If scan code received, 
			    state_next = lowercase;		// Go back to lowercase state
		    end
		
		// State to process scan codes after shift received in lowercase state
		shift:
		    begin
			letter_case = 1'b1;															// Routed out to convert scan code to upper value for a key
		       
			if(scan_done_tick)															// If scan code received,
			    begin
				if(scan_out == BREAK)													// If code is break code                                            
				    state_next = ignore_shift_break;										// Go to ignore_shift_break state to ignore repeated scan code after F0
	
				else if(scan_out != SHIFT1 && scan_out != SHIFT2 && scan_out != CAPS)		// Else if code is not shift/capslock
				    got_code_tick = 1'b1;													// Assert got_code_tick to write scan_out to FIFO
			    end
		    end
				    
		 // State to ignore repeated scan code after break code F0 received in shift state 
		 ignore_shift_break:
		     begin
			if(scan_done_tick)						    // If scan code received
			    begin
				if(scan_out == shift_type_reg)		    // If scan code is shift key initially pressed
				    state_next = lowercase;			    // Shift/capslock key unpressed, go back to lowercase state
				else								    // Else repeated scan code received, go back to uppercase state
				    state_next = shift;
			    end
		     end  
				    
		 // State to process scan codes after capslock code received in lowecase state
		 capslock:
		     begin
			letter_case = 1'b1;									    // Routed out to convert scan code to upper value for a key
					       
			if(caps_num_reg	== 0)							    // If capslock code received 3 times, 
			    state_next = lowercase;							    // Go back to lowecase state
						       
			if(scan_done_tick)									    // If scan code received
			    begin 
			    if(scan_out	== CAPS)							    // If code is capslock, 
				caps_num_next = caps_num_reg - 1;				    // Decrement caps_num
						       
			    else if(scan_out == BREAK)						    // Else if code is break, go to ignore_caps_break state
				state_next = ignore_caps_break;
						       
			    else if(scan_out != SHIFT1 && scan_out != SHIFT2)	    // Else if code isn't a shift key
				got_code_tick =	1'b1;						    // Assert got_code_tick to write scan_out to FIFO
			    end
		     end
				    
		     // State to ignore repeated scan code after break code F0 received in capslock state 
		     ignore_caps_break:
			 begin
			    if(scan_done_tick)							// If scan code received
				begin
				    if(scan_out	== CAPS)					// If code is capslock
					caps_num_next = caps_num_reg - 1;		// Decrement caps_num
				    state_next = capslock;					// Return to capslock state
				end
			 end    
	    endcase
	end
		
    // Output, route letter_case to output to use during scan to ascii code conversion
    assign letter_case_out = letter_case; 
	
    // Output, route got_code_tick to out control circuit to signal when to sample scan_out 
    assign scan_code_ready = got_code_tick;
	
    // Route scan code data out
    assign scan_code = scan_out;
	
endmodule

// Module modified from key2ascii by Joe Armitage & co
module key2ascii (
    input wire letter_case,
    input wire [7:0] scan_code,
    output reg [3:0] key
    );
    
    always @(*)
	begin
	    case(scan_code)
		/* Octave Above */
		8'h16: key = 4'd15;	// 1; Do (C5)
		8'h1e: key = 4'd16;	// 2; Re (D5)
		8'h26: key = 4'd17;	// 3; Mi (E5)
		8'h25: key = 4'd18;	// 4; Fa (F5)
		8'h2e: key = 4'd19;	// 5; So (G5)
		8'h36: key = 4'd20;	// 6; La (A5)
		8'h3d: key = 4'd21;	// 7; Ti (B5)
		
		/* Octave Middle */
		8'h15: key = 4'd8;		// q; Do (C4)
		8'h1d: key = 4'd9;		// w; Re (D4)
		8'h1d: key = 4'd10;	// e; Mi (E4)
		8'h2d: key = 4'd11;	// r; Fa (F4)
		8'h2c: key = 4'd12;	// t; So (G4)
		8'h35: key = 4'd13;	// y; La (A4)
		8'h3c: key = 4'd14;	// u; Ti (B4)
		
		/* Octave Below */
		8'h1c: key = 4'd1;		// a; Do (C3)
		8'h1b: key = 4'd2;	    	// s; Re (D3)
		8'h23: key = 4'd3;		// d; Mi (E3)
		8'h2b: key = 4'd4;		// f; Fa (F3)
		8'h34: key = 4'd5;		// g; So (G3)
		8'h33: key = 4'd6;		// h; La (A3)
		8'h3b: key = 4'd7;		// j; Ti (B3)
		  
		default: key = 4'd8; // default Do (C4)
	    endcase
	end
endmodule