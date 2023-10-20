`timescale 1ns/1ns

module tb_conv_layer();
  
  // parameters
  parameter run_time             = 8_000_000; // ps
  parameter DUT_CLK_HALF_PER_NS  = 5;
  parameter KERNEL_SIZE          = 5;
  parameter IMGCOL               = 28;
  parameter IMGROW               = 28;
  parameter DATA_WIDTH           = 8;
  parameter KDATA_WIDTH          = 8;
  parameter ACTIVATION           = "RELU";
  
  // variables
  logic dut_clk;
  logic rst;
  logic [DATA_WIDTH-1:0]  image      [0:IMGROW-1] [0:IMGCOL-1];
  logic [KDATA_WIDTH-1:0] kernel     [0:KERNEL_SIZE-1] [0:KERNEL_SIZE-1];
  logic [DATA_WIDTH-1:0]  conv_out   [0:IMGROW-KERNEL_SIZE][0:IMGCOL-KERNEL_SIZE];
  logic conv_done;

  // instantiate DUT
  conv_layer #(
    .DATA_WIDTH      (DATA_WIDTH),
    .KDATA_WIDTH     (KDATA_WIDTH),
    .KERNEL_SIZE     (KERNEL_SIZE),
    .ACTIVATION      (ACTIVATION),
    .IMGCOL          (IMGCOL),
    .IMGROW          (IMGROW)
  ) x_dut (
    .clk             ( dut_clk   ), // 100 MHz for Basys3
    .rst             ( rst       ), // 
    .image           ( image     ), // 
    .kernel          ( kernel    ), // 
    .conv_out        ( conv_out  ),
    .layer_done_out  ( conv_done )
  );


   initial begin : tb_threads
      dut_clk = 1'b0;
      rst = 1'b0;
      fork
         begin
            #(DUT_CLK_HALF_PER_NS * 1ns);
            rst = 1'b1;
         end
         begin
            forever begin
               #(DUT_CLK_HALF_PER_NS * 1ns);
               dut_clk = ~dut_clk;
            end
         end
      join_none
   end : tb_threads
   
   //-----------------Task to get Features--------------------//
   task get_features();
      int fp0,p;
      fp0 = $fopen("../tests/inputs/sample_mnist_image.txt","r");
      for (int j=0;j<IMGROW;j++) begin
         for (int i=0;i<IMGCOL;i++) begin
            p = $fscanf(fp0,"%d\t",image[j][i]);
            //$display("Image[%d][%d]:%d",j,i,image[j][i]);
         end
      end
      $fclose(fp0);
   endtask

   //-----------------Task to get Weights--------------------//
   task get_weights();
      int fp1,p1;
      fp1 = $fopen("../tests/inputs/sample_kernel.txt","r");
      for (int j=0;j<KERNEL_SIZE;j++) begin
         for (int i=0;i<KERNEL_SIZE;i++) begin
            p1 = $fscanf(fp1,"%h\t",kernel[j][i]);
            //$display("Kernel[%d][%d]:%h",j,i,kernel[j][i]);
         end
      end
      $fclose(fp1);
   endtask

   //--------------Block to write Conv Output-----------------//
   initial begin
      int fp2,p2;
      fp2 = $fopen("../tests/outputs/output.txt","w");
      
      // keep on checking at each posedge of clk if conv is done
      forever begin
      @(posedge dut_clk);
         if(conv_done) begin
            for (int j=0;j<IMGROW-KERNEL_SIZE+1;j++) begin
               for (int i=0;i<IMGCOL-KERNEL_SIZE+1;i++) begin
                  $fwrite(fp2,"%d\t",conv_out[j][i]);
                  $display("conv_out[%d][%d]:%h",j,i,conv_out[j][i]);
               end
               $fwrite(fp2,"\n");
            end
            $fclose(fp2);
            finish();
         end
      end
   end

   //-------------------------------------------------------------//
   //Fetching the values from the text file and generating clock
   //-------------------------------------------------------------//
   initial begin
      get_features(); // Reads the txt file for input matrix
      get_weights();  // Reads the txt file for weight matrix
      //get_golden_outputs(); // Reads the golden outputs file
   end

   /*
   initial begin : test_thread
      image = {{'hfe,'h04,'hff,'h05,'hf5,'h02,'hf8}, 
               {'h04,'h01,'hff,'h05,'hf5,'h02,'hf8}, 
               {'h01,'h06,'hff,'h05,'hf5,'h02,'hf8}, 
               {'h02,'h04,'hff,'h05,'hf5,'h02,'hf8}, 
               {'h06,'h02,'hff,'h05,'hf5,'h02,'hf8}, 
               {'h06,'h01,'hff,'h05,'hf5,'h02,'hf8}, 
               {'h01,'h02,'hff,'h05,'hf5,'h02,'hf8}};
      kernel = {{'h02,'hf2,'h20},
                {'hfc,'hfe,'h20},
                {'hfc,'hfe,'h20}};
   end : test_thread
   */

   initial begin
      //finish();
   end

   task finish();
      //#(run_time)
      $display("!!!!!!!!!!!!!!!!!!!!!!!END OF TB!!!!!!!!!!!!!!!!!!!!!!!!!!!!");      
      $finish(1);
   endtask

 endmodule
