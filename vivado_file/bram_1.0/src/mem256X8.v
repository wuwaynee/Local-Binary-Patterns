module	mem #(
	parameter DATA_WIDTH = 12,
	parameter ADDR_WIDTH = 19
	)(
	input 			w_clk,
	input			r_clk,
	input 			write_enable,
	input 			[DATA_WIDTH-1:0]	data_in,
	input 			[ADDR_WIDTH-1:0]	w_addr,
	input 			[ADDR_WIDTH-1:0]	r_addr,
	output 	 reg	[DATA_WIDTH-1:0]	data_out,
	output output_ready
);

reg		[DATA_WIDTH-1:0]	mem	[120000-1:0];
always@(posedge w_clk)begin
	if(write_enable)
		mem[w_addr]	<=	data_in;
	end


always@(posedge r_clk)begin
		data_out	<=	mem[r_addr];
	end


endmodule
