module image_processor#(
           parameter DATA_WIDTH = 12,
           parameter ADDR_WIDTH = 19,
           parameter DATA_LENGTH = 120000
       )(
           input           clk_p,
           input           rst,
           output 	 reg	[ADDR_WIDTH-1:0]	w_addr,
           output   reg    [ADDR_WIDTH-1:0]    o_addr,
           input 			[DATA_WIDTH-1:0]	data_in,
           output 	 reg	[DATA_WIDTH-1:0]	data_out,
           output   reg    output_valid,
           input           [1:0]               cmd,
           output   reg all_ready
       );
/************parameter description:******************************************************************************
   *    1. Read data from "bram IP" ,which contains the image data from SDK
   *        w_addr : assign address to bram_IP
   *        data_in : after assigning the parameter w_addr, you'll get the corrresponding data from bram_IP
   *        
   *    2. Write data to "memory_for_prcossing IP"
   *        output_valid : Let 'output_valid' be "High" when you want to output data
   *        o_addr :  assign address to "memory_for_prcossing IP"
   *        data_out : output the corresponding pixel value
   *       
   *    3. Control 
   *        cmd : you can use this parameter to decide what image_processing method you want to use
   ********************************************************************************************************/

reg [9:0] ready_count;
reg ready;

/* Init System */
always@(posedge clk_p or posedge rst)
begin
    if (rst)
    begin
        ready_count <= 0;
        ready <= 0;
    end
    else
    begin
        if (ready_count==10'b1111111111)
        begin
            ready <= 1;
        end
        else
        begin
            ready_count <= ready_count + 1;
        end
    end
end
reg [3:0] state, nxt_state;
localparam
    Idle = 4'd0,
    CENTER_POSITION_READ=4'd1,
    GC_SAVE=4'd2,
    LBP_POSITION_READ=4'd3,
    LBP_CALCULATE=4'd4,
    LBP_WRITE=4'd5,
    CENTER_POSITION_ADD=4'd6,
    Finish = 4'd7,
    Process = 4'd8;

//reg [11:0] pel_out;
reg [13:0] center;
reg [2:0] counter;
reg [7:0] gc;

/* Next-state logic */
always @(*)
begin
    case (state)
        Idle:
        begin
            if (ready)
                nxt_state = CENTER_POSITION_READ;
        end
        CENTER_POSITION_READ:
        begin
            if(center%300==9'd0 || center%300==9'd299)
            begin
                nxt_state=CENTER_POSITION_ADD;
            end
            else
            begin
                nxt_state=GC_SAVE;
            end
        end
        GC_SAVE:
        begin
            nxt_state=LBP_POSITION_READ;
        end
        LBP_POSITION_READ:
        begin
            nxt_state=LBP_CALCULATE;
        end
        LBP_CALCULATE:
        begin
            if(counter==3'd7)
            begin
                nxt_state=LBP_WRITE;
            end
            else
            begin
                nxt_state=LBP_POSITION_READ;
            end
        end
        LBP_WRITE:
        begin
            nxt_state=CENTER_POSITION_ADD;
        end
        CENTER_POSITION_ADD:
        begin
            if (o_addr == DATA_LENGTH-1)
                nxt_state = Finish;
            else
                nxt_state=CENTER_POSITION_READ;
        end
        Process:
            nxt_state=LBP_WRITE;
        default:
        begin
            nxt_state=CENTER_POSITION_READ;
        end

    endcase
end

/* FSM */
// always @(posedge clk_p or posedge rst)
// begin
//     if (rst)
//         state <= Idle;
//     else
//         state <= nxt_state;
// end

/* Processing */
always @(posedge clk_p or posedge rst)
begin
    if(rst)
    begin
        output_valid <= 0;
        w_addr <= 0;
        o_addr <= 19'b111_1111_1111_1111_1111;
        data_out <= 0;
        all_ready <= 0;
        state <= Idle;
        center <= 14'd301;
        counter<=3'd0;
        gc<=8'd0;
    end
    else
    begin
        state <= nxt_state;
        case(state)
            CENTER_POSITION_READ:
            begin
                output_valid <= 0;
                data_out <= 0;
                w_addr<=center;
            end
            GC_SAVE:
            begin
                gc<=data_in[3:0];
            end
            LBP_POSITION_READ:
            begin
                case(counter)
                    3'd0:	//g0
                    begin
                        w_addr<=center-14'd301;
                    end
                    3'd1:	//g1
                    begin
                        w_addr<=center-14'd300;
                    end
                    3'd2:	//g2
                    begin
                        w_addr<=center-14'd299;
                    end
                    3'd3:	//g3
                    begin
                        w_addr<=center-14'd1;
                    end
                    3'd4:	//g4
                    begin
                        w_addr<=center+14'd1;
                    end
                    3'd5:	//g5
                    begin
                        w_addr<=center+14'd299;
                    end
                    3'd6:	//g6
                    begin
                        w_addr<=center+14'd300;
                    end
                    3'd7:	//g7
                    begin
                        w_addr<=center+14'd301;
                    end
                endcase
            end
            LBP_CALCULATE:
            begin
                counter<=counter+3'd1;
                case(counter)
                    3'd0:	//g0
                    begin
                        if(data_in[3:0]>=gc)
                        begin
                            data_out<=data_out+12'd1;
                        end
                    end
                    3'd1:	//g1
                    begin
                        if(data_in[3:0]>=gc)
                        begin
                            data_out<=data_out+12'd2;
                        end
                    end
                    3'd2:	//g2
                    begin
                        if(data_in[3:0]>=gc)
                        begin
                            data_out<=data_out+12'd4;
                        end
                    end
                    3'd3:	//g3
                    begin
                        if(data_in[3:0]>=gc)
                        begin
                            data_out<=data_out+12'd8;
                        end
                    end
                    3'd4:	//g4
                    begin
                        if(data_in[3:0]>=gc)
                        begin
                            data_out<=data_out+12'd16;
                        end
                    end
                    3'd5:	//g5
                    begin
                        if(data_in[3:0]>=gc)
                        begin
                            data_out<=data_out+12'd32;
                        end
                    end
                    3'd6:	//g6
                    begin
                        if(data_in[3:0]>=gc)
                        begin
                            data_out<=data_out+12'd64;
                        end
                    end
                    3'd7:	//g7
                    begin
                        if(data_in[3:0]>=gc)
                        begin
                            data_out<=data_out+12'd128;
                        end
                    end
                endcase
            end
            Process:
            begin
                case(cmd)
                    0:
                    begin
                        data_out[11:8] <= data_out[3:0];
                        data_out[7:4] <= data_out[3:0];
                        data_out[3:0] <= data_out[3:0];
                    end
                    1:
                    begin
                        data_out[11:8] <= 15;
                        data_out[7:4] <= 15;
                        data_out[3:0] <= 15;
                    end
                    2:
                    begin
                        data_out[11:8] <= data_out[3:0] << 1;
                        data_out[7:4] <= data_out[3:0] << 1;
                        data_out[3:0] <= data_out[3:0] << 1 ;
                    end
                    3:
                    begin
                        data_out[11:8] <= data_out[11:8];
                        data_out[7:4] <= data_out[7:4];
                        data_out[3:0] <= data_out[3:0];
                    end
                endcase
            end
            LBP_WRITE:
            begin
                output_valid<=1'd1;
                //data_out <= pel_out;
                o_addr<=center;
            end
            CENTER_POSITION_ADD:
            begin
                center<=center+14'd1;
            end
            Finish:
            begin
                all_ready <= 1;
            end
        endcase
    end
end

endmodule
