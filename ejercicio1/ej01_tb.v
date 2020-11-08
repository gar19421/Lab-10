module testbench();
reg clock, resetC, resetF, enableC, enableF, load;//variables para el contador
reg [11:0] loadPC;
wire [3:0] instr;
wire [3:0] oprnd;


always//instanciacion del clock
  begin
    clock <= 1;
    #1 clock <= ~clock;// se realiza el cambio del reloj
    #1;
end


Control ctrl1(clock, resetC, resetF, enableC, enableF, load, loadPC, instr, oprnd);


initial begin// test del programa
  $display("Ejercicio 1\n");
  $display("CLK ResetC ResetF| EnableC  EnableF  Load | instr oprnd");
  $display("-----------------|------------------------|--------------");
  $monitor("%b     %b      %b   |  %b         %b        %b  | %b   %b", clock,resetC,resetF,enableC,enableF,load,instr,oprnd);
  resetC = 1; resetF = 1;
  #2 enableF = 0;  enableC = 0; resetC = 0; resetF = 0; load = 0; loadPC = 12'd0;
  #2; #2;
  #2 enableC = 1;  enableF = 1;
  #2; #2; #2; #2; #2;
  #2 load = 1; loadPC = 12'd12;
  #2 load = 0;
  #2; #2; #2;// prueba del cambio del contador y muestra de memoria
  $finish;
end


initial begin//ejecutar GTKWave para diagramas de timing.
  $dumpfile("ej01_tb.vcd");
  $dumpvars(0, testbench);
end

endmodule
