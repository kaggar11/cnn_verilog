// Code your design here
`timescale 1ns / 1ps

module OVA #(parameter num_block_root=4, size=4, overlap=1)(
     clk,reset,
	 control,
	 blocks_in,
	 overlap_data
	 );
	 
//	integer a;
  //	integer b;
  	//integer c;
  	//integer d;
  	int c;
    int d;
	input clk;
	//input controlinitial;
  	//input controlrow;
  	input control;
  	input reset;
  int clkcycle;
  int row;
  int col;
  int a;
  int b;
  parameter outputsize=((num_block_root)*size)-((num_block_root-1)*overlap);
  input logic [31:0] blocks_in [0:((num_block_root*num_block_root)-1)][0:size-1][0:size-1];
  output logic [31:0] overlap_data [0:(outputsize-1)][0:(outputsize-1)];
  //reg [63:0] overlap_data2 [0:((num_block_root*num_block_root)-1)][0:(outputsize-1)];
  reg [31:0] overlap_data2 [0:(outputsize-1)][0:(outputsize-1)];
  reg [31:0] a2 [0:(size-1)][0:(size-1)];
  reg [31:0] b2 [0:(size-1)][0:(size-1)];
  reg [31:0] c2 [0:(size-1)][0:(size-1)];
  
  //reg [63:0] overlap_data [0:((num_block_root*num_block_root)-1)][0:(outputsize-1)];
  	//int clkcycle;

  
  always@* begin 
    //$display("dfdgdfgdfgfd");
    //  initial begin 
    //$display("This is cycle number= %d",clkcycle);
  //end 
    row=clkcycle/num_block_root;
    col=clkcycle % num_block_root;
    //overlap_data2=overlap_data;
    /*if(clkcycle==0)
      begin 
        for(a=0;a<outputsize;a=a+1)
          begin 
            for(b=0;b<outputsize;b=b+1)
              begin 
                overlap_data[a][b]=32'b0;
              end 
          end 
      end*/
    //$display("This is num_block_root= %d",num_block_root);
    //$display("This is col= %d",col);
    /*for(a=row*(size-overlap);a<((row*(size-overlap))+size);a=a+1) begin
      for(b=col*(size-overlap);b<((col*(size-overlap))+size);b=b+1) begin 
        a2[a-(row*(size-overlap))][b-(col*(size-overlap))]=overlap_data[a][b];
        $display("this is cyclenumber=%0d and a2[%0d][%0d]=%0d", clkcycle,a-(row*(size-overlap)),b-(col*(size-overlap)),overlap_data[a][b]);
      end
    end */
	 for(a=0;a<size;a=a+1) begin
      for(b=0;b<size;b=b+1) begin 
        a2[a][b]=overlap_data[a+(row*(size-overlap))][b+(col*(size-overlap))];
       // $display("this is cyclenumber=%0d and a2[%0d][%0d]=%0d", clkcycle,a-(row*(size-overlap)),b-(col*(size-overlap)),overlap_data[a+(row*(size-overlap))][b+(col*(size-overlap))]);
      end
    end 
   // a2=overlap_data[(row*(size-overlap)) +: size][(col*(size-overlap)) +: size];
    b2=blocks_in[clkcycle];
    if(control==0)
      begin 
        for(a=0;a<outputsize;a=a+1)
          begin 
            for(b=0;b<outputsize;b=b+1)
              begin 
                overlap_data2[a][b]=32'b0;
              end 
          end 
      end
    else if(clkcycle<(num_block_root*num_block_root)) begin 
      overlap_data2=overlap_data;
    //  overlap_data2[(row*(size-overlap))+:size][(col*(size-overlap))+:size]=matrixAdd(overlap_data[(row*(size-overlap))+:size][(col*(size-overlap))+:size],blocks_in[clkcycle]);
     // matrixAdd(overlap_data[(row*(size-overlap)) +: size][ (col*(size-overlap)) +: size],blocks_in[clkcycle], overlap_data2[(row*(size-overlap)) +: size][(col*(size-overlap)) +: size]);
      //matrixAdd(a2,b2, overlap_data2[(row*(size-overlap)) +: size][(col*(size-overlap)) +: size]);
      matrixAdd(a2,b2, c2);
      /*for(a=row*(size-overlap);a<((row*(size-overlap))+size);a=a+1) begin
        for(b=col*(size-overlap);b<((col*(size-overlap))+size);b=b+1) begin 
          overlap_data2[a][b]=c2[a-(row*(size-overlap))][b-(col*(size-overlap))];
          $display("this is cyclenumber=%0d and c2[%0d][%0d]=%0d", clkcycle,a-(row*(size-overlap)),b-(col*(size-overlap)),c2[a][b]); 
         end
   	   end 
    end */
	 for(a=0;a<size;a=a+1) begin
        for(b=0;b<+size;b=b+1) begin 
          overlap_data2[a+(row*(size-overlap))][b+(col*(size-overlap))]=c2[a][b];
        //  $display("this is cyclenumber=%0d and c2[%0d][%0d]=%0d", clkcycle,a-(row*(size-overlap)),b-(col*(size-overlap)),c2[a][b]); 
         end
   	   end 
    end 
    else begin 
      overlap_data2<=overlap_data;
    end 
  end 
  /*function matrixAddCol
    input [63:0] a[0:(size-1)][0:(overlap-1)];
    input [63:0] b[0:(size-1)][0:(overlap-1)];
    output [63:0] c[0:(size-1)][0:(overlap-1)];
    int row1=0;
    int col1=0;
    for(row=0;row<size;row=row+1) begin 
      for(col=0;col<overlap;col=col+1) begin 
        c[row][col]=a[row][col]+b[row][col];
      end 
      
    end 
  endfunction*/
   task matrixAdd;
     input [31:0] a1[0:(size-1)][0:(size-1)];
     input [31:0] b1[0:(size-1)][0:(size-1)];
     output [31:0] c1[0:(size-1)][0:(size-1)];
    int row1;
    int col1;
     for(row1=0;row1<size;row1=row1+1) begin 
       for(col1=0;col1<size;col1=col1+1) begin 
        c1[row1][col1]=a1[row1][col1]+b1[row1][col1];
      end 
      
    end 
   endtask
  
	/*integer i;
	wire [word*row-1:0] overlap_blocks [block-1:0];


	// implement your OVA Unit below
	
	initial begin
	     overlap_blocks[0][63:0] = blocks_in[0][191:128]+blocks_in[2][63:0];
	     overlap_blocks[1][63:0] = blocks_in[1][191:128]+blocks_in[3][63:0];
	     overlap_blocks[2][63:0] = 
	end*/

  always @(posedge clk)
	begin
      //$display("The value of reset:%0d",reset);
      if(reset)  
      	begin 
          clkcycle<='d0;
          for(c=0;c<outputsize;c=c+1)
          begin 
            for(d=0;d<outputsize;d=d+1)
              begin 
                overlap_data[c][d]<=32'b0;
               //$display("reading this");
              end 
          end
          clkcycle<=0;
      	end  
	     if (control) begin
		//wt_path_out <= wt_path_in;
      		overlap_data<=overlap_data2;
           //$display("hello hello");
           	clkcycle<=clkcycle+1;
         end
    end 


endmodule
