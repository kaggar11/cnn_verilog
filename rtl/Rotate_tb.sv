`timescale 1ns/1ps
module Rotate_tb;

// Inputs
       
  		parameter size=7;
  logic [31:0] array2[0:(size-1)][0:(size-1)];
  logic [31:0] array1[0:(size-1)][0:(size-1)];
  logic clk;
  logic en;
  logic reset;
  //parameter outputsize=(2*(size-1))+1;
// Outputs
  int row;
  int col;
// Instantiate the Unit Under Test (UUT)
  Rotate #(.SIZE(size)) uut(.clk(clk),.en(en),.reset(reset),.FFTArray1(array1),.FFTArray2(array2));
  


  
  
		initial begin
// Initialize Inputs
          $display("Starting ghfhgfhgfh");
          
          //$finish;
			clk = 0;
			en = 0;
			reset = 1;
          for(row=0;row<size;row=row+1) begin 
            for(col=0;col<size;col=col+1) begin 
              array1[row][col]=row+col;
              $display("array1[%d][%d]=%0d", row,col,array1[row][col]);
      	    end 
    	  end
          $display("Hellrtetretertreo");
            @(posedge clk);
             reset=0;
             en=1;
          @(posedge clk);
          reset=0;
             en=1;
                @(posedge clk);
          $display("gfgfgf");
          for(row=0;row<size;row=row+1) begin 
            for(col=0;col<size;col=col+1)  begin 
             // $display("This is row=%0d and col=%0d",row,col);
              $display("This is array2[%0d][%0d]=%0d",row,col,array2[row][col]);
            end 
          end 
          //  $finish;
          #90000;
          $finish;
           end
  
  
//blocks_in[0+:4][0+:3][0+:3] = 0;

// Wait 100 ns for global reset to finish
//#5000;
//       end
// Add stimulus here
           always begin
			#250 clk=!clk;
			end
//initial begin
//@(posedge clk);
//control=1;
//reset  =0;
//blocks_in[0][0+:3][0+:3] = 64'b1;
//end
     
endmodule
