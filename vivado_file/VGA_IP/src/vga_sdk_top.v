module VGA_TOP(
	input clk_25mHz,
	input rst, 
	input [11:0]data_in,
	output vga_hs, 
	output vga_vs, 
	output [3:0] vga_r, 
	output [3:0] vga_g, 
	output [3:0] vga_b,
	output reg [18:0] addr,
	input all_ready
);

//wire [9:0] hcount, vcount;
wire valid;
//wire ready;
wire valid_down;
//reg [18:0] addr;
//wire [7:0] dout;
//reg [9:0]x;
//reg [8:0]y;

VGA_CTRL vga_ctrl_0(
	.clk(clk_25mHz), 
	.rst(rst), 
	.data_in(data_in),
	.hsync(vga_hs), 
	.vsync(vga_vs), 
	.vga_r(vga_r), 
	.vga_g(vga_g), 
	.vga_b(vga_b),
	.valid(valid),
	.all_ready(all_ready),
	.valid_down(valid_down)
	);

/*clk_wiz_0 clk_wiz_0_0(
		.clk_in1(clk),
		.clk_out1(clk_25mHz),
		.reset(1'b0)
	);
	
blk_mem_gen_0 blk_mem_gen0(
    .addra(addr),
    .clka(clk_25mHz),
    .douta(dout)
);*/
always @(posedge clk_25mHz or posedge rst) begin
	if (rst || !all_ready) begin
		addr <= 0;
	end
	else if (valid_down) begin
		if(addr == 120000-1)
		  addr <= 0;
		else
		  addr <= addr + 1;
	end
	else begin
		addr <= addr;
	end
end
/*
always@(posedge clk_25mHz or posedge rst)
begin
    if(rst || !ready)
    begin
		if(cmd==3)
			addr<=639;
		else
			addr<=0;
    end
    else if(valid ==1)
    begin
		if(cmd==2)
			addr<=(addr == 224000-2)?0:addr+2;
		else if(cmd==3)
			addr<=(addr == 224000-640)?639:(addr%640==0)?addr+1279:addr-1;
		else
			addr<=(addr == 224000-1)?0:addr+1;		
    end
    else
    begin
        addr<=addr;
    end
end
*/
/*
always@(posedge clk_25mHz or posedge rst)
begin
	if(rst)
	begin
		if(cmd==3)
		begin
			x<=639;
			y<=0;
		end
		else
		begin
			x<=0;
			y<=0;
		end
	end
	else if(valid==1)
	begin
		if(cmd==3)
		begin
			x<=(addr == 306560)?639:(x==0)?639:x-1;
			y<=(addr == 306560)?0:(y==479)?0:(x==0)?y+1:y;
		end
		else if(cmd==2)
		begin
			x<=(addr == 306558)?0:(x==638)?0:x+2;
			y<=(addr == 306558)?0:(y==478)?0:(x==638)?y+2:y;
		end
		else
		begin
			x<=(addr == 307200-1)?0:(x==639)?0:x+1;
			y<=(addr == 307200-1)?0:(y==479)?0:(x==639)?y+1:y;
		end
	end
end

assign addr = (y*640)+x;
*/
endmodule