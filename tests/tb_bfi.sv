`timescale 1ns/1ns

module tb_bfi();

  // parameters
  parameter RUN_TIME             = 1_000; // ps
  parameter DUT_CLK_HALF_PER_NS  = 5;
  parameter DATA_WIDTH           = 16;
  parameter N_POINTS             = 16;

  // variables
  logic dut_clk;
  logic rst;
  logic control_bit, en;
  logic [DATA_WIDTH-1:0] a_re;
  logic [DATA_WIDTH-1:0] a_im;
  logic [DATA_WIDTH-1:0] b_re;
  logic [DATA_WIDTH-1:0] b_im;
  
  // instantiate DUT
  bfi #(
    .DATA_WIDTH      (DATA_WIDTH),
    .DEPTH           (N_POINTS/2)
  ) x_bfi (
    .clk             ( dut_clk   ), // 100 MHz for Basys3
    .rst             ( rst       ), // 
    .en              ( en        ), // 
    .control_bit     ( control_bit), // 
    .a_re            ( a_re      ), // 
    .a_im            ( a_im      ), // 
    .b_re            ( b_re      ), // 
    .b_im            ( b_im      )  // 
  );
  
  

   initial begin : tb_threads
      dut_clk = 1'b0;
      rst = 1'b0;
      en = 1'b0;
      fork
         begin
            #(DUT_CLK_HALF_PER_NS * 1ns);
            rst = 1'b1;
            en = 1'b1;
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
      #(2*DUT_CLK_HALF_PER_NS * 1ns);
      @(posedge dut_clk);
      control_bit=0;
      a_re=$urandom();
      a_im=$urandom();

      @(posedge dut_clk);
      a_re=$urandom();
      a_im=$urandom();

      @(posedge dut_clk);
      a_re=$urandom();
      a_im=$urandom();

      @(posedge dut_clk);
      a_re=$urandom();
      a_im=$urandom();

      @(posedge dut_clk);
      control_bit=1;
      a_re=$urandom();
      a_im=$urandom();

      @(posedge dut_clk);
      a_re=$urandom();
      a_im=$urandom();

      @(posedge dut_clk);
      a_re=$urandom();
      a_im=$urandom();

      @(posedge dut_clk);
      a_re=$urandom();
      a_im=$urandom();
   end

   initial begin
      forever begin
      @(posedge dut_clk);
         $display("[REAL_OUT] b_re:%h",b_re);
         $display("[IMAG_OUT] b_im:%h",b_im);
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
