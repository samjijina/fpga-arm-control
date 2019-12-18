`timescale 1ns / 1ps
// fpga4student.com: FPGA Projects, Verilog projects, VHDL projects 
// Verilog project: Verilog testbench code for PWM Generator with variable duty cycle 
module tb_PWM_Generator_Verilog;
 // Inputs
 reg clk;
 reg reset;
 // Outputs
 wire[35:0] PWM_OUT;
 // Instantiate the PWM Generator with variable duty cycle in Verilog
 robot_arm_controller PWM_Generator_Unit(clk, reset, PWM_OUT);
 //
 initial begin
 clk = 0;
 forever #100 clk = ~clk;
 end 
 initial begin
  #50 reset = 1;
  #50 reset = 0; 
 end
endmodule
