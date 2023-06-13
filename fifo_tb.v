
module fifo_tb();


wire [7:0] data_out;
reg [7:0] data_in;
reg read_clk;
reg write_clk;
reg Wr_enable;
reg Read_enable;
reg reset;

integer i;
integer failed_test_count;


localparam T = 150;
localparam clock_period=100;

initial begin
	read_clk = 0;
	forever
		#(clock_period/4) read_clk = ~read_clk;
end

initial begin
	write_clk = 0;
	forever
		#(clock_period/2) write_clk = ~write_clk;
end

FIFO #(5,8) inst (data_out,data_in,read_clk,write_clk,Wr_enable,Read_enable,reset);

initial begin
	$monitor ("%h      %h\t",data_in,data_out);
	failed_test_count = 0;
	
	reset =1;
	Wr_enable = 1'b0;
	Read_enable = 1'b0;
	#(T)
	reset =0;
	// read while fifo is empty
	Read_enable = 1'b1;
	#(T)
	if(data_out != 8'bx) begin
		$display("Expected Output: %h, Actual Output: %h\n",8'bz,data_out);
		failed_test_count = failed_test_count+1;
	end
	// write 2 times,read 2 times
	data_in = 8'b00000000;
	Wr_enable = 1'b1;
	Read_enable = 1'b0;
	#(T)
	data_in = 8'b01010101;
	#(T)
	Wr_enable = 1'b0;
	Read_enable = 1'b1;	
	if(data_out != 8'b00000000) begin
		$display("Test Input: %hExpected Output: %h, Actual Output: %h\n",8'b00000000,8'b00000000,data_out);
		failed_test_count = failed_test_count+1;
	end
	#(2*T)
	if(data_out != 8'b01010101) begin
		$display("Test Input: %hExpected Output: %h, Actual Output: %h\n",8'b01010101,8'b01010101,data_out);
		failed_test_count = failed_test_count+1;
	end
	// read from empty fifo
	#(T)
	if(data_out != 8'bx) begin
		$display("Expected Output: %h, Actual Output: %h\n",8'bz,data_out);
		failed_test_count = failed_test_count+1;
	end
	
	// write until full
	Wr_enable = 1'b1;
	Read_enable = 1'b0;
	for(i = 0; i< 32; i = i+1)
	begin
		#(T)
		data_in = $random;
	end
	// read until empty
	Wr_enable = 1'b0;
	Read_enable = 1'b1;
	#(32*T)
	if (failed_test_count ==0) $display("All Tests succeeded\n", i);
	else
	$display("failed test count: %d\n",failed_test_count);
	$finish;
end
endmodule