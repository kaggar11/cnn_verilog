/////////////////////////////////////////////////
//  Author:     Kartik
//  Date:       8:42 AM 10/21/2023
//  
//  File name:  radix22_top.sv
//  Description: Top module
//  Latency : 
/////////////////////////////////////////////////

module radix22_top # (
   parameter FFT_OR_IFFT = "FFT",
   parameter ADDR_WIDTH  = 9,
   parameter ROM_WIDTH   = 18,
   parameter DATA_WIDTH  = 16,
   parameter N_POINTS    = 16
) (
   input                   clk,
   input                   rst,
   input                   en,
   input  [DATA_WIDTH-1:0] a_re,
   input  [DATA_WIDTH-1:0] a_im,
   output                  b_val,
   output [DATA_WIDTH-1:0] b_re,
   output [DATA_WIDTH-1:0] b_im
);

localparam LOG2N_BITS = $clog2(N_POINTS);
localparam LN_N = $ln(N_POINTS);
localparam LN_4 = $ln(4);
localparam LOG4N_BITS = LN_N/LN_4; // log4(N) = ln(N)/ln(4) from log base change rule
localparam ROM_BITS_ADJUST = ADDR_WIDTH - LOG2N_BITS; // The maximum supported N-points based on 
                                                      // our ROM is 512. Currently, since we are only
                                                      // doing 16-points, this needs to read the adjusted addresses.

logic [LOG2N_BITS-1:0] control_bus;
logic [0:LOG4N_BITS-1][ROM_WIDTH-1:0] sin_theta;
logic [0:LOG4N_BITS-1][ROM_WIDTH-1:0] cos_theta;
logic [0:LOG4N_BITS]  [DATA_WIDTH-1:0] bfi_a_re_in;
logic [0:LOG4N_BITS]  [DATA_WIDTH-1:0] bfi_a_im_in;
logic [0:LOG4N_BITS-1]                 bfi_a_val;
logic [0:LOG4N_BITS-1]                 bfi_b_val;
logic [0:LOG4N_BITS-1][DATA_WIDTH-1:0] bfi_b_re_out;
logic [0:LOG4N_BITS-1][DATA_WIDTH-1:0] bfi_b_im_out;
logic [0:LOG4N_BITS-1][DATA_WIDTH-1:0] bfii_a_re_in;
logic [0:LOG4N_BITS-1][DATA_WIDTH-1:0] bfii_a_im_in;
logic [0:LOG4N_BITS-1]                 bfii_b_val;
logic [0:LOG4N_BITS-1][DATA_WIDTH-1:0] bfii_b_re_out;
logic [0:LOG4N_BITS-1][DATA_WIDTH-1:0] bfii_b_im_out;

logic [0:LOG4N_BITS] control_bus0, control_bus1;
logic control_bus0_q, control_bus1_q;
logic control_bus0_2q, control_bus1_2q;

// Control Unit
log2n_cntr #(
  .LOG2N_BITS      (LOG2N_BITS)
) u_log2n_cntr (
  .clk             (clk),
  .rst             (rst),
  .en              (en),
  .control_bus     (control_bus)
);


// hardcoding the delays according to a 16-point fft for now. 
// TODO: this delays needs to be parameterized in future
always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      control_bus0 <= 1'b0;
      control_bus1 <= 1'b0;
   end else begin
      control_bus0[0] <= control_bus[3];
      control_bus1[0] <= control_bus[2];
      
      // Bug Fix: logically here the control0 should
      // have double the freq than the control2.
      control_bus0_q  <= control_bus[1];
      control_bus1_q  <= control_bus[0];
      control_bus0_2q <= control_bus0_q;
      control_bus1_2q <= control_bus1_q;
      control_bus0[1] <= control_bus0_2q;
      control_bus1[1] <= control_bus1_2q;
   end
end


always_comb begin
   bfi_a_re_in[0] = a_re;
   bfi_a_im_in[0] = a_im;
   bfi_a_val[0] = 1'b1;
   for (int st=0; st<LOG4N_BITS; st++) begin
      bfii_a_re_in[st] = bfi_b_re_out[st];
      bfii_a_im_in[st] = bfi_b_im_out[st];
   end
end


// Stages for Radix2^2 Processor
genvar stage;
generate
   for (stage=0; stage<LOG4N_BITS; stage++) begin
      // bfi initialization
      bfi #(
        .DATA_WIDTH      (DATA_WIDTH),
        .N_POINTS        (N_POINTS),
        .STAGE           (stage)
      ) u_bfi (
        .clk             (clk),
        .rst             (rst),
        .en              (en && bfi_a_val[stage]),
        .control_bit     (control_bus[LOG2N_BITS-1-2*stage]),
        .a_re            (bfi_a_re_in[stage]),
        .a_im            (bfi_a_im_in[stage]),
        .b_val           (bfi_b_val[stage]),
        .b_re            (bfi_b_re_out[stage]),
        .b_im            (bfi_b_im_out[stage])
      );
      
      // bfii initialization
      bfii #(
        .DATA_WIDTH      (DATA_WIDTH),
        .N_POINTS        (N_POINTS),
        .STAGE           (stage)
      ) u_bfii (
        .clk             (clk),
        .rst             (rst),
        .en              (en && bfi_b_val[stage]),
        // .control1_bit    (control_bus[LOG2N_BITS-1-2*stage]),
        // .control2_bit    (control_bus[LOG2N_BITS-1-2*stage-1]),
        .control1_bit    (control_bus0[stage]),
        .control2_bit    (control_bus1[stage]),
        .a_re            (bfii_a_re_in[stage]),
        .a_im            (bfii_a_im_in[stage]),
        .b_val           (bfii_b_val[stage]),
        .b_re            (bfii_b_re_out[stage]),
        .b_im            (bfii_b_im_out[stage])
      );
      
      // RAM to lookup for twiddle factors
      // input = control_bus
      // output = ram output (both sin and cos)
      // TODO (Rohon): instantiate the module to read the ram values here
      rom #(
         .ADDR_WIDTH    (ADDR_WIDTH),
         .DATA_WIDTH    (ROM_WIDTH)
      ) u_rom (
         .clk           (clk),
         .rst           (rst),
         .rd_en         (bfii_b_val[stage]),
         .address       ({control_bus,{ROM_BITS_ADJUST{1'b0}}}),
         .out_real      (cos_theta[stage]),
         .out_imag      (sin_theta[stage])
      );
      
      // TFM unit initialization
      tfm #(
         .FFT_OR_IFFT    (FFT_OR_IFFT),
         .DATA_WIDTH     (DATA_WIDTH),
         .ROM_WIDTH      (ROM_WIDTH)
      ) u_tfm (
        .clk             (clk),
        .rst             (rst),
        .en              (en && bfii_b_val[stage]),
        .sin_theta       (sin_theta[stage]),
        .cos_theta       (cos_theta[stage]),
        .data_re         (bfii_b_re_out[stage]),
        .data_im         (bfii_b_im_out[stage]),
        .out_val         (bfi_a_val[stage+1]),
        .out_re          (bfi_a_re_in[stage+1]),
        .out_im          (bfi_a_im_in[stage+1])
      );
   end
endgenerate

// output assignment. No twiddle factor multiply in the last stage.
assign b_val = bfi_a_val[LOG4N_BITS-1];
assign b_re  = bfi_a_re_in[LOG4N_BITS-1];
assign b_im  = bfi_a_im_in[LOG4N_BITS-1];

endmodule