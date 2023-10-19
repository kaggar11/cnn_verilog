/////////////////////////////////////////////////
//  Author:     Kartik
//  Date:       8:09 PM 10/18/2023
//  
//  File name:  log2n_cntr.sv
//  Description: A Log2(N) Counter for control unit
//  Latency : 
/////////////////////////////////////////////////

module log2n_cntr # (
   parameter LOG2N_BITS=4
)(
   input clk,
   input rst,
   input en,
   output logic [LOG2N_BITS-1:0] control_bus            // output control bus to all modules' MUXs
);

always_ff @(posedge clk, negedge rst) begin
   if (~rst) begin
      control_bus <= 'h0;
   end else if (en) begin
      control_bus <= control_bus + 1'b1;
   end
end

endmodule