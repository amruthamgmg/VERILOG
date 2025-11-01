// Halfadder using dataflow 
module half_adder(a,b,sum,carry);
  input a,b;
  output sum,carry;
  //always @(*) begin
  //   sum= a^b;
  //   carry =a&b;
  // end
    assign sum = a ^ b;
    assign carry = a & b;  
endmodule

//Halfadder using behavioural
module half_adder(a,b,sum,carry);
   input a,b;
   output reg sum,carry;
       always @(*) begin
         if (a==0 && b==0)begin
             sum=1'b0;carry=1'b0;
         end
         else if (a==0 && b==1) begin
             sum=1'b1; carry=1'b0;
         end
         else if (a==1 && b==0) begin
             sum=1'b1; carry=1'b0;
         end
         else  begin
             sum=1'b0; carry=1'b1;
         end
       end
endmodule

// using case statement 
module half_adder(a,b,sum,carry);
 input a,b;
 output reg sum,carry;
  always@(*)
      case({a,b}) 
          2'b00:begin sum=1'b0;carry=1'b0;end
          2'b01:begin sum=1'b1;carry=1'b0;end
          2'b10:begin sum=1'b1;carry=1'b0;end
          2'b11:begin sum=1'b0;carry=1'b1;end
          default : sum =1'bx;
      endcase
   end
endmodule

//half adder using logic gates (stuctural)
module half_adder(a,b,s,c);
input [7:0]a,b;
output s,c;
  xor g1(s,a,b);
  and g2(c,a,b);
endmodule
