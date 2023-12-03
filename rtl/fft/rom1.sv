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

 //  always @* begin		                  // load from external text file

  assign rom_real={'b010000000000000000,
'b001111111111111011,
'b001111111111101100,
'b001111111111010011,
'b001111111110110001,
'b001111111110000100,
'b001111111101001110,
'b001111111100001110,
'b001111111011000100,
'b001111111001110000,
'b001111111000010011,
'b001111110110101011,
'b001111110100111010,
'b001111110010111111,
'b001111110000111011,
'b001111101110101100,
'b001111101100010100,
'b001111101001110011,
'b001111100111000111,
'b001111100100010010,
'b001111100001010011,
'b001111011110001011,
'b001111011010111010,
'b001111010111011110,
'b001111010011111010,
'b001111010000001011,
'b001111001100010100,
'b001111001000010011,
'b001111000100001001,
'b001110111111110101,
'b001110111011011000,
'b001110110110110010,
'b001110110010000011,
'b001110101101001011,
'b001110101000001001,
'b001110100010111111,
'b001110011101101011,
'b001110011000001111,
'b001110010010101010,
'b001110001100111100,
'b001110000111000101,
'b001110000001000110,
'b001101111010111110,
'b001101110100101101,
'b001101101110010100,
'b001101100111110010,
'b001101100001001000,
'b001101011010010101,
'b001101010011011011,
'b001101001100011000,
'b001101000101001101,
'b001100111101111010,
'b001100110110011111,
'b001100101110111011,
'b001100100111010001,
'b001100011111011110,
'b001100010111100100,
'b001100001111100010,
'b001100000111011000,
'b001011111111000111,
'b001011110110101110,
'b001011101110001111,
'b001011100101101000,
'b001011011100111010,
'b001011010100000100,
'b001011001011001000,
'b001011000010000101,
'b001010111000111011,
'b001010101111101011,
'b001010100110010100,
'b001010011100110110,
'b001010010011010010,
'b001010001001100111,
'b001001111111110110,
'b001001110101111111,
'b001001101100000010,
'b001001100001111111,
'b001001010111110110,
'b001001001101101000,
'b001001000011010011,
'b001000111000111001,
'b001000101110011010,
'b001000100011110101,
'b001000011001001011,
'b001000001110011100,
'b001000000011100111,
'b000111111000101110,
'b000111101101110000,
'b000111100010101101,
'b000111010111100101,
'b000111001100011001,
'b000111000001001001,
'b000110110101110100,
'b000110101010011011,
'b000110011110111101,
'b000110010011011100,
'b000110000111110111,
'b000101111100001110,
'b000101110000100010,
'b000101100100110001,
'b000101011000111110,
'b000101001101000111,
'b000101000001001101,
'b000100110101010000,
'b000100101001010000,
'b000100011101001101,
'b000100010001000111,
'b000100000100111110,
'b000011111000110011,
'b000011101100100110,
'b000011100000010111,
'b000011010100000101,
'b000011000111110001,
'b000010111011011011,
'b000010101111000100,
'b000010100010101010,
'b000010010110010000,
'b000010001001110011,
'b000001111101010110,
'b000001110000110111,
'b000001100100010111,
'b000001010111110110,
'b000001001011010101,
'b000000111110110010,
'b000000110010001111,
'b000000100101101100,
'b000000011001001000,
'b000000001100100100,
'b000000000000000000,
'b100000001100100100,
'b100000011001001000,
'b100000100101101100,
'b100000110010001111,
'b100000111110110010,
'b100001001011010101,
'b100001010111110110,
'b100001100100010111,
'b100001110000110111,
'b100001111101010110,
'b100010001001110011,
'b100010010110010000,
'b100010100010101010,
'b100010101111000100,
'b100010111011011011,
'b100011000111110001,
'b100011010100000101,
'b100011100000010111,
'b100011101100100110,
'b100011111000110011,
'b100100000100111110,
'b100100010001000111,
'b100100011101001101,
'b100100101001010000,
'b100100110101010000,
'b100101000001001101,
'b100101001101000111,
'b100101011000111110,
'b100101100100110001,
'b100101110000100010,
'b100101111100001110,
'b100110000111110111,
'b100110010011011100,
'b100110011110111101,
'b100110101010011011,
'b100110110101110100,
'b100111000001001001,
'b100111001100011001,
'b100111010111100101,
'b100111100010101101,
'b100111101101110000,
'b100111111000101110,
'b101000000011100111,
'b101000001110011100,
'b101000011001001011,
'b101000100011110101,
'b101000101110011010,
'b101000111000111001,
'b101001000011010011,
'b101001001101101000,
'b101001010111110110,
'b101001100001111111,
'b101001101100000010,
'b101001110101111111,
'b101001111111110110,
'b101010001001100111,
'b101010010011010010,
'b101010011100110110,
'b101010100110010100,
'b101010101111101011,
'b101010111000111011,
'b101011000010000101,
'b101011001011001000,
'b101011010100000100,
'b101011011100111010,
'b101011100101101000,
'b101011101110001111,
'b101011110110101110,
'b101011111111000111,
'b101100000111011000,
'b101100001111100010,
'b101100010111100100,
'b101100011111011110,
'b101100100111010001,
'b101100101110111011,
'b101100110110011111,
'b101100111101111010,
'b101101000101001101,
'b101101001100011000,
'b101101010011011011,
'b101101011010010101,
'b101101100001001000,
'b101101100111110010,
'b101101101110010100,
'b101101110100101101,
'b101101111010111110,
'b101110000001000110,
'b101110000111000101,
'b101110001100111100,
'b101110010010101010,
'b101110011000001111,
'b101110011101101011,
'b101110100010111111,
'b101110101000001001,
'b101110101101001011,
'b101110110010000011,
'b101110110110110010,
'b101110111011011000,
'b101110111111110101,
'b101111000100001001,
'b101111001000010011,
'b101111001100010100,
'b101111010000001011,
'b101111010011111010,
'b101111010111011110,
'b101111011010111010,
'b101111011110001011,
'b101111100001010011,
'b101111100100010010,
'b101111100111000111,
'b101111101001110011,
'b101111101100010100,
'b101111101110101100,
'b101111110000111011,
'b101111110010111111,
'b101111110100111010,
'b101111110110101011,
'b101111111000010011,
'b101111111001110000,
'b101111111011000100,
'b101111111100001110,
'b101111111101001110,
'b101111111110000100,
'b101111111110110001,
'b101111111111010011,
'b101111111111101100,
'b101111111111111011,
'b110000000000000000,
'b101111111111111011,
'b101111111111101100,
'b101111111111010011,
'b101111111110110001,
'b101111111110000100,
'b101111111101001110,
'b101111111100001110,
'b101111111011000100,
'b101111111001110000,
'b101111111000010011,
'b101111110110101011,
'b101111110100111010,
'b101111110010111111,
'b101111110000111011,
'b101111101110101100,
'b101111101100010100,
'b101111101001110011,
'b101111100111000111,
'b101111100100010010,
'b101111100001010011,
'b101111011110001011,
'b101111011010111010,
'b101111010111011110,
'b101111010011111010,
'b101111010000001011,
'b101111001100010100,
'b101111001000010011,
'b101111000100001001,
'b101110111111110101,
'b101110111011011000,
'b101110110110110010,
'b101110110010000011,
'b101110101101001011,
'b101110101000001001,
'b101110100010111111,
'b101110011101101011,
'b101110011000001111,
'b101110010010101010,
'b101110001100111100,
'b101110000111000101,
'b101110000001000110,
'b101101111010111110,
'b101101110100101101,
'b101101101110010100,
'b101101100111110010,
'b101101100001001000,
'b101101011010010101,
'b101101010011011011,
'b101101001100011000,
'b101101000101001101,
'b101100111101111010,
'b101100110110011111,
'b101100101110111011,
'b101100100111010001,
'b101100011111011110,
'b101100010111100100,
'b101100001111100010,
'b101100000111011000,
'b101011111111000111,
'b101011110110101110,
'b101011101110001111,
'b101011100101101000,
'b101011011100111010,
'b101011010100000100,
'b101011001011001000,
'b101011000010000101,
'b101010111000111011,
'b101010101111101011,
'b101010100110010100,
'b101010011100110110,
'b101010010011010010,
'b101010001001100111,
'b101001111111110110,
'b101001110101111111,
'b101001101100000010,
'b101001100001111111,
'b101001010111110110,
'b101001001101101000,
'b101001000011010011,
'b101000111000111001,
'b101000101110011010,
'b101000100011110101,
'b101000011001001011,
'b101000001110011100,
'b101000000011100111,
'b100111111000101110,
'b100111101101110000,
'b100111100010101101,
'b100111010111100101,
'b100111001100011001,
'b100111000001001001,
'b100110110101110100,
'b100110101010011011,
'b100110011110111101,
'b100110010011011100,
'b100110000111110111,
'b100101111100001110,
'b100101110000100010,
'b100101100100110001,
'b100101011000111110,
'b100101001101000111,
'b100101000001001101,
'b100100110101010000,
'b100100101001010000,
'b100100011101001101,
'b100100010001000111,
'b100100000100111110,
'b100011111000110011,
'b100011101100100110,
'b100011100000010111,
'b100011010100000101,
'b100011000111110001,
'b100010111011011011,
'b100010101111000100,
'b100010100010101010,
'b100010010110010000,
'b100010001001110011,
'b100001111101010110,
'b100001110000110111,
'b100001100100010111,
'b100001010111110110,
'b100001001011010101,
'b100000111110110010,
'b100000110010001111,
'b100000100101101100,
'b100000011001001000,
'b100000001100100100,
'b100000000000000000,
'b000000001100100100,
'b000000011001001000,
'b000000100101101100,
'b000000110010001111,
'b000000111110110010,
'b000001001011010101,
'b000001010111110110,
'b000001100100010111,
'b000001110000110111,
'b000001111101010110,
'b000010001001110011,
'b000010010110010000,
'b000010100010101010,
'b000010101111000100,
'b000010111011011011,
'b000011000111110001,
'b000011010100000101,
'b000011100000010111,
'b000011101100100110,
'b000011111000110011,
'b000100000100111110,
'b000100010001000111,
'b000100011101001101,
'b000100101001010000,
'b000100110101010000,
'b000101000001001101,
'b000101001101000111,
'b000101011000111110,
'b000101100100110001,
'b000101110000100010,
'b000101111100001110,
'b000110000111110111,
'b000110010011011100,
'b000110011110111101,
'b000110101010011011,
'b000110110101110100,
'b000111000001001001,
'b000111001100011001,
'b000111010111100101,
'b000111100010101101,
'b000111101101110000,
'b000111111000101110,
'b001000000011100111,
'b001000001110011100,
'b001000011001001011,
'b001000100011110101,
'b001000101110011010,
'b001000111000111001,
'b001001000011010011,
'b001001001101101000,
'b001001010111110110,
'b001001100001111111,
'b001001101100000010,
'b001001110101111111,
'b001001111111110110,
'b001010001001100111,
'b001010010011010010,
'b001010011100110110,
'b001010100110010100,
'b001010101111101011,
'b001010111000111011,
'b001011000010000101,
'b001011001011001000,
'b001011010100000100,
'b001011011100111010,
'b001011100101101000,
'b001011101110001111,
'b001011110110101110,
'b001011111111000111,
'b001100000111011000,
'b001100001111100010,
'b001100010111100100,
'b001100011111011110,
'b001100100111010001,
'b001100101110111011,
'b001100110110011111,
'b001100111101111010,
'b001101000101001101,
'b001101001100011000,
'b001101010011011011,
'b001101011010010101,
'b001101100001001000,
'b001101100111110010,
'b001101101110010100,
'b001101110100101101,
'b001101111010111110,
'b001110000001000110,
'b001110000111000101,
'b001110001100111100,
'b001110010010101010,
'b001110011000001111,
'b001110011101101011,
'b001110100010111111,
'b001110101000001001,
'b001110101101001011,
'b001110110010000011,
'b001110110110110010,
'b001110111011011000,
'b001110111111110101,
'b001111000100001001,
'b001111001000010011,
'b001111001100010100,
'b001111010000001011,
'b001111010011111010,
'b001111010111011110,
'b001111011010111010,
'b001111011110001011,
'b001111100001010011,
'b001111100100010010,
'b001111100111000111,
'b001111101001110011,
'b001111101100010100,
'b001111101110101100,
'b001111110000111011,
'b001111110010111111,
'b001111110100111010,
'b001111110110101011,
'b001111111000010011,
'b001111111001110000,
'b001111111011000100,
'b001111111100001110,
'b001111111101001110,
'b001111111110000100,
'b001111111110110001,
'b001111111111010011,
'b001111111111101100,
'b001111111111111011,
'b010000000000000000
};
  
  assign   rom_imag={'b000000000000000000
,'b100000001100100100
,'b100000011001001000
,'b100000100101101100
,'b100000110010001111
,'b100000111110110010
,'b100001001011010101
,'b100001010111110110
,'b100001100100010111
,'b100001110000110111
,'b100001111101010110
,'b100010001001110011
,'b100010010110010000
,'b100010100010101010
,'b100010101111000100
,'b100010111011011011
,'b100011000111110001
,'b100011010100000101
,'b100011100000010111
,'b100011101100100110
,'b100011111000110011
,'b100100000100111110
,'b100100010001000111
,'b100100011101001101
,'b100100101001010000
,'b100100110101010000
,'b100101000001001101
,'b100101001101000111
,'b100101011000111110
,'b100101100100110001
,'b100101110000100010
,'b100101111100001110
,'b100110000111110111
,'b100110010011011100
,'b100110011110111101
,'b100110101010011011
,'b100110110101110100
,'b100111000001001001
,'b100111001100011001
,'b100111010111100101
,'b100111100010101101
,'b100111101101110000
,'b100111111000101110
,'b101000000011100111
,'b101000001110011100
,'b101000011001001011
,'b101000100011110101
,'b101000101110011010
,'b101000111000111001
,'b101001000011010011
,'b101001001101101000
,'b101001010111110110
,'b101001100001111111
,'b101001101100000010
,'b101001110101111111
,'b101001111111110110
,'b101010001001100111
,'b101010010011010010
,'b101010011100110110
,'b101010100110010100
,'b101010101111101011
,'b101010111000111011
,'b101011000010000101
,'b101011001011001000
,'b101011010100000100
,'b101011011100111010
,'b101011100101101000
,'b101011101110001111
,'b101011110110101110
,'b101011111111000111
,'b101100000111011000
,'b101100001111100010
,'b101100010111100100
,'b101100011111011110
,'b101100100111010001
,'b101100101110111011
,'b101100110110011111
,'b101100111101111010
,'b101101000101001101
,'b101101001100011000
,'b101101010011011011
,'b101101011010010101
,'b101101100001001000
,'b101101100111110010
,'b101101101110010100
,'b101101110100101101
,'b101101111010111110
,'b101110000001000110
,'b101110000111000101
,'b101110001100111100
,'b101110010010101010
,'b101110011000001111
,'b101110011101101011
,'b101110100010111111
,'b101110101000001001
,'b101110101101001011
,'b101110110010000011
,'b101110110110110010
,'b101110111011011000
,'b101110111111110101
,'b101111000100001001
,'b101111001000010011
,'b101111001100010100
,'b101111010000001011
,'b101111010011111010
,'b101111010111011110
,'b101111011010111010
,'b101111011110001011
,'b101111100001010011
,'b101111100100010010
,'b101111100111000111
,'b101111101001110011
,'b101111101100010100
,'b101111101110101100
,'b101111110000111011
,'b101111110010111111
,'b101111110100111010
,'b101111110110101011
,'b101111111000010011
,'b101111111001110000
,'b101111111011000100
,'b101111111100001110
,'b101111111101001110
,'b101111111110000100
,'b101111111110110001
,'b101111111111010011
,'b101111111111101100
,'b101111111111111011
,'b110000000000000000
,'b101111111111111011
,'b101111111111101100
,'b101111111111010011
,'b101111111110110001
,'b101111111110000100
,'b101111111101001110
,'b101111111100001110
,'b101111111011000100
,'b101111111001110000
,'b101111111000010011
,'b101111110110101011
,'b101111110100111010
,'b101111110010111111
,'b101111110000111011
,'b101111101110101100
,'b101111101100010100
,'b101111101001110011
,'b101111100111000111
,'b101111100100010010
,'b101111100001010011
,'b101111011110001011
,'b101111011010111010
,'b101111010111011110
,'b101111010011111010
,'b101111010000001011
,'b101111001100010100
,'b101111001000010011
,'b101111000100001001
,'b101110111111110101
,'b101110111011011000
,'b101110110110110010
,'b101110110010000011
,'b101110101101001011
,'b101110101000001001
,'b101110100010111111
,'b101110011101101011
,'b101110011000001111
,'b101110010010101010
,'b101110001100111100
,'b101110000111000101
,'b101110000001000110,
'b101101111010111110,
'b101101110100101101,
'b101101101110010100,
'b101101100111110010,
'b101101100001001000,
'b101101011010010101,
'b101101010011011011,
'b101101001100011000,
'b101101000101001101,
'b101100111101111010,
'b101100110110011111,
'b101100101110111011,
'b101100100111010001,
'b101100011111011110,
'b101100010111100100,
'b101100001111100010,
'b101100000111011000,
'b101011111111000111,
'b101011110110101110,
'b101011101110001111,
'b101011100101101000,
'b101011011100111010,
'b101011010100000100,
'b101011001011001000,
'b101011000010000101,
'b101010111000111011,
'b101010101111101011,
'b101010100110010100,
'b101010011100110110,
'b101010010011010010,
'b101010001001100111,
'b101001111111110110,
'b101001110101111111,
'b101001101100000010,
'b101001100001111111,
'b101001010111110110,
'b101001001101101000,
'b101001000011010011,
'b101000111000111001,
'b101000101110011010,
'b101000100011110101,
'b101000011001001011,
'b101000001110011100,
'b101000000011100111,
'b100111111000101110,
'b100111101101110000,
'b100111100010101101,
'b100111010111100101,
'b100111001100011001,
'b100111000001001001,
'b100110110101110100,
'b100110101010011011,
'b100110011110111101,
'b100110010011011100,
'b100110000111110111,
'b100101111100001110,
'b100101110000100010,
'b100101100100110001,
'b100101011000111110,
'b100101001101000111,
'b100101000001001101,
'b100100110101010000,
'b100100101001010000,
'b100100011101001101,
'b100100010001000111,
'b100100000100111110,
'b100011111000110011,
'b100011101100100110,
'b100011100000010111,
'b100011010100000101,
'b100011000111110001,
'b100010111011011011,
'b100010101111000100,
'b100010100010101010,
'b100010010110010000,
'b100010001001110011,
'b100001111101010110,
'b100001110000110111,
'b100001100100010111,
'b100001010111110110,
'b100001001011010101,
'b100000111110110010,
'b100000110010001111,
'b100000100101101100,
'b100000011001001000,
'b100000001100100100,
'b100000000000000000,
'b000000001100100100,
'b000000011001001000,
'b000000100101101100,
'b000000110010001111,
'b000000111110110010,
'b000001001011010101,
'b000001010111110110,
'b000001100100010111,
'b000001110000110111,
'b000001111101010110,
'b000010001001110011,
'b000010010110010000,
'b000010100010101010,
'b000010101111000100,
'b000010111011011011,
'b000011000111110001,
'b000011010100000101,
'b000011100000010111,
'b000011101100100110,
'b000011111000110011,
'b000100000100111110,
'b000100010001000111,
'b000100011101001101,
'b000100101001010000,
'b000100110101010000,
'b000101000001001101,
'b000101001101000111,
'b000101011000111110,
'b000101100100110001,
'b000101110000100010,
'b000101111100001110,
'b000110000111110111,
'b000110010011011100,
'b000110011110111101,
'b000110101010011011,
'b000110110101110100,
'b000111000001001001,
'b000111001100011001,
'b000111010111100101,
'b000111100010101101,
'b000111101101110000,
'b000111111000101110,
'b001000000011100111,
'b001000001110011100,
'b001000011001001011,
'b001000100011110101,
'b001000101110011010,
'b001000111000111001,
'b001001000011010011,
'b001001001101101000,
'b001001010111110110,
'b001001100001111111,
'b001001101100000010,
'b001001110101111111,
'b001001111111110110,
'b001010001001100111,
'b001010010011010010,
'b001010011100110110,
'b001010100110010100,
'b001010101111101011,
'b001010111000111011,
'b001011000010000101,
'b001011001011001000,
'b001011010100000100,
'b001011011100111010,
'b001011100101101000,
'b001011101110001111,
'b001011110110101110,
'b001011111111000111,
'b001100000111011000,
'b001100001111100010,
'b001100010111100100,
'b001100011111011110,
'b001100100111010001,
'b001100101110111011,
'b001100110110011111,
'b001100111101111010,
'b001101000101001101,
'b001101001100011000,
'b001101010011011011,
'b001101011010010101,
'b001101100001001000,
'b001101100111110010,
'b001101101110010100,
'b001101110100101101,
'b001101111010111110,
'b001110000001000110,
'b001110000111000101,
'b001110001100111100,
'b001110010010101010,
'b001110011000001111,
'b001110011101101011,
'b001110100010111111,
'b001110101000001001,
'b001110101101001011,
'b001110110010000011,
'b001110110110110010,
'b001110111011011000,
'b001110111111110101,
'b001111000100001001,
'b001111001000010011,
'b001111001100010100,
'b001111010000001011,
'b001111010011111010,
'b001111010111011110,
'b001111011010111010,
'b001111011110001011,
'b001111100001010011,
'b001111100100010010,
'b001111100111000111,
'b001111101001110011,
'b001111101100010100,
'b001111101110101100,
'b001111110000111011,
'b001111110010111111,
'b001111110100111010,
'b001111110110101011,
'b001111111000010011,
'b001111111001110000,
'b001111111011000100,
'b001111111100001110,
'b001111111101001110,
'b001111111110000100,
'b001111111110110001,
'b001111111111010011,
'b001111111111101100,
'b001111111111111011,
'b010000000000000000,
'b001111111111111011,
'b001111111111101100,
'b001111111111010011,
'b001111111110110001,
'b001111111110000100,
'b001111111101001110,
'b001111111100001110,
'b001111111011000100,
'b001111111001110000,
'b001111111000010011,
'b001111110110101011,
'b001111110100111010,
'b001111110010111111,
'b001111110000111011,
'b001111101110101100,
'b001111101100010100,
'b001111101001110011,
'b001111100111000111,
'b001111100100010010,
'b001111100001010011,
'b001111011110001011,
'b001111011010111010,
'b001111010111011110,
'b001111010011111010,
'b001111010000001011,
'b001111001100010100,
'b001111001000010011,
'b001111000100001001,
'b001110111111110101,
'b001110111011011000,
'b001110110110110010,
'b001110110010000011,
'b001110101101001011,
'b001110101000001001,
'b001110100010111111,
'b001110011101101011,
'b001110011000001111,
'b001110010010101010,
'b001110001100111100,
'b001110000111000101,
'b001110000001000110,
'b001101111010111110,
'b001101110100101101,
'b001101101110010100,
'b001101100111110010,
'b001101100001001000,
'b001101011010010101,
'b001101010011011011,
'b001101001100011000,
'b001101000101001101,
'b001100111101111010,
'b001100110110011111,
'b001100101110111011,
'b001100100111010001,
'b001100011111011110,
'b001100010111100100,
'b001100001111100010,
'b001100000111011000,
'b001011111111000111,
'b001011110110101110,
'b001011101110001111,
'b001011100101101000,
'b001011011100111010,
'b001011010100000100,
'b001011001011001000,
'b001011000010000101,
'b001010111000111011,
'b001010101111101011,
'b001010100110010100,
'b001010011100110110,
'b001010010011010010,
'b001010001001100111,
'b001001111111110110,
'b001001110101111111,
'b001001101100000010,
'b001001100001111111,
'b001001010111110110,
'b001001001101101000,
'b001001000011010011,
'b001000111000111001,
'b001000101110011010,
'b001000100011110101,
'b001000011001001011,
'b001000001110011100,
'b001000000011100111,
'b000111111000101110,
'b000111101101110000,
'b000111100010101101,
'b000111010111100101,
'b000111001100011001,
'b000111000001001001,
'b000110110101110100,
'b000110101010011011,
'b000110011110111101,
'b000110010011011100,
'b000110000111110111,
'b000101111100001110,
'b000101110000100010,
'b000101100100110001,
'b000101011000111110,
'b000101001101000111,
'b000101000001001101,
'b000100110101010000,
'b000100101001010000,
'b000100011101001101,
'b000100010001000111,
'b000100000100111110,
'b000011111000110011,
'b000011101100100110,
'b000011100000010111,
'b000011010100000101,
'b000011000111110001,
'b000010111011011011,
'b000010101111000100,
'b000010100010101010,
'b000010010110010000,
'b000010001001110011,
'b000001111101010110,
'b000001110000110111,
'b000001100100010111,
'b000001010111110110,
'b000001001011010101,
'b000000111110110010,
'b000000110010001111,
'b000000100101101100,
'b000000011001001000,
'b000000001100100100,
'b000000000000000000};
  // end

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
