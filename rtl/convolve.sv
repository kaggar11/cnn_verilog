/////////////////////////////////////////////////
//  Author:     Kartik
//  Date:       11:49 PM 8/31/2023
//  
//  File name:  convolve.sv
//  Description: To multiply the kernel with input window same size as kernel
//  Latency : 2 cycles
/////////////////////////////////////////////////

module convolve #(parameter KERNEL_SIZE = 9,
                  parameter DATA_WIDTH  = 8,
                  parameter KDATA_WIDTH = 8,
                  parameter ACTIVATION  = "RELU")
(
   input  logic                   clk,
   input  logic                   rst,
   input  logic                   en_convolve,
   input  logic  [DATA_WIDTH-1:0] image       [0:KERNEL_SIZE-1],
   input  logic [KDATA_WIDTH-1:0] kernel      [0:KERNEL_SIZE-1], // {(sign_bit) + 0.7f} format
   output logic  [DATA_WIDTH-1:0] feature_map,
   output logic                   feature_out
);

function [DATA_WIDTH-1:0] activation;
   input [DATA_WIDTH+KDATA_WIDTH+$clog2(KERNEL_SIZE)-1:0] weighted_inputs;
   begin
      case(ACTIVATION)
         "RELU": begin
            if (weighted_inputs[DATA_WIDTH+KDATA_WIDTH+$clog2(KERNEL_SIZE)]) activation = 0; // if sign bit, activate it to 0
            else activation = weighted_inputs[DATA_WIDTH+KDATA_WIDTH-2-1:KDATA_WIDTH-2];     // else pass the positive integral part as it is
         end
         "SIGNUM": begin
            if (weighted_inputs[DATA_WIDTH+KDATA_WIDTH+$clog2(KERNEL_SIZE)]) activation = 0; // if sign bit, activate it to 0
            else activation = {DATA_WIDTH{1'b1}};
         end
         default: activation = 'h0;
      endcase
   end
endfunction

function [KDATA_WIDTH-1:0] twos_compl;
   input [KDATA_WIDTH-1:0] kernel;
   twos_compl = (~kernel) + 1;
endfunction

logic en_convolve_q;

logic [DATA_WIDTH+KDATA_WIDTH-1:0] feat_mult_c [0:KERNEL_SIZE-1];
logic [DATA_WIDTH+KDATA_WIDTH-1:0] feat_mult_q [0:KERNEL_SIZE-1];

logic [DATA_WIDTH+KDATA_WIDTH+$clog2(KERNEL_SIZE)-1:0] feature_map_c;

logic [KDATA_WIDTH-1:0] kernel_abs [0:KERNEL_SIZE-1];

always_comb begin
   for (int i=0;i<KERNEL_SIZE; i=i+1) begin
      kernel_abs[i] = kernel[i][KDATA_WIDTH-1] ? twos_compl(kernel[i]) : kernel[i]; // get the absolute values for kernel
   end
end

// Multiplier
always_comb begin
   feat_mult_c = '{default: 'h0};
   for (int i=0; i<KERNEL_SIZE; i=i+1) begin
      feat_mult_c[i][DATA_WIDTH+KDATA_WIDTH-1]     = kernel[i][KDATA_WIDTH-1];                // pass the sign bit
      feat_mult_c[i][DATA_WIDTH+KDATA_WIDTH-2:0]   = image[i]*kernel_abs[i][KDATA_WIDTH-2:0]; // multiply the abs values
   end
end

// Adder
always_comb begin
   feature_map_c = '{default: 'h0};
   for (int i=0; i<KERNEL_SIZE; i=i+1) begin
      feature_map_c = feat_mult_q[i][DATA_WIDTH+KDATA_WIDTH-1] ? feature_map_c - feat_mult_q[i]: // sign bit high means subtract
                                                                 feature_map_c + feat_mult_q[i];  // else add
   end
end

// delay block
always_ff@(posedge clk) begin
   en_convolve_q <= en_convolve;
end

always_ff@(posedge clk, negedge rst) begin
   if (~rst) begin
      feat_mult_q <= '{default: 'h0};
      feature_map <= 'h0;
      feature_out <= 1'b0;
   end
   else begin
      if (en_convolve) begin
         feat_mult_q <= feat_mult_c;
      end
      if (en_convolve_q) begin
         feature_map <= activation(feature_map_c); // passing the integer LSBs without fractional part
         feature_out <= 1'b1;
      end else begin
         feature_map <= 'h0;
         feature_out <= 1'b0;
      end
   end
end


endmodule