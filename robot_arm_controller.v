module robot_arm_controller (
  input        CLOCK_50,
  input        RESET_N,
  input [3:0] 	KEY,
  output	[35:0] GPIO_0
);

wire clk;
wire reset;

wire key0_triggered;
wire key1_triggered;

wire key2_triggered;
wire key3_triggered;

reg reset_reg = 0;
reg key0_reg = 0;
reg key1_reg = 0;
reg key2_reg = 0;
reg key3_reg = 0;

assign reset_triggered = ~RESET_N && ~reset_reg;
assign key0_triggered = ~KEY[0] && ~key0_reg;
assign key1_triggered = ~KEY[1] && ~key1_reg;
assign key2_triggered = ~KEY[2] && ~key2_reg;
assign key3_triggered = ~KEY[3] && ~key3_reg;

wire out02;
wire out19;
wire out18;
wire out17;
wire out16;
wire out15;
wire out14;
wire out13;
wire out12;
wire out11;
wire out10;

wire outTEST;

wire outKEY;

wire outGrip;


assign clk = CLOCK_50;

assign reset = !RESET_N;


reg [31:0] rise20 = 100000;
reg [31:0] fall20 = 900000;

reg [31:0] rise19 = 95000;
reg [31:0] fall19 = 905000;

reg [31:0] rise18 = 90000;
reg [31:0] fall18 = 910000;

reg [31:0] rise17 = 85000;
reg [31:0] fall17 = 915000;

reg [31:0] rise16 = 80000;
reg [31:0] fall16 = 920000;

reg [31:0] rise15 = 75000;
reg [31:0] fall15 = 925000;

reg [31:0] rise14 = 70000;
reg [31:0] fall14 = 930000;

reg [31:0] rise13 = 65000;
reg [31:0] fall13 = 935000;

reg [31:0] rise12 = 60000;
reg [31:0] fall12 = 940000;

reg [31:0] rise11 = 55000;
reg [31:0] fall11 = 945000;

reg [31:0] rise10 = 50000;
reg [31:0] fall10 = 950000;

reg [31:0] riseTest = 125000;
reg [31:0] fallTest = 875000;



assign GPIO_0[0] = out20;
assign GPIO_0[1] = out19;
assign GPIO_0[2] = out18;
assign GPIO_0[3] = out17;
assign GPIO_0[4] = out16;
assign GPIO_0[5] = out15;
assign GPIO_0[6] = out14;
assign GPIO_0[7] = out13;
assign GPIO_0[8] = out12;
assign GPIO_0[9] = out11;
assign GPIO_0[10] = out10;

assign GPIO_0[11] = outTest;
assign GPIO_0[13] = outKEY;

assign GPIO_0[15] = outGrip;

//PWM Characteristics:
// We need a rising edge every 20 ms, with a 50 MHz clock that is every 1 million clock ticks
// We need to hold this signal for times between 1 and 2 ms, let's start with 2 ms, so 100,000 clock ticks

PWM_Generator_Verilog generator20(clk, reset, rise20, fall20, out20);
PWM_Generator_Verilog generator19(clk, reset, rise19, fall19, out19);
PWM_Generator_Verilog generator18(clk, reset, rise18, fall18, out18);
PWM_Generator_Verilog generator17(clk, reset, rise17, fall17, out17);
PWM_Generator_Verilog generator16(clk, reset, rise16, fall16, out16);
PWM_Generator_Verilog generator15(clk, reset, rise15, fall15, out15);
PWM_Generator_Verilog generator14(clk, reset, rise14, fall14, out14);
PWM_Generator_Verilog generator13(clk, reset, rise13, fall13, out13);
PWM_Generator_Verilog generator12(clk, reset, rise12, fall12, out12);
PWM_Generator_Verilog generator11(clk, reset, rise11, fall11, out11);
PWM_Generator_Verilog generator10(clk, reset, rise10, fall10, out10);

PWM_Generator_Verilog generatorTest(clk, reset, riseTest, fallTest, outTest);

PWM_Generator_Verilog generatorKey(clk, reset, riseKey, fallKey, outKEY);

PWM_Generator_Verilog generatorGrip(clk, reset, riseGrip, fallGrip, outGrip);

//Starting key chnaging code now
reg [31:0] riseKey;
reg [31:0] fallKey;

reg [31:0] riseGrip;
reg [31:0] fallGrip;


initial begin
		riseKey = 75000;
		fallKey = 925000;
		//
		riseGrip = 75000;
		fallGrip = 925000;
end

always@(posedge clk) begin
		reset_reg <= ~RESET_N;
		key0_reg <= ~KEY[0];
		key1_reg <= ~KEY[1];
		key2_reg <= ~KEY[2];
		key3_reg <= ~KEY[3];
end


always@(posedge clk)begin
		if (reset_triggered) begin
			riseKey <= 75000;
			fallKey <= 925000;
			//
			riseGrip = 75000;
			fallGrip = 925000;
		end
		else if (key0_triggered && riseKey < 125000) begin
			riseKey <= riseKey + 25000;
			fallKey <= fallKey - 25000;
		end
		else if (key1_triggered && riseKey > 25000) begin
			riseKey <= riseKey - 25000;
			fallKey <= fallKey + 25000;
		end
		else if (key2_triggered && riseGrip < 125000) begin
			riseGrip <= riseGrip + 25000;
			fallGrip <= fallGrip - 25000;
		end
		else if (key3_triggered && riseGrip > 25000) begin
			riseGrip <= riseGrip - 25000;
			fallGrip <= fallGrip + 25000;
		end
end


endmodule
