`include "full_adder.v"
module tb;
  reg cin;
  reg a,b;
  wire carry;
  wire sum;
  fadder  dut(.a(a),
              .b(b),
	          .cin(cin),
	          .sum(sum),
	          .carry(carry));
    initial begin
      repeat(10)begin
        {a,b,cin}=$urandom;
         #1 $display("a=%b b=%b cin=%b sum=%b carry=%b",a,b,cin,sum,carry);
      end
    end
endmodule 
