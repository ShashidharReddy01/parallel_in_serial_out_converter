module piso(
  input [7:0] in,
  input ld, clk, rst,en,
  output [7:0]q
);

  reg [7:0] qq;

 
  always @(posedge clk or posedge rst) begin
    if (rst)
      qq <= 8'b0;
    else if (~en && ld)
      qq <= in;
    else if (en)
      qq <= {qq[6:0], 1'b0};// right shift
    else
      qq <= 8'b0;
    
  end

 assign q = qq;

endmodule
