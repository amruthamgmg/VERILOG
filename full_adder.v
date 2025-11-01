module fadder (a,b,cin,sum,carry);
  input a,b;
  input cin;
  output carry;
  output sum;
    assign sum = a ^ b ^ cin;
    assign carry = (a&b) | (b&cin) | ( a&cin);
  //assign {carry,sum} = a+b+cin;
endmodule
