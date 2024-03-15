module task3(
    input clk, 
    input rstn,
	 input unsigned [4:0] radius,
	 input [2:0] colour_inp,
	 input draw,
    output reg [7:0] vga_x, 
    output reg [6:0] vga_y,
	 output reg [2:0] vga_colour, 
    output reg vga_plot
	 );
	 
	 reg [7:0] xc = 8'd80, x_off = 8'd0;
	 reg [6:0] yc = 7'd60, y_off = 7'd0;
	 
    //reg [7:0] vga_x_count;
	 //reg [6:0] vga_y_count;
	 
	 //reg start_clear = 1'b0;
	 reg clear_done = 1'b0;
	 
	 reg signed [7:0] d = 8'd0;
	 
	 reg [3:0] state, next_state;
	 
	 parameter SETUP = 4'b1100, CLEAR = 4'b0000, IDLE = 4'b0001, START = 4'b1011, oct1 = 4'b0010, 
	           oct2 = 4'b0011,
	           oct3 = 4'b0100, oct4 = 4'b0101, oct5 = 4'b0110,
	           oct6 = 4'b1000, oct7 = 4'b1001, oct8 = 4'b1010;
	 
	 always@(posedge clk or posedge rstn)
	 begin
	  if (rstn == 1'b1)
		  state <= SETUP;
	  else
	     state <= next_state;
    end
	 
	 always@(*)
	 begin
	   case (state)
		SETUP: next_state = CLEAR;
		CLEAR: begin if (clear_done == 1'b1)
		         next_state = IDLE;
				 else
				   next_state = CLEAR; end
		IDLE: begin if (draw == 1'b0)
		          next_state = START;
			   else
				    next_state = IDLE;
				end
		START: next_state = oct1;
		oct1: next_state = oct2;
		oct2: next_state = oct3;
		oct3: next_state = oct4;
		oct4: next_state = oct5;
		oct5: next_state = oct6;
		oct6: next_state = oct7;
		oct7: next_state = oct8;
		oct8: begin
		       if (x_off > y_off)
				  next_state = IDLE;
				 else
				  next_state = oct1;
				end
	   default: next_state = SETUP;
		endcase
	 end
	 
	 always@(posedge clk)
	 begin
	 case(state)
	 SETUP: begin
	           vga_x <= 0;
              vga_y <= 0;
              vga_plot <= 0;
				  vga_colour <= 3'b000;
				  clear_done <= 1'b0;
			  end
	 CLEAR: begin 
	         if (vga_x < 159) begin
                vga_x <= vga_x + 1'b1;
                vga_plot <= 1;
					 vga_colour <= 3'b000;
            end 
				else if (vga_y < 119) begin
                vga_y <= vga_y + 1'b1;
                vga_x <= 0;
                vga_plot <= 1;
					  end
			   else begin
				   clear_done <= 1'b1;
					//vga_colour <= 3'b000;
					end
            end
	 IDLE: begin clear_done <= 1'b0; 
	       end
	 START: begin
	         x_off <= 0;
				y_off <= {2'b00,radius};
				d <= 8'd3 - (8'd2*({3'b000,radius}));
				vga_colour <= colour_inp;
				vga_x <= 0;
            vga_y <= 0;
            vga_plot <= 0;
				end
	 oct1: begin
		       vga_x <= xc + x_off;
				 vga_y <= yc + y_off;
				 vga_plot <= 1'b1;
				 vga_colour <= colour_inp;
				end
		oct2: begin
		       vga_x <= xc - x_off;
				 vga_y <= yc + y_off;
				 vga_plot <= 1'b1;
				 vga_colour <= colour_inp;
				end
		oct3: begin
		       vga_x <= xc + x_off;
				 vga_y <= yc - y_off;
				 vga_plot <= 1'b1;
				 vga_colour <= colour_inp;
				end
		oct4: begin
		       vga_x <= xc - x_off;
				 vga_y <= yc - y_off;
				 vga_plot <= 1'b1;
				 vga_colour <= colour_inp;
				end
		oct5: begin
		       vga_x <= xc + y_off;
				 vga_y <= yc + x_off;
				 vga_plot <= 1'b1;
				 vga_colour <= colour_inp;
				end
		oct6: begin
		       vga_x <= xc - y_off;
				 vga_y <= yc + x_off;
				 vga_plot <= 1'b1;
				 vga_colour <= colour_inp;
				end
		oct7: begin
		       vga_x <= xc + y_off;
				 vga_y <= yc - x_off;
				 vga_plot <= 1'b1;
				 vga_colour <= colour_inp;
				end
		oct8: begin
		       vga_x <= xc - y_off;
				 vga_y <= yc - x_off;
				 vga_plot <= 1'b1;
				 vga_colour <= colour_inp;
				 
				 x_off <= x_off + 1'b1;
				 
				 if (d[7] == 1'b1)
				   d <= d + ((8'b0000100)*(x_off + 1'b1)) + 8'b00000110;
				 else
				   begin
					 d <= d + ((8'b0000100)*((x_off + 1'b1) - y_off)) + 8'b00001100;
					 y_off <= y_off - 7'd1;
					end		 
				end
		endcase
	 end
	 
	 
endmodule