// Code your design here
module zero_pad #(parameter SIZE=5) (input [31:0] array1[0:(SIZE-1)][0:(SIZE-1)],output [31:0] array2[0:(2*(SIZE-1))][0:(2*(SIZE-1))],clk,en,reset)
 genvar row;
 genvar col;
  logic [31:0] array2b[0:(2*(SIZE-1))][0:(2*(SIZE-1))];
  for(row=0;row<SIZE;row=row+1) begin 
    for(col=0;col<SIZE;col=col+1) begin 
      assign array2b[row][col]=array1[row][col];
      
    end 
  end 
  for(row=SIZE;row<((2*SIZE)-1);row=row+1) begin
   for(col=SIZE;col<((2*SIZE)-1;col=col+1) begin 
     assign array2b[row][col]<='d0;
    end 
  end 
  int row1;
  int col1;
  always @(posedge clk) 
  begin 
  if(reset) begin 
    for(row=0;row<SIZE;row=row+1) begin 
     for(col=0;col<SIZE;col=col+1) begin 
       array2[row][col]<='d0;
     end 
    end 
      end
    else if(en) begin 
      array2<=array2b;
    end
  end 
endmodule 
