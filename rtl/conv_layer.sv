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
   input  logic [DATA_WIDTH-1:0]  image      [0:IMGROW-1][0:IMGCOL-1],
   input  logic [KDATA_WIDTH-1:0] kernel     [0:KERNEL_SIZE-1] [0:KERNEL_SIZE-1],  // {(sign_bit) + 1.6f} format
   output logic [DATA_WIDTH-1:0]  conv_out   [0:IMGROW-KERNEL_SIZE][0:IMGCOL-KERNEL_SIZE],
   output logic                   layer_done_out
);

localparam PAD_SIZE = (KERNEL_SIZE-1)/2;

logic [DATA_WIDTH-1:0]  img_window [0:KERNEL_SIZE*KERNEL_SIZE-1];
logic [KDATA_WIDTH-1:0] ker_window [0:KERNEL_SIZE*KERNEL_SIZE-1];

logic [$clog2(IMGCOL)-1:0] col;
logic [$clog2(IMGROW)-1:0] row;
logic [$clog2(IMGCOL-KERNEL_SIZE):0] out_col;
logic [$clog2(IMGROW-KERNEL_SIZE):0] out_row;

logic en_convolve, layer_conv_done;
logic [DATA_WIDTH-1:0]  activated_feature;

// ROW and COL counter
always_ff@(posedge clk or negedge rst) begin
   if (~rst) begin
      row <= 'h0;
      col <= 'h0;
      layer_conv_done <= 1'b0;
   end
   else begin
      if (row == IMGROW) begin
         row <= 'h0;
         col <= 'h0;
         layer_conv_done <= 1'b1;
      end else if (col==IMGCOL-1) begin
         row <= row+'h1;
         col <= 'h0;
      end else begin
         col <= col+'h1;
         layer_conv_done <= 1'b0;
      end
   end
end

assign layer_done_out = layer_conv_done;

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
      if (row>PAD_SIZE-1 && row<IMGROW-PAD_SIZE &&  // Top and Bottom lines
          col>PAD_SIZE-1 && col<IMGCOL-PAD_SIZE)   // Left and Right lines
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

// perform convolution on the windowed image
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
   .feature_map  (activated_feature),
   .feature_out  (feature_out)
);

// ROW and COL counter for output image
// because the size of the output image will be different from the input
always_ff@(posedge clk or negedge rst) begin
   if (~rst) begin
      out_row <= 'h0;
      out_col <= 'h0;
   end
   // added layer_conv_done to get proper results for the next convolution as well.
   else if (feature_out || layer_conv_done) begin
      if (out_row == IMGROW-KERNEL_SIZE+1 || layer_conv_done) begin
         out_row <= 'h0;
         out_col <= 'h0;
      end else if (out_col==IMGCOL-KERNEL_SIZE) begin
         out_row <= out_row+'h1;
         out_col <= 'h0;
      end else begin
         out_col <= out_col+'h1;
      end
   end
end

// assign the outputs at proper location
always_ff@(posedge clk or negedge rst) begin
   if (~rst) begin
      conv_out <= '{default: 'h0};
   end else begin
      conv_out[out_row][out_col] <= activated_feature;
   end
end
endmodule