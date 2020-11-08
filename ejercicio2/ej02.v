module FF_D1(input wire clock, reset, enable, d, output reg Y);
  always @ (posedge clock or posedge reset or posedge enable) begin
    if(reset) begin
      Y <= 1'b0;
    end
    else if (enable) begin
      Y <= d;
    end
  end
endmodule


module ALU(input wire [3:0] A, B, input wire [2:0] S, output reg [3:0] R, output reg [1:0] C_Z);//implementacion de la ALU

  reg [4:0] result;
  // parametros tabla 5.1 libro
  parameter ST = 3'd0;
  parameter COMPI = 3'd1;
  parameter LIT = 3'd2;
  parameter ADDI = 3'd3;
  parameter NANDI = 3'd4;

  always @(*) begin// operaciones a realizar con la ALU con un switch case
    case(S)
    ST:
       result <= A;
    COMPI:
       result <= (A - B);
    LIT:
       result <= B;
    ADDI:
       result <= (A + B);
    NANDI:
       result <= (A ~& B);
    default: result <= 5'd0;
    endcase
    assign {R, C_Z[0], C_Z[1]} = {result[3:0], result[4], ((result[3:0]==4'b0) ? 1'b1 : 1'b0) };
  end
endmodule


module Accumulator(input wire clk, reset, enable, input wire [3:0] D, output wire [3:0] Accu) ;
  FF_D1 FF1(clk, reset, enable, D[3], Accu[3]);
  FF_D1 FF2(clk, reset, enable, D[2], Accu[2]);
  FF_D1 FF3(clk, reset, enable, D[1], Accu[1]);
  FF_D1 FF4(clk, reset, enable, D[0], Accu[0]);
endmodule


module Bus_Driver(input wire enable, input wire [3:0] bus, output wire [3:0] Y);
  assign Y = enable ? bus : 4'bz;
endmodule

module Control (input wire clk, reset, enable1, enable2, enable3, input wire [3:0] bus, input wire [2:0] S,
  output wire [3:0] Y, output wire [1:0] C_Z);

  wire [3:0] accu, R, data_bus;

  Bus_Driver BD1(enable2, bus, data_bus);
  Accumulator Accu1(clk, reset, enable1, R, accu);
  ALU alu1(accu, data_bus, S, R, C_Z);
  Bus_Driver BD2(enable3, R, Y);

endmodule
