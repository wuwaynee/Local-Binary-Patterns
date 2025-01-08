module VGA_CTRL(
	input clk, 
	input rst, 
	input [11:0] data_in,
	input [1:0]cmd,
	output reg hsync, 
	output reg vsync, 
	output  [3:0] vga_r, 
	output  [3:0] vga_g, 
	output  [3:0] vga_b,
	output valid,
	output valid_down,
	output reg ready
	);
    
	reg hs_data_en, vs_data_en;
	//reg [11:0] data_in;
	reg [9:0] hcount;
	reg [9:0] vcount;
	wire [19:0] G;
	
	reg [9:0] ready_count;
	/*
//400*300 72Hz
    parameter DATA_WIDTH=12;
    parameter H_Total = 528 - 1;
	parameter H_Sync = 64 - 1;
	parameter H_Back = 44 - 1;
	parameter H_Active = 400 - 1;
	parameter H_Front = 20 - 1;
	parameter H_Start = H_Sync + H_Back + 1;
	parameter H_End = H_Total - H_Front + 1;

	parameter V_Total = 314 - 1;
	parameter V_Sync = 2;
	parameter V_Back = 12 - 1;
	parameter V_Active = 300 - 1;
	parameter V_Front = 1;
	parameter V_Start = V_Sync + V_Back + 1;
	parameter V_End = V_Total - V_Front + 1;
	*/
	parameter DATA_WIDTH=12;
    parameter H_Total = 800 - 1;
	parameter H_Sync = 96 - 1;
	parameter H_Back = 48 - 1;
	parameter H_Active = 640 - 1;
	parameter H_Front = 16 - 1;
	parameter H_Start = 144 - 1;
	parameter H_End = 784 - 1;

	parameter V_Total = 449 - 1;
	parameter V_Sync = 2 - 1;
	parameter V_Back = 60 - 1;
	parameter V_Active = 350 - 1;
	parameter V_Front = 37 - 1;
	parameter V_Start = 62 - 1;
	parameter V_End = 412 -1 ;
	
