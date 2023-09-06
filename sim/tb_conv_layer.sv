module tb_conv_layer();


  // parameters
  localparam DUT_CLK_HALF_PER_NS = 5;
  localparam KERNEL_SIZE = 2;
  localparam IMGCOL      = 3;
  localparam IMGROW      = 7;
  localparam DATA_WIDTH  = 8;
  localparam KDATA_WIDTH = 8;
  localparam ACTIVATION  = "RELU";
  
  // variables
  logic dut_clk;
  logic rst;
  logic signed [DATA_WIDTH-1:0]  image      [0:IMGROW-1] [0:IMGCOL-1];
  logic signed [KDATA_WIDTH-1:0] kernel     [0:KERNEL_SIZE-1] [0:KERNEL_SIZE-1];

  // instantiate DUT
  conv_layer #(
    .DATA_WIDTH     (DATA_WIDTH),
    .KDATA_WIDTH    (KDATA_WIDTH),
    .KERNEL_SIZE    (KERNEL_SIZE),
    .ACTIVATION     (ACTIVATION),
    .IMGCOL         (IMGCOL),
    .IMGROW         (IMGROW)
  ) x_dut (
    .clk      ( dut_clk   ), // 100 MHz for Basys3
    .rst      ( rst       ), // 
    .image    ( image     ), // 
    .kernel   ( kernel    ), // 
    .conv_out (           )
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

  initial begin : test_thread
    image = {{'hfe,'h04,'hff}, 
             {'h04,'h01,'hff}, 
             {'h01,'h06,'hff}, 
             {'h02,'h04,'hff}, 
             {'h06,'h02,'hff}, 
             {'h06,'h01,'hff}, 
             {'h01,'h02,'hff}};
    kernel = {{'h02,'hf2}, 
              {'hfc,'hfe}};
  end : test_thread
 
 endmodule