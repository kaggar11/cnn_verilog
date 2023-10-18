/////////////////////////////////////////////////
//  Author:     Kartik
//  Date:       9:13 AM 10/18/2023
//  
//  File name:  bfi.sv
//  Description: A Radix-2 butterfly module
//  Latency : 
/////////////////////////////////////////////////

module bfi # (
   parameter DATA_WIDTH=16,
   parameter DEPTH=4         
)(
   input clk,
   input rst,
   input en,
   input control_bit,                            // 0-fill buffer, 1-add/subtract output
   input [DATA_WIDTH-1:0] a_re,                  // real part of input data
   input [DATA_WIDTH-1:0] a_im,                  // imaginary part of input data
   output logic [DATA_WIDTH-1:0] b_re,           // real part of output data
   output logic [DATA_WIDTH-1:0] b_im            // imaginary part of output data
);

logic [DATA_WIDTH-1:0] feedback_regs_re [0:DEPTH-1];
logic [DATA_WIDTH-1:0] feedback_regs_im [0:DEPTH-1];

logic [$clog2(DEPTH)-1:0] cntr_write_c, cntr_write_q;
logic [$clog2(DEPTH)-1:0] cntr_read_c, cntr_read_q;

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      feedback_regs_re <= '{default: 'h0};
      feedback_regs_im <= '{default: 'h0};
   end else begin
      if (control_bit) begin
         b_re <= a_re + feedback_regs_re[cntr_read_q];
         b_im <= a_im + feedback_regs_im[cntr_read_q];
      end else if (en) begin
         feedback_regs_re[cntr_write_q] <= a_re;
         feedback_regs_im[cntr_write_q] <= a_im;
      end
   end
end

// both read/write begin from 0 with an increment of one. FIFO-like implementation of feedback_regs*
assign cntr_write_c = (control_bit & en) ? 'h0 : cntr_write_q + 1'b1; // when control=0, we are filling the feedback_regs*
assign cntr_read_c  = (control_bit & en)? cntr_read_q + 1'b1 : 'h0;  // when control=1, we are reading from the feedback_regs*

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      cntr_write_q <= 'h0;
      cntr_read_q  <= 'h0;
   end else if (en) begin
      cntr_write_q <= cntr_write_c;
      cntr_read_q  <= cntr_read_c;
   end
end