/*
	parameter H_Total = 800 - 1;
	parameter H_Sync = 96 - 1;
	parameter H_Back = 48 - 1;
	parameter H_Active = 640 - 1;
	parameter H_Front = 16 - 1;
	parameter H_Start = 144 - 1;
	parameter H_End = 784 - 1;

	parameter V_Total = 525 - 1;
	parameter V_Sync = 2 - 1;
	parameter V_Back = 33 - 1;
	parameter V_Active = 480 - 1;
	parameter V_Front = 10 - 1;
	parameter V_Start = 35 - 1;
	parameter V_End = 515 - 1;
*/
    always@(posedge clk or posedge rst)begin
        if (rst ) begin
	       ready_count <= 0;
	       ready <= 0;
		end
		else begin
		  if (ready_count==10'b1111111111)begin
            ready <= 1;
          end
		  else begin
            ready_count <= ready_count + 1;
		  end
		end
    end
	always @(posedge clk or posedge rst) begin
		if (rst || !ready) begin
			hcount <= 0;
		end
		else  
		      if (hcount == H_Total) begin
                hcount <= 0;
              end
              else begin
                hcount <= hcount + 1;
            end
	   
	end

	always @(posedge clk or posedge rst) begin
		if (rst || !ready) begin
			vcount <= 0;
		end
		else if (vcount == V_Total) begin
			vcount <= 0;
		end
		else if (hcount == H_Total) begin
			vcount <= vcount + 1;
		end
		else begin
			vcount <= vcount;
		end
	end

	always @(posedge clk or posedge rst) begin
		if (rst || !ready) begin
			hsync <= 1;		
		end
		else if (hcount >= 0 && hcount < H_Sync) begin
			hsync <= 0;
		end
		else begin
			hsync <= 1;
		end
	end

	always @(posedge clk or posedge rst) begin
		if (rst || !ready) begin
			vsync <= 1;		
		end
		else if (vcount >= 0 && vcount < V_Sync) begin
			vsync <= 0;
		end
		else begin
			vsync <= 1;
		end
	end


	always @(posedge clk or posedge rst) begin
	    if(rst || !ready)
	        hs_data_en <= 1'b0;
	    else if(hcount >= H_Start && hcount < H_End)
	        hs_data_en <= 1'b1;
	    else
	        hs_data_en <= 1'b0;
	end

	always @(posedge clk or posedge rst) begin
	    if(rst || !ready)
	        vs_data_en <= 1'b0;
	    else if(vcount >= V_Start && vcount < V_End)
	        vs_data_en <= 1'b1;
	    else
	        vs_data_en <= 1'b0;
	end
    
    reg h_downsample_en;
    reg v_downsample_en;
    	always @(posedge clk or posedge rst) begin
	    if(rst || !ready)
	        h_downsample_en <= 1'b0;
	    else if(hcount >= H_Start+120 && hcount < H_End-120)
	        h_downsample_en <= 1'b1;
	    else
	        h_downsample_en <= 1'b0;
	end

	always @(posedge clk or posedge rst) begin
	    if(rst || !ready)
	        v_downsample_en <= 1'b0;
	    else if(vcount >= V_Start+25 && vcount < V_End-25)
	        v_downsample_en <= 1'b1;
	    else
	        v_downsample_en <= 1'b0;
	end
	assign valid_down = (h_downsample_en && v_downsample_en) ? 1 : 0;
	/*
	always @(*) begin
          if(hcount >= H_Start && hcount < H_Start + 80)
              data_in <= 12'hf00;
          else if(hcount >= H_Start + 80 && hcount < H_Start + 160)
              data_in <= 12'h0f0;
          else if(hcount >= H_Start + 160 && hcount < H_Start + 240)
              data_in <= 12'h00f;
          else if(hcount >= H_Start + 240 && hcount < H_Start + 320)
              data_in <= 12'hf0f;
          else if(hcount >= H_Start + 320 && hcount < H_Start + 400)
              data_in <= 12'hff0;
          else if(hcount >= H_Start + 400 && hcount < H_Start + 480)
              data_in <= 12'h0ff;
          else if(hcount >= H_Start + 480 && hcount < H_Start + 560)
              data_in <= 12'hfff;
          else if(hcount >= H_Start + 560 && hcount < H_Start + 640)
              data_in <= 12'h000;
          else
              data_in <= 12'hfff ;
        end
	*/

	/*assign vga_r = (hs_data_en && vs_data_en) ?  {data_in[7:5], 1'b0} : 0;
	assign vga_g = (hs_data_en && vs_data_en) ?  {data_in[4:2], 1'b0}  : 0;
	assign vga_b = (hs_data_en && vs_data_en) ?  {data_in[1:0], 2'b0}  : 0;*/
	assign valid = (hs_data_en && vs_data_en) ? 1 : 0;
	//assign G = (data_in[11:8]*19589) + (data_in[7:4]*38469) + (data_in[3:0]*7471);
	
    assign vga_r = (valid && valid_down) ?  {data_in[11:8]}  : 0;
    assign vga_g = (valid && valid_down) ?  {data_in[7:4]}  : 0;
    assign vga_b = (valid && valid_down) ?  {data_in[3:0]}  : 0;
	/*
	always@(*)begin
		case(cmd)
			2'b00:
			begin
				vga_r = (hs_data_en && vs_data_en) ?  {data_in[11:8]}  : 0;
				vga_g = (hs_data_en && vs_data_en) ?  {data_in[7:4]}  : 0;
				vga_b = (hs_data_en && vs_data_en) ?  {data_in[3:0]}  : 0;
				//valid = (hs_data_en && vs_data_en) ? 1 : 0;
			end
			2'b01:
			begin
				vga_r = (hs_data_en && vs_data_en) ? G>>16 : 0;
				vga_g = (hs_data_en && vs_data_en) ? G>>16 : 0;
				vga_b = (hs_data_en && vs_data_en) ? G>>16 : 0;
				//valid = (hs_data_en && vs_data_en) ? 1 : 0;
			end
			2'b10:
			begin
				vga_r = (hs_data_en && vs_data_en) ?  {data_in[11:8]}  : 0;
				vga_g = (hs_data_en && vs_data_en) ?  {data_in[7:4]}  : 0;
				vga_b = (hs_data_en && vs_data_en) ?  {data_in[3:0]}  : 0;
				//valid = (hs_data_en && vs_data_en) ? 1 : 0;
			end
			2'b11:
			begin
				vga_r = (hs_data_en && vs_data_en) ?  {data_in[11:8]}  : 0;
				vga_g = (hs_data_en && vs_data_en) ?  {data_in[7:4]}  : 0;
				vga_b = (hs_data_en && vs_data_en) ?  {data_in[3:0]}  : 0;
			end
			default:
			begin
				vga_r = (hs_data_en && vs_data_en) ?  {data_in[11:8]}  : 0;
				vga_g = (hs_data_en && vs_data_en) ?  {data_in[7:4]}  : 0;
				vga_b = (hs_data_en && vs_data_en) ?  {data_in[3:0]}  : 0;
			end
		endcase
    end*/
	
endmodule