// Code your design here
`timescale 1ns/1ps
module InputPad #(parameter SIZE=5, FILTER_SIZE=3) (input [31:0] array1[0:(SIZE-1)][0:(SIZE-1)],output logic [31:0] array2[0:(SIZE+FILTER_SIZE-(SIZE%FILTER_SIZE)-1)][0:(SIZE+FILTER_SIZE-(SIZE%FILTER_SIZE)-1)],input clk,input en,input reset);
 genvar row;
 genvar col;
   logic [31:0] outputsize1;
  parameter outputsize=SIZE+FILTER_SIZE-(SIZE%FILTER_SIZE);
  
  logic [31:0] array2b[0:(outputsize-1)][0:(outputsize-1)];
  for( row=0;row<SIZE;row=row+1) begin 
    for( col=0;col<outputsize;col=col+1) begin 
   //   assign array2b[row][col]=array1[row][col];
      assign array2b[row][col]=(col<SIZE) ? array1[row][col]:'d0;
      
    end 
  end 
  for(row=SIZE;row<outputsize;row=row+1) begin
    for(col=0;col<outputsize;col=col+1) begin 
   ///$display("This is array2[%0d][%0d]=%0d",row,col,array2[row][col]);

    assign array2b[row][col]='d0;
    end 
  end 

       
  int row1;
  int col1;
  always @(posedge clk) 
  begin 
  if(reset) begin 
    for(row1=0;row1<((2*(SIZE-1))+1);row1=row1+1) begin 
      for(col1=0;col1<((2*(SIZE-1))+1);col1=col1+1) begin 
        array2[row1][col1]<='d0;
     end 
    end 
      end
    else if(en) begin 
      array2<=array2b;
    end
  end 
endmodule 
