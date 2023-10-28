`timescale 1ns/1ns

module tb_bfi();

  // parameters
  parameter RUN_TIME             = 500; // ps
  parameter DUT_CLK_HALF_PER_NS  = 5;
  parameter DATA_WIDTH           = 16;
  parameter N_POINTS             = 16;
  parameter STAGE                = 0;

  // variables
  logic dut_clk;
  logic rst;
  logic control_bit, en, b_val;
  logic [DATA_WIDTH-1:0] a_re;
  logic [DATA_WIDTH-1:0] a_im;
  logic [DATA_WIDTH-1:0] b_re;
  logic [DATA_WIDTH-1:0] b_im;
  
  localparam TB_BUF_SIZE = N_POINTS/(1<<(2*STAGE+1));
  
  logic [DATA_WIDTH-1:0] tb_buf_re [0:TB_BUF_SIZE-1];
  logic [DATA_WIDTH-1:0] tb_buf_im [0:TB_BUF_SIZE-1];
  
  // instantiate DUT
  bfi #(
    .DATA_WIDTH      (DATA_WIDTH),
    .N_POINTS        (N_POINTS),
    .STAGE           (STAGE)        // The stage we are trying to simulate
  ) x_bfi (
    .clk             ( dut_clk   ), // 100 MHz for Basys3
    .rst             ( rst       ), // 
    .en              ( en        ), // 
    .control_bit     ( control_bit), // 
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
      control_bit = 1'b0;
      #(2*DUT_CLK_HALF_PER_NS * 1ns);
      repeat (N_POINTS/2) begin
         @(posedge dut_clk);
         control_bit = 1'b0;
      end
      repeat (N_POINTS/2) begin
         @(posedge dut_clk);
         control_bit = 1'b1;
      end
      repeat (N_POINTS/2) begin
         @(posedge dut_clk);
         control_bit = 1'b0;
      end
      repeat (N_POINTS/2) begin
         @(posedge dut_clk);
         control_bit = 1'b1;
      end
   end

   initial begin
      $display("[INFO] time:%0d, u_bfi[0].BUF_SIZE:%0d", $time, x_bfi.BUF_SIZE);
      $display("[INFO] time:%0d, u_bfii[0].BUF_SIZE:%0d", $time, x_bfi.BUF_BITS);
   end

   initial begin
      forever begin
      @(posedge dut_clk);
         if (b_val) begin
            $display("[IMAG_OUT] time:%0d, b_im:%h",$time, b_im);
            $display("[REAL_OUT] time:%0d, b_re:%h",$time, b_re);
         end
      end
   end

   initial begin
      forever begin
      @(posedge dut_clk);
         $display("[BUF_RE] time:%0d, buf_re:%h",$time, feedback_regs_re);
         $display("[BUF_IM] time:%0d, buf_im:%h",$time, feedback_regs_im);
      end
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
