`include "half_adder.v";
module tb;
  reg a,b;
  wire sum,carry;
  half_adder dut(a,b,sum,carry);
  initial begin
    a=1'b0; b=1'b0;
    #1 $display("a=%b,b=%b,sum=%b,carry=%b",a,b,sum,carry);
    a=1'b0; b=1'b1;
    #1$display("a=%b,b=%b,sum=%b,carry=%b",a,b,sum,carry);
    a=1'b1; b=1'b0;
    #1$display("a=%b,b=%b,sum=%b,carry=%b",a,b,sum,carry);
    a=1'b1; b=1'b1;
    #1 $display("a=%b,b=%b,sum=%b,carry=%b",a,b,sum,carry);
  end
endmodule                
