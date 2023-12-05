`timescale 1ns/1ns

module tb_radix22_top();

  // parameters
  parameter RUN_TIME             = 500; // ns
  parameter DUT_CLK_HALF_PER_NS  = 5;
  parameter DATA_WIDTH           = 16;
  parameter N_POINTS             = 16;

  // variables
  logic dut_clk;
  logic rst;
  logic en;
  logic [DATA_WIDTH-1:0] a_re;
  logic [DATA_WIDTH-1:0] a_im;
  logic                  b_val;
  logic [DATA_WIDTH-1:0] b_re;
  logic [DATA_WIDTH-1:0] b_im;
  
  // instantiate DUT
  radix22_top #(
    .DATA_WIDTH      (DATA_WIDTH),
    .N_POINTS        (N_POINTS)
  ) x_radix22_top (
    .clk             ( dut_clk   ), // 100 MHz for Basys3
    .rst             ( rst       ), // 
    .en              ( en        ), // 
    .a_re            ( a_re      ), // 
    .a_im            ( a_im      ), // 
    .b_val           ( b_val     ), // 
    .b_re            ( b_re      ), // 
    .b_im            ( b_im      )  // 
  );
  
  

   initial begin : tb_threads
      dut_clk = 1'b0;
      rst = 1'b0;
      fork
         begin
            #(DUT_CLK_HALF_PER_NS * 1ns);
            rst = 1'b1;
         end
         begin
            forever begin
               #(DUT_CLK_HALF_PER_NS * 1ns);
               dut_clk = ~dut_clk;
            end
         end
      join_none
   end : tb_threads
   

   initial begin
      a_re='h0;
      a_im='h0;
      en = 1'b0;
      #(2*DUT_CLK_HALF_PER_NS * 1ns);
      @(posedge dut_clk);
      en = 1'b1;
      a_re=$urandom();
      a_im=$urandom();

      repeat (N_POINTS-1) begin
         @(posedge dut_clk);
         a_re=$urandom();
         a_im=$urandom();
      end
   end

   initial begin
      forever begin
      @(posedge dut_clk);
         if (b_val) begin
            $display("[REAL_OUT] time:%0d, b_re:%h",$time, b_re);
            $display("[IMAG_OUT] time:%0d, b_im:%h",$time, b_im);
         end
      end
   end

   initial begin
      $display("[INFO] time:%0d, LOG2N_BITS:%0d", $time, x_radix22_top.LOG2N_BITS);
      $display("[INFO] time:%0d, LOG4N_BITS:%0d", $time, x_radix22_top.LOG4N_BITS);
      $display("[INFO] time:%0d, u_bfi[0].BUF_SIZE:%0d", $time, x_radix22_top.genblk1[0].u_bfi.BUF_SIZE);
      $display("[INFO] time:%0d, u_bfii[0].BUF_SIZE:%0d", $time, x_radix22_top.genblk1[0].u_bfii.BUF_SIZE);
      $display("[INFO] time:%0d, u_bfi[1].BUF_SIZE:%0d", $time, x_radix22_top.genblk1[1].u_bfi.BUF_SIZE);
      $display("[INFO] time:%0d, u_bfii[1].BUF_SIZE:%0d", $time, x_radix22_top.genblk1[1].u_bfii.BUF_SIZE);
      $display("[INFO] time:%0d, u_bfi[0].BUF_BITS:%0d", $time, x_radix22_top.genblk1[0].u_bfi.BUF_BITS);
      $display("[INFO] time:%0d, u_bfii[0].BUF_BITS:%0d", $time, x_radix22_top.genblk1[0].u_bfii.BUF_BITS);
      $display("[INFO] time:%0d, u_bfi[1].BUF_BITS:%0d", $time, x_radix22_top.genblk1[1].u_bfi.BUF_BITS);
      $display("[INFO] time:%0d, u_bfii[1].BUF_BITS:%0d", $time, x_radix22_top.genblk1[1].u_bfii.BUF_BITS);
      $display("[INFO] time:%0d, u_bfii[0].MAX_BUF_BIT:%0d", $time, x_radix22_top.genblk1[0].u_bfii.MAX_BUF_BIT);
      $display("[INFO] time:%0d, u_bfii[1].MAX_BUF_BIT:%0d", $time, x_radix22_top.genblk1[1].u_bfii.MAX_BUF_BIT);
   end

   initial begin
      finish();
   end

   task finish();
      #(RUN_TIME)
      $display("!!!!!!!!!!!!!!!!!!!!!!!END OF TB!!!!!!!!!!!!!!!!!!!!!!!!!!!!");      
      $finish(1);
   endtask

endmodule
