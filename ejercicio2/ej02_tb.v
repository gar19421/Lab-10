module testbench();
reg clock, reset, enable1, enable2, enable3;
reg [3:0] bus;
reg [2:0] s;
wire [3:0] Y;
wire [1:0] C_Z;


always//instanciacion del clock
  begin
    clock <= 1;
    #1 clock <= ~clock;// se realiza el cambio del reloj
    #1;
end


Control ctrl1(clock, reset, enable1, enable2, enable3, bus, s, Y, C_Z);


initial begin// test del programa
  $display("Ejercicio 2\n");
  $display("CLK Reset | Enable1  Enable2  Enable3 | Bus      S   | Y    C_Z");
  $display("----------|---------------------------|--------------|----------");
  $monitor("%b     %b   |   %b         %b         %b   | %b    %b  | %b  %b", clock,reset,enable1,enable2,enable3,bus,s,Y,C_Z);
  reset = 1;
  #2 enable1 = 0;  enable2 = 0; enable3 = 0; reset = 0; bus = 4'd4; s = 3'd0;
  #2 enable1 = 1;  enable2 = 1; enable3 = 1; 
  #2 bus = 4'd8; #2 s = 3'd2;
  #2 bus = 4'd7; #2 s = 3'd1;
  #2 s = 3'd0;
  #2 bus = 4'd3; #2 s = 3'd4;
  #2 bus = 4'd15; #2 s = 3'd3;

  $finish;
end

initial begin//ejecutar GTKWave para diagramas de timing.
  $dumpfile("ej02_tb.vcd");
  $dumpvars(0, testbench);
end

endmodule
