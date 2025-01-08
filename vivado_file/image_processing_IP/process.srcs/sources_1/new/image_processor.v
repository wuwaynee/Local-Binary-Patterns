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
    always@(posedge clk_p or posedge rst)begin
        if (rst) begin
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
    reg [2:0] state, nxt_state;
    localparam
    Idle = 0,
    Read = 1,
    Process = 2,
    Write = 3,
    Finish = 4;

    reg [11:0] pel_out;
    
    /* Next-state logic */
    always @(*) begin
        nxt_state = state;
        case (state)
            Idle: 
                if (ready) nxt_state = Read;
            Read: nxt_state = Process;
            Process: nxt_state = Write;
            Write: 
                if (o_addr == DATA_LENGTH-1) nxt_state = Finish;
                else nxt_state = Read;
        endcase
    end

    /* FSM */
    always @(posedge clk_p or posedge rst) begin
        if (rst) state <= Idle;
        else state <= nxt_state;
    end
    
    /* Processing */
    always @(posedge clk_p or posedge rst) begin
        if(rst)begin
            output_valid <= 0;
            w_addr <= 0;
            o_addr <= 19'b111_1111_1111_1111_1111;
            all_ready <= 0;
        end
        else begin
            output_valid <= 0;
            case(state)
                Read: begin
                    pel_out <= data_in;
                    w_addr <= w_addr + 1; 
                end
                Process: begin 
                    case(cmd)
                        1: begin
                            pel_out[11:8] <= 15;
                            pel_out[7:4] <= 15;
                            pel_out[3:0] <= 15;
                        end
                        2: begin
                            pel_out[11:8] <= pel_out[11:8] << 1;
                            pel_out[7:4] <= pel_out[7:4] << 1;
                            pel_out[3:0] <= pel_out[3:0] << 1 ;
                        end
                        default: begin
                            pel_out[11:8] <= pel_out[11:8];
                            pel_out[7:4] <= pel_out[7:4];
                            pel_out[3:0] <= pel_out[3:0];
                        end
                    endcase
                end
                Write: begin
                    output_valid <= 1;
                    data_out <= pel_out;
                    o_addr <= o_addr + 1;
                end
                Finish:  begin
                    all_ready <= 1;
                end
            endcase
        end
	end
    
endmodule
