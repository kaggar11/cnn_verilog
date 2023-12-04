task PointwiseMult();
   input [31:0] size;
   input [31:0] A[0:size-1][0:size-1]
   input [31:0] B[0:size-1][0:size-1]
   output [31:0] Out[0:size-1][0:size-1])
   int i;
   int j;
  for(i=0;i<size;i=i+1) begin 
    for(j=0;j<size;j=j+1) begin 
      Out[i][j]=A[i][j]*B[i][j];
    end 
    
  end 
endtask
  task ZeroPad;
     input [31:0] size;
     input [31:0] a1[0:(size-1)][0:(size-1)];
     output [31:0] c1[0:(size-1)*2][0:(size-1)*2];
    int row1;
    int col1;
     for(row1=0;row1<size;row1=row1+1) begin 
       for(col1=0;col1<size;col1=col1+1) begin 
        c1[row1][col1]=a1[row1][col1]+b1[row1][col1];
      end 
     end 
        for(row1=size;row1<((size*2)-1);row1=row1+1) begin 
           for(col1=size;col1<((size*2)-1);col1=col1+1) begin 
              c1[row1][col1]='b0;
           end 
      end
   endtask 
