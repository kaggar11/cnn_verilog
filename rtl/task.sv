task PointwiseMult();
   parameter size=5
   parameter bits=32 
   input [bits-1:0] A[0:size-1][0:size-1]
   input [bits-1:0] B[0:size-1][0:size-1]
   output [bits-1:0] Out[0:size-1][0:size-1])
   int i;
   int j;
  for(i=0;i<size;i=i+1) begin 
    for(j=0;j<size;j=j+1) begin 
      Out[i][j]=A[i][j]*B[i][j];
    end 
    
  end 
  
  
endmodule 
