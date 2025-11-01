`include "mem.v"
module tb;
   parameter WIDTH = 8;
   parameter DEPTH = 32;
   parameter ADDR_WIDTH = $clog2(DEPTH);
   reg clk,res,valid,wr_rd;
   reg [WIDTH-1:0]wdata;
   reg [ADDR_WIDTH-1:0]addr;
   
   wire [WIDTH-1:0]rdata;
   wire ready;

   memory #(.WIDTH(WIDTH),
            .DEPTH(DEPTH),
			.ADDR_WIDTH(ADDR_WIDTH)) dut(.clk(clk),
			                             .res(res),
										 .valid(valid),
										 .ready(ready),
										 .wdata(wdata),
										 .rdata(rdata),
										 .wr_rd(wr_rd),
										 .addr(addr));
   
   always #5 clk = ~clk;
   integer i;
   
   reg [20*8-1:0]test_name;
   initial begin
    $value$plusargs("test_name=%0s",test_name);
   end
   
   initial begin 
       clk = 0;
       res = 1; 
       addr = 0;
       wdata = 0;
       valid = 0;
       wr_rd = 0;
       repeat (2)@(posedge clk);
       res = 0;
       case(test_name)
         	"1wr_1rd":begin
         	 writes(15,1);
         	 reads(15,1);
         	  end
         	"5wr_5rd":begin
         	 writes(3,5);
         	 reads(3,5);
         	  end
         	"FDwr_FDrd":begin //frontdoor means all locations from start
         	  writes(0,DEPTH);
         	  reads(0,DEPTH);
         	  end
         	"BDwr_BDrd":begin
         	  bd_writes(3,6);
         	  bd_reads(3,6);
         	 end
         	"FDwr_BDrd":begin
         	 writes(0,DEPTH);
         	 bd_reads(0,31);
         	  end
         	"BDwr_FDrd":begin
         	  bd_writes(0,31);
         	  reads(0,DEPTH);
         	  end
         	"IST_QUATOR_WR_RD":begin
         	  writes(0,DEPTH/4);
         	  reads(0,DEPTH/4);
         	  end
            "2ND_QUATOR_WR_RD":begin
         	 writes(DEPTH/4,DEPTH/4);
         	 reads(DEPTH/4,DEPTH/4);
         	  end
         	"3RD_QUATOR_WR_RD":begin
         	  writes(DEPTH/2,DEPTH/4);
         	  reads(DEPTH/2,DEPTH/4);
         	  end
         	"4TH_QUATOR_WR_RD":begin
         	  writes(3*DEPTH/4,DEPTH/4);
         	  reads(3*DEPTH/4,DEPTH/4);
         	  end
         	"CONSECUTIVE":begin
         	  for(i = 0; i <DEPTH; i = i+1)
         	    consecutive(i);
         	  end
       endcase
          #100;
          $finish;
   end
   task writes(input reg [ADDR_WIDTH-1:0]start_loc, input reg[ADDR_WIDTH:0]num_writes);begin
     for(i = start_loc; i < (start_loc+num_writes); i = i+1)begin
     	@(posedge clk);
           wr_rd = 1;
           addr = i;
           valid = 1;
           wdata = $random;
           wait(ready == 1);
        end
        @(posedge clk)
           wr_rd = 0; 
		   addr = 0;
		   valid = 0;
		   wdata = 0;
     end
   endtask
   task reads(input reg [ADDR_WIDTH-1:0]start_loc, input reg[ADDR_WIDTH:0]num_reads);begin
      for(i = start_loc; i < (start_loc+num_reads); i = i+1)begin
         @(posedge clk);
           wr_rd = 0;
           addr = i;
           valid = 1;
    	   wait(ready == 1);
     	end
    	@(posedge clk)
        wr_rd = 0;
		addr = 0;
		valid = 0;
    end
   endtask
   task bd_writes(input integer start_loc,input integer end_loc);
      $readmemh("input.hex",dut.mem,start_loc,end_loc);
   endtask
   task bd_reads(input integer start_loc,input integer end_loc);
      $writememh("output.hex",dut.mem,start_loc,end_loc);
   endtask
   
   task consecutive(input reg[ADDR_WIDTH-1:0]start_loc);begin
      @(posedge clk);
      wr_rd = 1;
      addr = start_loc;
      wdata = $random;
      valid = 1;
      wait(ready == 1);
      @(posedge clk);
      wr_rd = 0;
      addr = start_loc;
      valid = 1;
      wait(ready == 1);
     end
   endtask
endmodule
