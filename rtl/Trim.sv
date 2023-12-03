// Code your design here
module Trim #(parameter SIZE=5)
  (input [31:0] FFTArray[0:(2*(SIZE-1))][0:(2*(SIZE-1))] , output FFTTriming[0:(SIZE-1)][0:(SIZE-1)])
  logic FFTTriming1[0:(SIZE-1)][0:(SIZE-1)];
  logic [31:0 ]trim_first;
  logic [31:0] trim_last;
  assign  trim_last=(SIZE-1)/2;
  assign trim_first=(SIZE-1)-((SIZE-1)/2);
  genvar row;
  genvar col;
    for(row=trim_first;row<(trim_first+SIZE);row=row+1)
      begin 
        for(col=trim_first;col<(trim_first+SIZE);col=col+1) begin 
          assign FFTTriming[row][col]=FFTArray[row-trim_first][col-trim_first];
        end 
      end 
  
endmodule 
