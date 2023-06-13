// synchronizing using 2 flipflops with the other clocks
module wr_ptr_synchronizer #(parameter ADDR_WIDTH =5) (input reset, input r_clk, input [ADDR_WIDTH:0] wr_ptr,output reg [ADDR_WIDTH:0] sync_write_ptr);

reg [ADDR_WIDTH:0] temp;

always @(posedge r_clk,posedge reset)
begin
	if (reset)
	 begin
		temp <= 0;
		sync_write_ptr <= 0;
	 end
	else
	 begin
		temp <= wr_ptr;
		sync_write_ptr <= temp;
	 end
end

endmodule