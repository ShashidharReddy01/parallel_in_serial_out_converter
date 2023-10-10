module piso_tb();
  reg ld, clk, rst, en;
  reg [7:0] in;
  wire [7:0] q;
  reg [2:0] state; // Define a state variable

  // Define state parameters
  parameter IDLE = 3'b000;
  parameter LOAD = 3'b001;
  parameter SHIFT = 3'b010;

  // Instantiate the 8-bit PISO module
  piso dut(in, ld, clk, rst, en, q);

  // Clock generation
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
    
  end

  // FSM behavior
  always @(posedge clk) begin
    case (state)
      IDLE: begin
        // Initialize signals
        rst = 1;
        ld = 0;
        en = 0;
        in = 8'b0;
        // Transition to LOAD state
        state = LOAD;
      end

      LOAD: begin
        // Release reset and load data
        rst = 0;
        ld = 1;
        in = $random; // Load some test data
        // Transition to SHIFT state
        state = SHIFT;
      end

      SHIFT: begin
        // Deassert load and let the shift register operate
        ld = 0;
        en = 1;
        // Test various data patterns and control sequences
        in = $random; // Test a different data pattern
        in = $random; // Test another data pattern
        // You can add more test cases here to target specific expressions
        // Transition back to IDLE to finish simulation
        state = IDLE;
	end

	default: state=IDLE;
      
    endcase
  end

  // Simulation setup
  initial begin
    $dumpfile("piso_tb.vcd");
    $dumpvars(0, piso_tb);

    // Initialize state to IDLE
    state = IDLE;

    // Finish simulation after a few cycles
    #1000 $finish;
  end
endmodule
