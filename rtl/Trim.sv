// Code your design here
module Trim #(parameter SIZE=5)
  (input [31:0] FFTArray[0:(2*(SIZE-1))][0:(2*(SIZE-1))] , output [31:0] FFTTriming[0:(SIZE-1)][0:(SIZE-1)],en,clk,reset)
  logic [31:0] FFTTriming1[0:(SIZE-1)][0:(SIZE-1)];
  logic [31:0] trim_first;
  logic [31:0] trim_last;
  assign  trim_last=(SIZE-1)/2;
  assign trim_first=(SIZE-1)-((SIZE-1)/2);
  genvar row;
  genvar col;
  int row1;
  int col1;
    for(row=trim_first;row<(trim_first+SIZE);row=row+1)
      begin 
        for(col=trim_first;col<(trim_first+SIZE);col=col+1) begin 
          assign FFTTriming1[row][col]=FFTArray[row-trim_first][col-trim_first];
        end 
      end 
  always @(posedge)
    begin 
      if(reset) begin 
        for(row1=0;row1<(SIZE);row1=row1+1) begin 
          for(col1=0;col1<(SIZE);col1=col1+1) begin 
            FFTTriming[row1][col1]<='d0;
          end 
        end
      end 
        if(en) begin 
          FFTTriming<=FFTTriming1;
        end 
    end  
endmodule 
