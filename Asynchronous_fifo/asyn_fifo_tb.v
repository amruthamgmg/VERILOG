`include "asyn_fifo.v"
module tb;
   parameter WIDTH = 8;
   parameter FIFO_SIZE = 16;
   parameter PTR_WIDTH = $clog2(FIFO_SIZE);

   reg wr_clk,rd_clk,res,wr_en,rd_en;
   reg [WIDTH-1:0] wdata;
   wire [WIDTH-1:0] rdata;
   wire full,empty,overflow,underflow;

   asyn_fifo dut(.wr_clk(wr_clk),
                 .rd_clk(rd_clk),
                .res(res),
				.wr_en(wr_en),
				.rd_en(rd_en),
				.wdata(wdata),
				.rdata(rdata),
				.full(full),
				.empty(empty),
				.underflow(underflow),
				.overflow(overflow));

	always #5 wr_clk=~wr_clk;
	always #10 rd_clk=~rd_clk;

	reg [15*8:0]test_name;
	initial begin 
       $value$plusargs("test_name=%0s",test_name);
	end
    integer i,j,k,l,wr_delay,rd_delay; 
    initial begin 
     wr_clk = 0;
     rd_clk = 0;
	 res = 1;
	 wdata = 0;
	 wr_en = 0; rd_en = 0;
	 repeat(2) @(posedge wr_clk); 
     res = 0;
     case(test_name)
	   "FULL" : begin 
           writes(FIFO_SIZE);
	   end
	   "OVER_FLOW" :begin 
           writes(FIFO_SIZE+1);
	   end
	   "EMPTY" :begin 
           writes(FIFO_SIZE);
           reads(FIFO_SIZE);
	   end
	   "UNDERFLOW" :begin 
           writes(FIFO_SIZE);
		   reads(FIFO_SIZE+1);
	   end
	   "CONCURRENT" :begin 
           fork
		     begin 
                 for(k=0; k<8; k=k+1)begin 
                     writes(1);
					 wr_delay = $urandom_range(5,10);
					 #(wr_delay);
				 end
			  end
			  begin
			    wait(empty==0);
			   	for (l=0; l<8; l=l+1)begin 
                     reads(1);
			   		 rd_delay = $urandom_range(5,10);
			   		 #(rd_delay);
			   	end
			  end
		   join
	   end
	 endcase
     //writes(FIFO_SIZE); 
     //reads(FIFO_SIZE);
	 #100;
	 $finish;
	end
	task writes(input integer num_writes);begin  
	 for(i=0; i<num_writes; i=i+1)begin 
         @(posedge wr_clk);
		 wr_en=1;
		 wdata=$random;
	 end
		 @(posedge wr_clk);
		 wr_en=0;
		 wdata=0;
	 end
	endtask
	task reads(input integer num_reads);begin 
       for(i=0; i<num_reads; i=i+1)begin 
          @(posedge rd_clk);
		   rd_en=1;
	   end
	   @(posedge rd_clk);
	   rd_en = 0;
	 end 
	endtask
endmodule


