`timescale 1ns/1ps
module divideImag_tb;

// Inputs
  parameter SIZE=9;
  parameter FILTER_SIZE=3;
  parameter size=SIZE;
  		//parameter size=5;
  logic [31:0] array1[0:(SIZE-1)][0:(SIZE-1)];
  logic [31:0] array2[0:(((SIZE/FILTER_SIZE)*(SIZE/FILTER_SIZE))-1)][0:(FILTER_SIZE-1)][0:(FILTER_SIZE-1)];
  logic clk;
  logic en;
  logic reset;
  parameter outputsize=(SIZE/FILTER_SIZE)*(SIZE/FILTER_SIZE);
// Outputs
  int row;
  int col;
  int channel;
// Instantiate the Unit Under Test (UUT)
  divideImag #(.SIZE(SIZE),.FILTER_SIZE(FILTER_SIZE)) uut(.clk(clk),.array1(array1),.array2(array2));
  


  
  
		initial begin
// Initialize Inputs
          $display("Starting ghfhgfhgfh");
          
          //$finish;
			clk = 0;
			en = 0;
			reset = 1;
              for(row=0;row<size;row=row+1) begin 
                for(col=0;col<size;col=col+1) begin 
                  array1[row][col]='d3;
                  $display("array1[%d][%d]=%0d", row,col,array1[row][col]);
      			    end 
    		    end
          $display("Hellrtetretertreo");
        //    @(posedge clk);
        //    reset=0;
    //      en=1;
          //@(posedge clk);
       //  reset=0;
       //      en=1;
          @(posedge clk);
          $display("gfgfgf");
            // #900;
          #1;
          for(channel=0;channel<outputsize;channel=channel+1) begin 
          for(row=0;row<FILTER_SIZE;row=row+1) begin 
            for(col=0;col<FILTER_SIZE;col=col+1)  begin 
             // $display("This is row=%0d and col=%0d",row,col);
              $display("This is array2[%0d][%0d][%0d]=%0d",channel,row,col,array2[channel][row][col]);
            end 
          end
          end 
          //  $finish;
          $finish;
           end
           always begin
			#250 clk=!clk;
			end

endmodule
