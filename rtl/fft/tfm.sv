/////////////////////////////////////////////////
//  Author:     Kartik
//  Date:       12:28 PM 10/21/2023
//  
//  File name:  tfm.sv
//  Description: Twiddle factor multiplier unit
//  Latency : 2
/////////////////////////////////////////////////

module tfm # (
   parameter FFT_OR_IFFT = "FFT",
   parameter DATA_WIDTH  = 16,
   parameter ROM_WIDTH   = 18
)(
   input clk,
   input rst,
   input en,
   input [ROM_WIDTH-1:0]  sin_theta,
   input [ROM_WIDTH-1:0]  cos_theta,
   input [DATA_WIDTH-1:0] data_re,
   input [DATA_WIDTH-1:0] data_im,
   output logic [DATA_WIDTH-1:0] out_re,
   output logic [DATA_WIDTH-1:0] out_im,
   output logic                  out_val
);

logic en_q;
logic [ROM_WIDTH+DATA_WIDTH-1:0] sin_re_c, sin_re_q;
logic [ROM_WIDTH+DATA_WIDTH-1:0] cos_re_c, cos_re_q;
logic [ROM_WIDTH+DATA_WIDTH-1:0] sin_im_c, sin_im_q;
logic [ROM_WIDTH+DATA_WIDTH-1:0] cos_im_c, cos_im_q;
logic [ROM_WIDTH+DATA_WIDTH:0] add_re_c;
logic [ROM_WIDTH+DATA_WIDTH:0] sub_im_c;

assign sin_im_c = sin_theta*data_im;
assign sin_re_c = sin_theta*data_re;
assign cos_im_c = cos_theta*data_im;
assign cos_re_c = cos_theta*data_re;

if (FFT_OR_IFFT=="FFT") begin
   assign add_re_c = sin_re_q - cos_im_q;
   assign sub_im_c = sin_im_q + cos_re_q;
end else if (FFT_OR_IFFT == "IFFT") begin
   assign add_re_c = sin_re_q + cos_im_q;
   assign sub_im_c = sin_im_q - cos_re_q;
end

always_ff@(posedge clk) begin
   en_q <= en;
end

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      sin_re_q <= 'h0;
      cos_re_q <= 'h0;
      sin_im_q <= 'h0;
      cos_im_q <= 'h0;
   end else if (en) begin
      sin_re_q <= sin_im_c;
      cos_re_q <= sin_re_c;
      sin_im_q <= cos_im_c;
      cos_im_q <= cos_re_c;
   end
end

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      out_re  <= 'h0;
      out_im  <= 'h0;
      out_val <= 1'b0;
   end else if (en_q) begin
      out_re  <= add_re_c[DATA_WIDTH-1:0];
      out_im  <= sub_im_c[ROM_WIDTH+DATA_WIDTH:ROM_WIDTH];
      out_val <= 1'b1;
   end else
      out_val <= 1'b0;
end

endmodule