module write_address_gen #(parameter ADDR_WIDTH =5) (input wr_clk,input Wr_en,input [ADDR_WIDTH:0] sync_read_ptr,input reset, output reg Wr_full,output [ADDR_WIDTH-1:0] wr_address,output reg [ADDR_WIDTH:0] wr_ptr);

reg [ADDR_WIDTH:0] wr_bin_ptr;
wire temp_full;
wire [ADDR_WIDTH:0] wr_gray_ptr_next, wr_bin_ptr_next;

always @(posedge wr_clk,posedge reset)
	if (reset)
		{wr_bin_ptr, wr_ptr} <= 0;
	else
		{wr_bin_ptr, wr_ptr} <= {wr_bin_ptr_next, wr_gray_ptr_next};
	
assign wr_address = wr_bin_ptr[ADDR_WIDTH-1:0];
assign wr_bin_ptr_next = wr_bin_ptr + (Wr_en & ~Wr_full); // will increment by 1 as long as enable is 1 and full is 0
assign wr_gray_ptr_next = (wr_bin_ptr_next>>1) ^ wr_bin_ptr_next; // binary to gray code
assign temp_full = (wr_gray_ptr_next=={~sync_read_ptr[ADDR_WIDTH:ADDR_WIDTH-1], sync_read_ptr[ADDR_WIDTH-2:0]});
// if read_ptr is at 000000 and write_ptr is at 100000
// grey code is 000000 and 110000
// so 110000 == {~(00),0000} is fifo is full

always @(posedge wr_clk,posedge reset)
    if (reset)
		Wr_full <= 1'b0;
	 else
	    Wr_full <= temp_full;

endmodule