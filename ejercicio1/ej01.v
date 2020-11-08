module FF_1BIT(input wire clk, reset, enable, D, output reg Y) ;
  always @(posedge clk or posedge enable or posedge reset) begin
    if (reset)  Y <= 1'b0;
    else if(enable) Y <= D;
  end
endmodule

module Program_Couter(input wire clk, reset, enable, load, input [11:0] loadPC, output reg[11:0] count);
//contador de 12 bits con entradas de clock, reset, enable y load

  always @ (posedge clk or posedge reset or posedge enable or posedge load) begin
    if(reset) begin
     count <= 12'd0; // si se resetea empieza en cero
    end
    else if(clk & enable & ~load) begin
        #2 count <= count + 12'd1; // si esta en enable cuenta el contador sino no cuenta
    end
    else if(clk & load & enable) begin
        #2 count <= loadPC; //precargando el valor
    end
  end

endmodule

module Fetch (input wire clk, reset, enable, input wire [7:0] program_byte, output wire [3:0] instr, oprnd) ;
  FF_1BIT FF1(clk, reset, enable, program_byte[7], instr[3]);
  FF_1BIT FF2(clk, reset, enable, program_byte[6], instr[2]);
  FF_1BIT FF3(clk, reset, enable, program_byte[5], instr[1]);
  FF_1BIT FF4(clk, reset, enable, program_byte[4], instr[0]);
  FF_1BIT FF5(clk, reset, enable, program_byte[3], oprnd[3]);
  FF_1BIT FF6(clk, reset, enable, program_byte[2], oprnd[2]);
  FF_1BIT FF7(clk, reset, enable, program_byte[1], oprnd[1]);
  FF_1BIT FF8(clk, reset, enable, program_byte[0], oprnd[0]);
endmodule

module Program_ROM (input wire [11:0] address, output wire [7:0] word);//memoria rom
  reg [7:0] mem [0:4095];// creacion de arreglo de memoria
  initial begin
      $readmemb("memory.list", mem);//lectura del archivo de datos
  end
  assign word = mem[address];// resultado leido de la memoria
endmodule

module Control (input clk, resetC, resetF, enableC, enableF, load, input [11:0] loadPC, output [3:0] instr, oprnd);

wire [11:0] PC;
wire [7:0] program_byte;

Program_Couter PC1(clk, resetC, enableC, load, loadPC, PC);
Program_ROM PR1(PC, program_byte);
Fetch F1(clk, resetF, enableF, program_byte, instr, oprnd);

endmodule
