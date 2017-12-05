// A full memory hierarchy. 
//
// Parameter:
// MODEL_NUMBER: A number used to specify a specific instance of the memory.  Different numbers give different hierarchies and settings.
//   This should be set to your student ID number.
// DMEM_ADDRESS_WIDTH: The number of bits of address for the memory.  Sets the total capacity of main memory.
//
// Accesses: To do an access, set address, data_in, byte_access, and write to a desired value, and set start_access to 1.
//   All these signals must be held constant until access_done, at which point the operation is completed.  On a read,
//   data_out will be set to the correct data for the single cycle when access_done is true.  Note that you can do
//   back-to-back accesses - when access_done is true, if you keep start_access true the memory will start the next access.
// 
//   When start_access = 0, the other input values do not matter.
//   bytemask controls which bytes are actually written (ignored on a read).
//     If bytemask[i] == 1, we do write the byte from data_in[8*i+7 : 8*i] to memory at the corresponding position.  If == 0, that byte not written.
//   To do a read: write = 0,  data_in does not matter.  data_out will have the proper data for the single cycle where access_done==1.
//   On a write, write = 1 and data_in must have the data to write.
//
//   Addresses must be aligned.  Since this is a 64-bit memory (8 bytes), the bottom 3 bits of each address must be 0.
//
//   It is an error to set start_access to 1 and then either set start_access to 0 or change any other input before access_done = 1.
//
//   Accessor tasks (essentially subroutines for testbenches) are provided below to help do most kinds of accesses.

