module divideImag #(parameter SIZE=9,parameter FILTER_SIZE=3)(input clk, input [31:0] array1[0:(SIZE-1)][0:(SIZE-1)],output logic [31:0] array2[0:(((SIZE/FILTER_SIZE)*(SIZE/FILTER_SIZE))-1)][0:(FILTER_SIZE-1)][0:(FILTER_SIZE-1)]);
  parameter outputsize=SIZE/FILTER_SIZE;
  parameter outputsize_squared=outputsize*outputsize;
  parameter size=FILTER_SIZE;
  wire [31:0] array2b[0:(outputsize_squared-1)][0:(FILTER_SIZE-1)][0:(FILTER_SIZE-1)];
  genvar i;
  genvar j;
  genvar k;
 // wire [31:0] row;
 // wire [31:0] col;
  for(i=0;i<outputsize_squared;i=i+1) begin
  //  assign row=i/size;
  //  assign col=i%size;
    for(j=0;j<FILTER_SIZE;j=j+1) begin 
      for(k=0;k<FILTER_SIZE;k=k+1) begin 
        assign array2b[i][j][k]=array1[j+((i/FILTER_SIZE)*FILTER_SIZE)][k+((i%FILTER_SIZE)*FILTER_SIZE)];
      end 
    end 
    
  end 
  always @(posedge clk) begin 
    array2<=array2b;
  end 
  
endmodule
