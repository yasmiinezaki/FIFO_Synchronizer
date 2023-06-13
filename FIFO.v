module FIFO #(parameter ADDR_WIDTH =5, DATA_WIDTH=8) (output [DATA_WIDTH-1:0] data_out, input [DATA_WIDTH-1:0] data_in, input clk_read, input clk_write,input Wr_enable,input Read_enable,input reset);

wire [ADDR_WIDTH:0] wr_ptr;
wire [ADDR_WIDTH:0] r_ptr;
wire [ADDR_WIDTH-1:0] write_addr;
wire [ADDR_WIDTH-1:0] read_addr;
wire wr_full;
wire r_empty;
wire [ADDR_WIDTH:0] sync_read_ptr;
wire [ADDR_WIDTH:0] sync_write_ptr;

ram #(ADDR_WIDTH, DATA_WIDTH) inst0(data_out,data_in,clk_write,Wr_enable,Read_enable,write_addr,read_addr,wr_full);
r_ptr_synchronizer #(ADDR_WIDTH) inst1 (reset,clk_write, r_ptr, sync_read_ptr);
wr_ptr_synchronizer #(ADDR_WIDTH) inst2 (reset,clk_read, wr_ptr, sync_write_ptr);
read_address_gen #(ADDR_WIDTH) inst3 (clk_read,Read_enable,sync_write_ptr,reset,r_empty,read_addr,r_ptr);
write_address_gen #(ADDR_WIDTH) inst4 (clk_write,Wr_enable,sync_read_ptr,reset,wr_full,write_addr,wr_ptr);

endmodule