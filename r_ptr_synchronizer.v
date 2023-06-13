module r_ptr_synchronizer #(parameter ADDR_WIDTH =5) (input reset,input wr_clk, input [ADDR_WIDTH:0] r_ptr,output reg [ADDR_WIDTH:0] sync_read_ptr);

reg [ADDR_WIDTH:0] temp;

always @(posedge wr_clk,posedge reset)
	if (reset)
		begin
			temp <= 0;
			sync_read_ptr <= 0;
		end
	else
		begin
			temp <= r_ptr;
			sync_read_ptr <= temp;
	end

endmodule