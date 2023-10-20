`timescale 1ns/1ns

module tb_log2n_cntr();

  // parameters
  parameter RUN_TIME             = 50_000; // ps
  parameter DUT_CLK_HALF_PER_NS  = 5;

  // variables
  logic dut_clk;
  logic rst;
  
  
  // instantiate DUT
  log2n_cntr #(
    .LOG2N_BITS      (8)
  ) x_log2n_cntr (
    .clk             ( dut_clk   ), // 100 MHz for Basys3
    .rst             ( rst       ), // 
    .en              ( 1'b1      ), // 
    .control_bus     (           )
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
      finish();
   end

   task finish();
      #(RUN_TIME)
      $display("!!!!!!!!!!!!!!!!!!!!!!!END OF TB!!!!!!!!!!!!!!!!!!!!!!!!!!!!");      
      $finish(1);
   endtask

endmodule