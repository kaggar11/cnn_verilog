/////////////////////////////////////////////////
//  Author:     Kartik
//  Date:       10:53 AM 9/1/2023
//  
//  File name:  conv_layer.sv
//  Description: To convolve an image with a kernel
//  Latency : 
/////////////////////////////////////////////////

module conv_layer # (parameter KERNEL_SIZE = 3,
                     parameter IMGCOL      = 32,
                     parameter IMGROW      = 32,
                     parameter DATA_WIDTH  = 8,
                     parameter KDATA_WIDTH = 8,
                     parameter ACTIVATION  = "RELU")
(
   input  logic                   clk,
   input  logic                   rst,
   input  logic [DATA_WIDTH-1:0]  image      [IMGROW-1][IMGCOL-1],
   input  logic [KDATA_WIDTH-1:0] kernel     [KERNEL_SIZE-1] [KERNEL_SIZE-1],  // {(sign_bit) + 1.6f} format
   output logic [DATA_WIDTH-1:0]  conv_out
);

localparam PAD_SIZE = (KERNEL_SIZE-1)/2;

logic [DATA_WIDTH-1:0]  img_window [KERNEL_SIZE*KERNEL_SIZE-1:0];
logic [KDATA_WIDTH-1:0] ker_window [KERNEL_SIZE*KERNEL_SIZE-1:0];

logic [$clog2(IMGCOL)-1:0] col, col_q1, col_q2;
logic [$clog2(IMGROW)-1:0] row, row_q1, row_q2;

logic en_convolve;

// ROW and COL counter
always_ff@(posedge clk or negedge rst) begin
   if (~rst) begin
      row <= 'h0;
      col <= 'h0;
   end
   else begin
      if (row == IMGROW-1) begin
         row <= 'h0;
         col <= 'h0;
      end else if (col==IMGCOL-1) begin
         row <= row+'h1;
         col <= 'h0;
      end else begin
         col <= col+'h1;
      end
   end
end

always_ff@(posedge clk) begin
   row_q1 <= row;
   row_q2 <= row_q1;
   col_q1 <= col;
   col_q2 <= col_q1;
end

always_comb begin
   for (int i=0; i<KERNEL_SIZE; i=i+1) begin // row iteration
      for (int j=0; j<KERNEL_SIZE; j=j+1) begin  // col iteration
         ker_window[i*KERNEL_SIZE+j] = kernel[i][j];
      end
   end
end

// block to extract KERNEL_SIZE * KERNEL_SIZE windows from the input image
always_ff@(posedge clk or negedge rst) begin
   if (~rst) begin
      img_window  <= '{default: 'h0};
      en_convolve <= 1'b0;
   end else begin
      if ((row>PAD_SIZE-1      && col>PAD_SIZE-1)      ||  // Top Left corners
          (row>PAD_SIZE-1      && col<IMGCOL-PAD_SIZE) ||  // Top Right corners
          (row<IMGROW-PAD_SIZE && col>PAD_SIZE-1)      ||  // Bottom Left corners
          (row<IMGROW-PAD_SIZE && col<IMGCOL-PAD_SIZE)  )  // Bottom Right corners
      begin
         en_convolve <= 1'b1;
         for (int i=0; i<KERNEL_SIZE; i=i+1) begin // row iteration
            for (int j=0; j<KERNEL_SIZE; j=j+1) begin  // col iteration
               img_window[i*KERNEL_SIZE+j] <= image[row-PAD_SIZE+i][col-PAD_SIZE+j];
            end
         end
      end else begin
         en_convolve <= 1'b0;
         img_window  <= '{default: 'h0};
      end
   end
end

convolve #(
   .KERNEL_SIZE (KERNEL_SIZE*KERNEL_SIZE),
   .DATA_WIDTH  (DATA_WIDTH),
   .KDATA_WIDTH (KDATA_WIDTH),
   .ACTIVATION  (ACTIVATION)
) u_convolve (
   .clk          (clk),
   .rst          (rst),
   .en_convolve  (en_convolve),
   .image        (img_window),
   .kernel       (ker_window),
   .feature_map  (conv_out)
);


endmodule