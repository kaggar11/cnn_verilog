/////////////////////////////////////////////////
//  Author:     Kartik
//  Date:       12:28 PM 10/21/2023
//  
//  File name:  tfm.sv
//  Description: Twiddle factor multiplier unit
//  Latency : 2
/////////////////////////////////////////////////

module tfm # (
   parameter DATA_WIDTH=16
)(
   input clk,
   input rst,
   input en,
   input [DATA_WIDTH-1:0] sin_theta,
   input [DATA_WIDTH-1:0] cos_theta,
   input [DATA_WIDTH-1:0] data_re,
   input [DATA_WIDTH-1:0] data_im,
   output logic [DATA_WIDTH-1:0] out_re,
   output logic [DATA_WIDTH-1:0] out_im
);

logic [2*DATA_WIDTH-1:0] sin_re_c, sin_re_q;
logic [2*DATA_WIDTH-1:0] cos_re_c, cos_re_q;
logic [2*DATA_WIDTH-1:0] sin_im_c, sin_im_q;
logic [2*DATA_WIDTH-1:0] cos_im_c, cos_im_q;
logic [2*DATA_WIDTH-1:0] add_re_c;
logic [2*DATA_WIDTH-1:0] sub_im_c;
logic [DATA_WIDTH-1:0]   add_re_q;
logic [DATA_WIDTH-1:0]   sub_im_q;

assign sin_im_c = sin_theta*data_im;
assign sin_re_c = sin_theta*data_re;
assign cos_im_c = cos_theta*data_im;
assign cos_re_c = cos_theta*data_re;

assign add_re_c = sin_re_q - cos_im_q;
assign sub_im_c = sin_im_q + cos_re_q;

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      sin_re_q <= 'h0;
      cos_re_q <= 'h0;
      sin_im_q <= 'h0;
      cos_im_q <= 'h0;
      add_re_q <= 'h0;
      sub_im_q <= 'h0;
   end else if (en) begin
      sin_re_q <= sin_im_c;
      cos_re_q <= sin_re_c;
      sin_im_q <= cos_im_c;
      cos_im_q <= cos_re_c;
      add_re_q <= add_re_c[DATA_WIDTH-1:0];
      sub_im_q <= sub_im_c[DATA_WIDTH-1:0];
   end
end

assign out_re = add_re_q;
assign out_im = sub_im_q;
endmodule