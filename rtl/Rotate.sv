// Code your design here
module Rotate #(parameter SIZE=5)
  (input [31:0] FFTArray1[0:(SIZE-1)][0:(SIZE-1)] , output logic [31:0] FFTArray2[0:(SIZE-1)][0:(SIZE-1)],input clk,input reset,input en);
  logic [31:0] FFTArray2b[0:(SIZE-1)][0:(SIZE-1)];
 // logic [31:0 ]trim_first;
 // logic [31:0] trim_last;
  parameter  trim_last=(SIZE-1)/2;
  parameter trim_first=(SIZE-1)-((SIZE-1)/2);
  genvar row;
  genvar col;
  int row1;
  int col1;
 always @* begin 
   FFTArray2b=FFTArray2;
 end 
  always @(posedge clk)
    begin 
      if(reset) begin 
        for(row1=0;row1<(SIZE);row1=row1+1) begin 
          for(col1=0;col1<(SIZE);col1=col1+1) begin 
            //FFTArray2[row1][col1]<=FFTArray1[row1][col1];
            FFTArray2[row1][col1]<=FFTArray1[SIZE-1-row1][SIZE-1-col1];
          end 
        end
      end 
      else if(en) begin 
           FFTArray2<=FFTArray2b;
        end
    end  
endmodule 