// Line to set up the timing of simulation: says units to use are ns, and smallest resolution is 10ps.
`timescale 1ns/10ps

module lab5 #(parameter [22:0] MODEL_NUMBER = 1350364, parameter DMEM_ADDRESS_WIDTH = 20) (
	// Commands:
	//   (Comes from processor).
	input		logic [DMEM_ADDRESS_WIDTH-1:0]	address,			// The byte address.  Must be word-aligned if byte_access != 1.
	input		logic [63:0]							data_in,			// The data to write.  Ignored on a read.
	input		logic [7:0]								bytemask,		// Only those bytes whose bit is set are written.  Ignored on a read.
	input		logic										write,			// 1 = write, 0 = read.
	input		logic										start_access,	// Starts a memory access.  Once this is true, all command inputs must be stable until access_done becomes 1. 
	output	logic										access_done,	// Set to true on the clock edge that the access is completed.
	output	logic	[63:0]							data_out,		// Valid when access_done == 1 and access is a read.
	// Control signals:
	input		logic										clk,
	input		logic										reset				// A reset will invalidate all cache entries, and return main memory to the default initial values.
); 
	
	DataMemory #(.MODEL_NUMBER(MODEL_NUMBER), .DMEM_ADDRESS_WIDTH(DMEM_ADDRESS_WIDTH)) dmem
		(.address, .data_in, .bytemask, .write, .start_access, .access_done, .data_out, .clk, .reset);
	
	always @(posedge clk)
		assert(reset !== 0 || start_access == 0 || address[2:0] == 0); // All accesses must be aligned.
	
endmodule

// Test the data memory, and figure out the settings.

module lab5_testbench ();
	localparam USERID = 1522698;  // Set to your student ID #
	localparam ADDRESS_WIDTH = 20;
	localparam DATA_WIDTH = 8;
	
	logic [ADDRESS_WIDTH-1:0]			address;		   // The byte address.  Must be word-aligned if byte_access != 1.
	logic [63:0]							data_in;			// The data to write.  Ignored on a read.
	logic [7:0]								bytemask;		// Only those bytes whose bit is set are written.  Ignored on a read.
	logic										write;			// 1 = write, 0 = read.
	logic										start_access;	// Starts a memory access.  Once this is true, all command inputs must be stable until access_done becomes 1. 
	logic										access_done;	// Set to true on the clock edge that the access is completed.
	logic	[63:0]							data_out;		// Valid when access_done == 1 and access is a read.
	// Control signals:
	logic										clk;
	logic										reset;				// A reset will invalidate all cache entries, and return main memory to the default initial values.

	lab5 #(.MODEL_NUMBER(USERID), .DMEM_ADDRESS_WIDTH(ADDRESS_WIDTH)) dut
		(.address, .data_in, .bytemask, .write, .start_access, .access_done, .data_out, .clk, .reset); 

	// Set up the clock.
	parameter CLOCK_PERIOD=10;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 5, " ns", 10);

	// --- Keep track of number of clock cycles, for statistics.
	integer cycles;
	always @(posedge clk) begin
		if (reset)
			cycles <= 0;
		else
			cycles <= cycles + 1;
	end
		
	// --- Tasks are subroutines for doing various operations.  These provide read and write actions.
	
	// Set memory controls to an idle state, no accesses going.
	task mem_idle;
		address			<= 'x;
		data_in			<= 'x;
		bytemask			<= 'x;
		write				<= 'x;
		start_access	<= 0;
		#1;
	endtask
	
	// Perform a read, and return the resulting data in the read_data output.
	// Note: waits for complete cycle of "access_done", so spends 1 cycle more than the access time.
	task readMem;
		input		[ADDRESS_WIDTH-1:0]		read_addr;
		output	[DATA_WIDTH-1:0][7:0]	read_data;
		output	int							delay;		// Access time actually seen.
		
		int startTime, endTime;
		
		startTime = cycles;
		address			<= read_addr;
		data_in			<= 'x;
		bytemask			<= 'x;
		write				<= 0;
		start_access	<= 1;
		@(posedge clk);
		while (~access_done) begin
			@(posedge clk);
		end
		mem_idle(); #1;
		read_data = data_out;
		endTime = cycles;
		delay = endTime - startTime - 1;
	endtask
	
	function int min;
		input int x;
		input int y;
		
		min = ((x<y) ? x : y);
	endfunction
	function int max;
		input int x;
		input int y;
		
		max = ((x>y) ? x : y);
	endfunction
	
	// Perform a series of reads, and returns the min and max access times seen.
	// Accesses are at read_addr, read_addr+stride, read_addr+2*stride, ... read_addr+(num_reads-1)*stride.
	task readStride;
		input		[ADDRESS_WIDTH-1:0]		read_addr;
		input		int							stride;
		input		int							num_reads;
		output	int							min_delay;	// Fastest access time actually seen.
		output	int							max_delay;	// Slowest access time actually seen.
		
		int i, delay;
		logic [DATA_WIDTH-1:0][7:0]		read_data;
		
		//$display("%t readStride(%d, %d, %d)", $time, read_addr, stride, num_reads);
		readMem(read_addr, read_data, delay);
		min_delay = delay;
		max_delay = delay;
		//$display("1  delay: %d", delay);
		
		for(i=1; i<num_reads; i++) begin
			readMem(read_addr+stride*i, read_data, delay);
			min_delay = min(min_delay, delay);
			max_delay = max(max_delay, delay);
			//$display("2  delay: %d", delay);
		end
		//$display("%t min_delay: %d max_delay: %d", $time, min_delay, max_delay);

		mem_idle(); #1;
	endtask
	
	// Perform a write.
	// Note: waits for complete cycle of "access_done", so spends 1 cycle more than the access time.
	task writeMem;
		input [ADDRESS_WIDTH-1:0]			write_address;
		input [DATA_WIDTH-1:0][7:0]		write_data;
		input [DATA_WIDTH-1:0]				write_bytemask;
		output	int							delay;		// Access time actually seen.
		
		int	startTime, endTime;
		
		startTime = cycles;
		address			<= write_address;
		data_in			<= write_data;
		bytemask			<= write_bytemask;
		write				<= 1;
		start_access	<= 1;
		@(posedge clk);
		while (~access_done) begin
			@(posedge clk);
		end
		mem_idle(); #1;
		endTime = cycles;
		delay = endTime - startTime - 1;
	endtask
	
	// Perform a series of writes, and returns the min and max access times seen.
	// Accesses are at write_addr, write_addr+stride, write_addr+2*stride, ... write_addr+(num_writes-1)*stride.
	task writeStride;
		input		[ADDRESS_WIDTH-1:0]		write_addr;
		input		int							stride;
		input		int							num_writes;
		output	int							min_delay;	// Fastest access time actually seen.
		output	int							max_delay;	// Slowest access time actually seen.
		
		int i, delay;
		logic [DATA_WIDTH-1:0][7:0]		write_data;
		
		//$display("%t writeStride(%d, %d, %d)", $time, write_addr, stride, num_writes);
		writeMem(write_addr, write_data, 8'hFF, delay);
		min_delay = delay;
		max_delay = delay;
		//$display("1  delay: %d", delay);
		
		for(i=1; i<num_writes; i++) begin
			writeMem(write_addr+stride*i, write_data, 8'hFF, delay);
			min_delay = min(min_delay, delay);
			max_delay = max(max_delay, delay);
			//$display("2  delay: %d", delay);
		end
		//$display("%t min_delay: %d max_delay: %d", $time, min_delay, max_delay);

		mem_idle(); #1;
	endtask
	
	// Skip doing an access for a cycle.
	task noopMem;
		mem_idle();
		@(posedge clk); #1;
	endtask
	
	// Reset the memory.
	task resetMem;
		mem_idle();
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		#1;
	endtask
	
	logic	[DATA_WIDTH-1:0][7:0]	dummy_data;
	logic [ADDRESS_WIDTH-1:0]		addr, addr2;
	int	i, n, s, delay, minval, maxval;
	initial begin
		dummy_data <= '0;
		resetMem();				// Initialize the memory.
		
		// Do 20 random reads.
		//for (i=0; i<20; i++) begin
		//addr = $random()*8; // *8 to doubleword-align the access.
		//readMem(addr, dummy_data, delay);
		//$display("%t Read took %d cycles", $time, delay);
		//end

/*
		// L1 associativity check
		addr = 20'b0000000000000_000_0000;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		addr = 20'b0000000000001_000_0000;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		addr = 20'b0000000000000_000_0000;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
*/
		n = 65;
		s = 64;
		for (i=0; i<n; i++) begin
		addr = i*s; // *8 to doubleword-align the access.
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles %d@i", $time, addr, delay, i);
		end
/*
		addr = 20'd256;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
*/
		for (i=0; i<n; i++) begin
		addr = i*s; // *8 to doubleword-align the access.
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles %d@i", $time, addr, delay, i);
		end
/*
		addr = 128;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
*/
/*
		addr = 20'd256;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		addr = 20'd128;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		addr = 20'd256;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
*/
/*
		// L2 associativity check
		addr = 20'b00000000000_000_10000;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		addr = 20'b00000000000_000_10000;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		addr = 20'b00000000001_000_10000;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		addr = 20'b00000000000_000_10000;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		readMem(addr, dummy_data, delay);
*/
/*		// Blocksize check for L1
		for (i=0; i<9; i++) begin
		addr = i*16; // *8 to doubleword-align the access.
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		end
		addr2 = 0;
		readMem(addr2, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr2, delay);
		readMem(addr2, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr2, delay);


		// Blocksize check for L2 
*/
/*		for (i=0; i<31; i++) begin
		addr = i*16; // *8 to doubleword-align the access.
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		end
		addr = 511;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);

		/*for (i=8; i<16; i++) begin
		addr = i*16; // *8 to doubleword-align the access.
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);
		end
		addr = 0;
		readMem(addr, dummy_data, delay);
		$display("%t %d Read took %d cycles", $time, addr, delay);

		// Do 5 random double-word writes of random data.
		for (i=0; i<5; i++) begin
			addr = $random()*8; // *8 to doubleword-align the access.
			dummy_data = $random();
			writeMem(addr, dummy_data, 8'hFF, delay);
			$display("%t Write took %d cycles", $time, delay);
		end
		*/
		// Reset the memory.
		resetMem();
		
		// Read all of the first KB
		readStride(0, 8, 1024/8, minval, maxval);
		$display("%t Reading the first KB took between %d and %d cycles each", $time, minval, maxval);

		$stop();
	end
	
endmodule
