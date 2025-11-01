module asyn_fifo(wr_clk,rd_clk,res,wr_en,rd_en,wdata,rdata,full,empty,underflow,overflow);
   parameter WIDTH = 8;
   parameter FIFO_SIZE = 16;
   parameter PTR_WIDTH = $clog2(FIFO_SIZE);

   input rd_clk,wr_clk,res,wr_en,rd_en;
   input [WIDTH-1:0] wdata;
   output reg [WIDTH-1:0] rdata;
   output reg full,empty,overflow,underflow;

   reg [WIDTH-1:0] fifo [FIFO_SIZE-1:0];
   reg [PTR_WIDTH-1:0]wr_ptr,rd_ptr,wr_gray_ptr,rd_gray_ptr,wr_ptr_rd_clk,rd_ptr_wr_clk;
   reg wr_togglef,rd_togglef,wr_togglef_rd_clk,rd_togglef_wr_clk;

     integer i;
     always@(posedge wr_clk)begin 
        if(res==1)begin 
               rdata =0;
	     	   full = 0;
	     	   empty = 1;
	     	   overflow = 0;
	     	   underflow = 0;
	     	   wr_gray_ptr = 0;
	     	   rd_gray_ptr = 0;
	     	   wr_ptr = 0;
	     	   rd_ptr = 0;
	     	   wr_togglef = 0;
	     	   rd_togglef = 0;
			   wr_ptr_rd_clk = 0;
			   rd_ptr_wr_clk = 0;
			   wr_togglef_rd_clk = 0;
			   rd_togglef_wr_clk = 0;
	     	    for(i=0; i<FIFO_SIZE; i=i+1)
	     		  fifo[i] = 0;
		    end
		  else begin 
               if(wr_en==1)begin 
                     if(full==1)
	       		         overflow = 1;
	       		     else begin 
                          fifo[wr_ptr] = wdata;
	       			      if (wr_ptr == FIFO_SIZE-1)begin 
                               wr_ptr=0;
	       				       wr_togglef = ~wr_togglef;
	       		             end
	       			       else  
                               wr_ptr = wr_ptr+1;
	       		      end
	       		end
			end
		end
		always@(posedge rd_clk)begin
		  if(rd_en == 1)begin 
               if(empty == 1)
                    underflow = 1;
			   else begin 
                    rdata = fifo[rd_ptr];
					if (rd_ptr == FIFO_SIZE-1)begin 
                        rd_ptr = 0;
						rd_togglef = ~rd_togglef;
					end
					else rd_ptr = rd_ptr+1;
			   end
		  end
	   end 
	 always@(posedge rd_clk)begin
         wr_ptr_rd_clk <= wr_gray_ptr;
		 wr_togglef_rd_clk <= wr_togglef;
	 end
	 always@(posedge wr_clk)begin
         rd_ptr_wr_clk <= rd_gray_ptr;
		 rd_togglef_wr_clk <= rd_togglef;
	 end
	  always@(*)begin 
          if(wr_gray_ptr == rd_ptr_wr_clk && wr_togglef != rd_togglef_wr_clk )
		      full = 1;
		  else full = 0;
		  if (wr_ptr_rd_clk == rd_gray_ptr && wr_togglef_rd_clk == rd_togglef)
		      empty = 1;
		  else empty = 0;
	  end

	  assign wr_gray_ptr = {wr_ptr[PTR_WIDTH-1], wr_ptr[PTR_WIDTH-1:1] ^ wr_ptr[PTR_WIDTH-2:0]};
	  assign rd_gray_ptr = {rd_ptr[PTR_WIDTH-1], rd_ptr[PTR_WIDTH-1:1] ^ rd_ptr[PTR_WIDTH-2:0]};
endmodule


