// Code your testbench here
// or browse Examples

//Samarth Singh <ssing258@asu.edu>
//Wed, Nov 29, 1:10 PM (4 days ago)
//to me

// Code your testbench here
// or browse Examples


`timescale 1ns / 1ps
module test_OVA;

// Inputs
        parameter num_block_root=4;
  		parameter size=5;
  		parameter overlap=size-1;
		logic clk;
		logic control;
    	logic reset;
  logic [31:0] blocks_in [0:((num_block_root*num_block_root)-1)][0:(size-1)][0:(size-1)];
  		int block_num;
  		int row;
  		int col;

// Outputs
  	parameter outputsize=((num_block_root)*size)-((num_block_root-1)*overlap);
  logic [31:0] overlap_data [0:(outputsize-1)][0:(outputsize-1)];
// Instantiate the Unit Under Test (UUT)
  OVA #(.num_block_root(num_block_root),.size(size),.overlap(overlap)) uut(.clk(clk),.control(control),.reset(reset),.blocks_in(blocks_in),.overlap_data(overlap_data));


  
  
		initial begin
// Initialize Inputs
          $display("Starting ghfhgfhgfh");
          //$finish;
			clk = 0;
			control = 0;
			reset = 1;
            @(posedge clk);
          $display("Starting clk= %0d",clk);
      
  			for(block_num=0;block_num<num_block_root*num_block_root;block_num=block_num+1) begin 
              for(row=0;row<size;row=row+1) begin 
                for(col=0;col<size;col=col+1) begin 
                  blocks_in[block_num][row][col]='d3;
             //     $display("block_in[%d][%d][%d]=%0d",block_num,row,col,blocks_in[block_num][row][col]);
      			    end 
    		    end
            end
            //$finish;
          $display("111gfhgfValue of control=%0d and reset=%0d and time:%t",control,reset,$time);

        
          $display("111Value of control=%0d and reset=%0d and time:%t",control,reset,$time);
//    @(posedge clk);
           reset = 0;
            control=1;
          $display("Value of control=%0d and reset=%0d and time:%t",control,reset,$time);
          //$finish;
            #13000;
          $display("Finished!!!");
          //$finish;
          for(row=0;row<outputsize;row=row+1) begin 
            for(col=0;col<outputsize;col=col+1)  begin 
              $display("This is overlap_data[%0d][%0d]=%0d",row,col,overlap_data[row][col]);
            end 
          end 
            $finish;
           end 
//blocks_in[0+:4][0+:3][0+:3] = 0;

// Wait 100 ns for global reset to finish
//#5000;
//       end
// Add stimulus here
           always begin
			#250 clk=!clk;
			end
//initial begin
//@(posedge clk);
//control=1;
//reset  =0;
//blocks_in[0][0+:3][0+:3] = 64'b1;
//end
     
endmodule
