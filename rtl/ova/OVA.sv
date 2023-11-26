`timescale 1ns / 1ps

module OVA #(parameter num_block_root=4, size=9, overlap=3)(
     clk,reset,
	 control,controlrow,controlcol,
	 blocks_in,
	 overlap_data
	 );
	 
	integer a;
  	integer b;
  	integer c;
  	integer d;
  	reg c;
    reg d;
	input clk;
	input controlinitial;
  	input controlrow;
  	input controlcol;
  	input clkcycle;
  	input reset;
  reg row;
  reg col;
  int outputsize=((num_block_root)*size)-((num_block_root-1)*overlap);
  input logic [63:0] blocks_in [0:((num_block_root*num_block_root)-1)][0:size-1][0:size-1];
  output logic [63:0] overlap_data [0:(outputsize-1)][0:(outputsize-1)];
  reg [63:0] overlap_data2 [0:((num_block_root*num_block_root)-1)][0:(outputsize-1)];
  //reg [63:0] overlap_data [0:((num_block_root*num_block_root)-1)][0:(outputsize-1)];
  	integer cyclenumber;
  always@* begin 
    row=clkcycle/num_block_root;
    col=clkcyle % num_block_root;
    overlap_data2=overlap_data;
    if(control==0)
      begin 
        for(a=0;a<outputsize;a=a+1)
          begin 
            for(b=0;b<outputsize;b=b+1)
              begin 
                overlap_data2[a][b]=64'b0;
              end 
          end 
      end
    else if(cyclenumber<(num_block_root*num_block_root)) begin 
      overlap_daa2=overlap_data;
      overlap_data2[(row*(size-overlap))+:size][(col*(size-overlap))+:size]=matrixAdd(overlap_data[(row*(size-overlap))+:size][(col*(size-overlap))+:size],blocks_in[clkcycle]);
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
   function matrixAdd
     input [63:0] a[0:(overlap-1)][0:(size-1)];
     input [63:0] b[0:(overlap-1)][0:(size-1)];
     output [63:0] c[0:(overlap-1)][0:(size-1)];
    int row1=0;
    int col1=0;
     for(row=0;row<overlap;row=row+1) begin 
      for(col=0;col<size;col=col+1) begin 
        c[row][col]=a[row][col]+b[row][col];
      end 
      
    end 
  endfunction
  
	/*integer i;
	wire [word*row-1:0] overlap_blocks [block-1:0];


	// implement your OVA Unit below
	
	initial begin
	     overlap_blocks[0][63:0] = blocks_in[0][191:128]+blocks_in[2][63:0];
	     overlap_blocks[1][63:0] = blocks_in[1][191:128]+blocks_in[3][63:0];
	     overlap_blocks[2][63:0] = 
	end*/

	always @(posedge clk);
	begin
      if(reset)  
      	begin 
          for(c=0;c<outputsize;c=c+1)
          begin 
            for(d=0;d<outputsize;c=c+1)
              begin 
                overlap_data[c][d]<=64'b0;
              end 
          end
          cyclenumber<=0;
      	end  
	     if (control) begin
		//wt_path_out <= wt_path_in;
      		overlap_data<=overlap_data2;
           	cyclenumber<=cyclenumber+1;
         end
    end 


endmodule