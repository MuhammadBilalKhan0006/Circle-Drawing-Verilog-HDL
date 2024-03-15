module vga_demo(CLOCK_50, SW, KEY,
				VGA_R, VGA_G, VGA_B,
				VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK);
	
	input CLOCK_50;	
	input [9:0] SW;
	input [3:0] KEY;
	output [9:0] VGA_R;
	output [9:0] VGA_G;
	output [9:0] VGA_B;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK;
	output VGA_SYNC;
	output VGA_CLK;	
	
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	
	wire plot;
	
	//assign colour = 3'b111;
	//assign x = {3'd0, SW[9:5]};
	//assign y = {2'd0, SW[4:0]};
	
//	task2 inp(
//	      .clk(CLOCK_50),
//	      .rstn(KEY[3]),
//			.vga_x(x),
//			.vga_y(y),
//			.vga_colour(colour),
//			.vga_plot(plot)
//	);
	
	task3 circle(
	       .clk(CLOCK_50),
          .rstn(KEY[3]),
	       .radius(SW[7:3]),
			 .colour_inp(SW[2:0]),
	       .draw(KEY[2]),
          .vga_x(x),
          .vga_y(y),
			 .vga_colour(colour),
          .vga_plot(plot)
	);

	vga_adapter VGA(
			.resetn(KEY[3]),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_SYNC(VGA_SYNC),
			.VGA_BLANK(VGA_BLANK),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "image.colour.mif";
		defparam VGA.USING_DE1 = "TRUE";
		
endmodule
