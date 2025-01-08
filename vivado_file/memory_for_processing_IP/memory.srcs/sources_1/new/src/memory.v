module	memory_for_processing#(
    parameter DATA_WIDTH = 12,
    parameter ADDR_WIDTH = 19,
    parameter DATA_LENGTH = 120000
    )
    (
	input 			clk,
	input           rst,
	input 			[ADDR_WIDTH-1:0]	addr_from_VGA,
	input 			[ADDR_WIDTH-1:0]	i_addr,
	input 			[DATA_WIDTH-1:0]	data_in,
	output 	 reg    [DATA_WIDTH-1:0]	data_out,
	input           input_valid
);

reg		[DATA_WIDTH-1:0]	img_memory	[DATA_LENGTH-1:0];

/*
always@(cmd)begin
    if(cmd[0] | cmd[1] | cmd[2] | cmd[3])
        done = 0;
    else if
end
*/
always@(posedge clk)begin
    if(input_valid)begin
        img_memory[i_addr] <= data_in;
    end

end


// Output data

always@(posedge clk)begin
    
   data_out	<= img_memory[addr_from_VGA];

end

endmodule






