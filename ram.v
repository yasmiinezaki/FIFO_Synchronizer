module ram #(parameter ADDR_WIDTH =5, DATA_WIDTH=8)(output [DATA_WIDTH-1:0] data_out,input [DATA_WIDTH-1:0] data_in,input wr_clk, input write_enable,input read_enable,input [ADDR_WIDTH-1:0] write_addr,input [ADDR_WIDTH-1:0] read_addr,input wr_full);
parameter RAM_DEPTH = 1 << ADDR_WIDTH; //(2^Address_width)
reg[DATA_WIDTH-1 : 0] ram [0:RAM_DEPTH-1];

// write in memory
always @(posedge wr_clk)
	if(write_enable && !wr_full)
		ram[write_addr] <= data_in;

assign data_out = (read_enable)? ram[read_addr]: 8'bz; // read from memory if read_enable is 1

endmodule 