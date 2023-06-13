module read_address_gen #(parameter ADDR_WIDTH =5) (input r_clk,input r_en,input [ADDR_WIDTH:0] sync_write_ptr,input reset, output reg r_empty,output [ADDR_WIDTH-1:0] r_address,output reg [ADDR_WIDTH:0] r_ptr);

reg [ADDR_WIDTH:0] r_bin_ptr; // extra bit to differentiate empty and full conditions
wire temp_empty;
wire [ADDR_WIDTH:0] r_gray_ptr_next, r_bin_ptr_next;

always @(posedge r_clk, posedge reset)
	if (reset)
    	{r_bin_ptr, r_ptr} <= 0;
	else
		{r_bin_ptr, r_ptr} <= {r_bin_ptr_next, r_gray_ptr_next};
		
assign r_address = r_bin_ptr[ADDR_WIDTH-1:0];
assign r_bin_ptr_next = r_bin_ptr + (r_en & ~r_empty); // increment pointer only if read enable is on and memory is not empty
assign r_gray_ptr_next = (r_bin_ptr_next>>1) ^ r_bin_ptr_next; // binary to grey code
assign temp_empty = (r_gray_ptr_next == sync_write_ptr); // if read at: 000000 and write at: 000000 then memory is empty

always @(posedge r_clk,posedge reset)
	if (reset)
		r_empty <= 1'b1;
	else
    	r_empty <= temp_empty;

endmodule