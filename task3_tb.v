module task3_tb;

reg clk;
reg rstn;
reg [4:0] radius;
reg [2:0] colour_inp;
reg draw;
wire [7:0] vga_x; 
wire [6:0] vga_y;
wire [2:0] vga_colour; 
wire vga_plot;

task3 dut(.clk(clk),
          .rstn(rstn),
	       .radius(radius),
			 .colour_inp(colour_inp),
	       .draw(draw),
          .vga_x(vga_x),
          .vga_y(vga_y),
			 .vga_colour(vga_colour),
          .vga_plot(vga_plot));


			 always
			  #10000 clk = ~clk;
			  
			 initial
			 begin
			  clk = 1'b0;
			  rstn = 1'b1; radius = 5'b11111; colour_inp = 3'b101; draw = 1'b0; #7000
			  rstn = 1'b0; radius = 5'b11111; colour_inp = 3'b101; draw = 1'b0; #2000000000
			  rstn = 1'b0; radius = 5'b11111; colour_inp = 3'b101; draw = 1'b1; #10000
			  rstn = 1'b0; radius = 5'b11111; colour_inp = 3'b101; draw = 1'b0; #2000000000
			  //rstn = 1'b1; radius = 5'b11111; colour_inp = 3'b101; draw = 1'b0; #1000000
			  
			  $stop;
			  $finish;
			  
			 end

endmodule