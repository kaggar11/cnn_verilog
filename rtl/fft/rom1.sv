/////////////////////////////////////////////////
//  Author:     Rohon
//  Date:       12:32 PM 12/1/2023
//
//  File name:  rom.sv
//  Description: Read the twiddle factors from file and initialize the rom
//  Latency :
/////////////////////////////////////////////////


module rom1 #(parameter ADDR_WIDTH = 9,
             parameter DATA_WIDTH = 18
   )(
   input               clk,
   input               rst,
   input               rd_en,
   input       [ADDR_WIDTH-1:0] address,
   output logic[DATA_WIDTH-1:0] out_real,
   output logic[DATA_WIDTH-1:0] out_imag
);

localparam REAL_INIT_FILE = "../tfm_dat/real_512_LUT2.txt";
localparam IMAG_INIT_FILE = "../tfm_dat/image_512_LUT2.txt";

// need $readmemh or $readmemb to initialize all of the elements
// declare 2-dimensional array, W-bits width, 2**A depth
logic [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] rom_real;
logic [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] rom_imag;

   initial begin		                  // load from external text file
      if (REAL_INIT_FILE != "")
         $readmemh(REAL_INIT_FILE,rom_real);
      if (IMAG_INIT_FILE != "")
         $readmemh(REAL_INIT_FILE,rom_imag);
   end

   always_ff @(posedge clk, negedge rst) begin
      if (~rst) begin
         out_real <= 'h0;
         out_imag <= 'h0;
      end else if (rd_en) begin
         out_real <= rom_real[address];
         out_imag <= rom_imag[address];
      end
   end

endmodule
