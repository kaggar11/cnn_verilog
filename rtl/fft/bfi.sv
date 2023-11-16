/////////////////////////////////////////////////
//  Author:     Kartik
//  Date:       9:13 AM 10/18/2023
//  
//  File name:  bfi.sv
//  Description: A Radix-2 butterfly module
//  Latency : 
/////////////////////////////////////////////////

module bfi # (
   parameter DATA_WIDTH     = 16,
   parameter N_POINTS       = 16,
   parameter STAGE          = 4                          // Stage of the module to find the depth for Buffers
)(
   input                         clk,
   input                         rst,
   input                         en,
   input                         control_bit,            // 0-fill buffer, 1-add/subtract output
   input  [DATA_WIDTH-1:0]       a_re,                   // real part of input data
   input  [DATA_WIDTH-1:0]       a_im,                   // imaginary part of input data
   output logic                  b_val,                  // Output is valid flag
   output logic [DATA_WIDTH-1:0] b_re,                   // real part of output data
   output logic [DATA_WIDTH-1:0] b_im                    // imaginary part of output data
);

localparam BUF_SIZE = N_POINTS/(1<<(2*STAGE+1)); // Total FIFO/Buffer Size Needed
localparam BUF_BITS = $clog2(BUF_SIZE);

logic [0:BUF_SIZE-1][DATA_WIDTH-1:0] feedback_regs_re;
logic [0:BUF_SIZE-1][DATA_WIDTH-1:0] feedback_regs_im;

logic [BUF_BITS:0] cntr_write_q, cntr_read_q;
logic cntr_wr_en, cntr_wr_en_q;
logic cntr_wr_msb, cntr_wr_msb_re, cntr_rd_en;

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      feedback_regs_re  <= '{default: 'h0};
      feedback_regs_im  <= '{default: 'h0};
      b_re              <= 'h0;
      b_im              <= 'h0;
   end else if (en) begin
      if (control_bit) begin
         b_re <= a_re + feedback_regs_re[cntr_read_q[BUF_BITS-1:0]];
         b_im <= a_im + feedback_regs_im[cntr_read_q[BUF_BITS-1:0]];
         if (cntr_wr_en || cntr_wr_en_q) begin
            feedback_regs_re[cntr_write_q[BUF_BITS-1:0]] <= a_re - feedback_regs_re[cntr_read_q[BUF_BITS-1:0]];
            feedback_regs_im[cntr_write_q[BUF_BITS-1:0]] <= a_im - feedback_regs_im[cntr_read_q[BUF_BITS-1:0]];
         end
      end else begin
         b_re <= feedback_regs_re[cntr_read_q[BUF_BITS-1:0]];
         b_im <= feedback_regs_im[cntr_read_q[BUF_BITS-1:0]];
         if (cntr_wr_en || cntr_wr_en_q) begin
            feedback_regs_re[cntr_write_q[BUF_BITS-1:0]] <= a_re;
            feedback_regs_im[cntr_write_q[BUF_BITS-1:0]] <= a_im;
         end
      end
   end
end

assign cntr_wr_en = en & ~(&cntr_write_q);
assign cntr_wr_msb_re = cntr_write_q[BUF_BITS] && ~cntr_wr_msb;

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      cntr_wr_msb  <= 1'b0;
      cntr_rd_en   <= 1'b0;
      cntr_wr_en_q <= 1'b0;
   end else begin
      cntr_wr_msb <= cntr_write_q[BUF_BITS];
      cntr_wr_en_q <= cntr_wr_en;
      
      if (cntr_wr_msb_re)    cntr_rd_en <= 1'b1;
      else if (&cntr_read_q) cntr_rd_en <= 1'b0;
   end
end

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      cntr_write_q <= 'h0;
      cntr_read_q  <= 'h0;
   end else if (en) begin
      if (&cntr_write_q) cntr_write_q <= cntr_write_q;
      else               cntr_write_q <= cntr_write_q + 1'b1;
      
      if (&cntr_read_q)    cntr_read_q <= cntr_read_q;
      else if (cntr_rd_en) cntr_read_q <= cntr_read_q + 1'b1;
   end
end

assign b_val = cntr_rd_en;

endmodule
