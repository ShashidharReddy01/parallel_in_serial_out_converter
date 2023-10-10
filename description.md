# PARALLEL IN SERIAL OUT CONVERTER

<details>
<summary>What is PISO Shift Register</summary>
A PISO shift register is a digital circuit that can accept parallel data and output serial data. It is made up of a succession of flip-flops, with each flip-flop capable of storing one bit of data. Unlike PIPO shift registers, which offer parallel input and output, a PISO shift register accepts data in parallel and outputs it sequentially, or serially.
  
![image](https://github.com/ShashidharReddy01/parallel_in_serial_out_converter/assets/142148810/2703f634-3d52-4f2f-ac72-652cfdc21077)

</details>

<details>
<summary>Key Terminologies For PISO Shift Registers</summary>

### Shift Register: 
A digital circuit that allows sequential shifting of data bits. It consists of a chain of flip-flops where data moves from one flip-flop to the next during each clock cycle.
### Parallel-In Serial-Out (PISO): 
A type of shift register that accepts parallel input data and produces a sequential output. It loads data in parallel and outputs it in a serial manner.
### Flip-Flops: 
Storage elements within a shift register that can store one bit of data. In a PISO shift register, each flip-flop represents a stage through which data passes during the shifting process.
### Parallel Input: 
The process of loading data into the shift register simultaneously through multiple input lines. Parallel input allows for fast and efficient data transfer into the shift register.
### Serial Output: 
The sequential output of data from the shift register, bit by bit, in a serial manner. The output represents the data that has been shifted through the register.
### Clock Signal: 
A timing signal that controls the shifting operation in the shift register. Each clock pulse triggers the movement of data from one flip-flop to the next, enabling the sequential shifting process.
### Most Significant Bit (MSB): 
The leftmost bit of the parallel input or serial output in a binary representation. It represents the highest value or the most significant position within the data.
### Least Significant Bit (LSB): 
The rightmost bit of the parallel input or serial output in a binary representation. It represents the lowest value or the least significant position within the data.
### Data Transmission: 
The process of sending data from one device to another. PISO shift registers are commonly used in data transmission applications, converting parallel data into a serial format for efficient transmission over serial communication channels.
### Serial-to-Parallel Conversion: 
The process of converting serial data into parallel format. PISO shift registers can be used to load serial data and then output it in parallel, enabling the interfacing between serial and parallel systems.
</details>
<details>
<summary>PISO design and explaination</summary>

### CODE 

  ```
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
```

### Explaination


```verilog
module piso(
  input [7:0] in,
  input ld, clk, rst, en,
  output [7:0] q
);
```

- `input [7:0] in`: This is an 8-bit wide input bus. It represents the parallel data input that you want to shift serially through the PISO register.

- `input ld`: Load signal. When asserted (high), it indicates that new parallel data from the `in` bus should be loaded into the shift register.

- `input clk`: Clock signal. This is the clock that controls the shifting of data through the shift register.

- `input rst`: Reset signal. When asserted (high), it resets the shift register to its initial state.

- `input en`: Enable signal. When asserted (high), it allows the shifting operation to occur.

- `output [7:0] q`: This is an 8-bit wide output bus. It represents the serial output of the PISO register.

```verilog
  reg [7:0] qq;
```

- `reg [7:0] qq`: This is an 8-bit wide register called `qq`. It's used to store the data as it is shifted through the register.

```verilog
  always @(posedge clk or posedge rst) begin
```

- `always @(posedge clk or posedge rst)`: This is a combinational block that is sensitive to either a rising edge of the clock signal (`posedge clk`) or a rising edge of the reset signal (`posedge rst`).

```verilog
    if (rst)
      qq <= 8'b0;
```

- `if (rst) qq <= 8'b0;`: If the reset signal (`rst`) is asserted (high), it sets the value of `qq` to 8'b0, effectively resetting the shift register.

```verilog
    else if (~en && ld)
      qq <= in;
```

- `else if (~en && ld) qq <= in;`: If the enable signal (`en`) is not asserted (low), and the load signal (`ld`) is asserted (high), it loads the value from the parallel input `in` into the `qq` register. This allows new parallel data to be loaded when `ld` is high.

```verilog
    else if (en)
      qq <= {qq[6:0], 1'b0}; // right shift
```

- `else if (en) qq <= {qq[6:0], 1'b0};`: If the enable signal (`en`) is asserted (high), it performs a right shift operation on the `qq` register. This shifts the data in the register one bit to the right.

```verilog
    else
      qq <= 8'b0;
```

- `else qq <= 8'b0;`: If none of the above conditions are met, the `qq` register is cleared to 8'b0, effectively resetting it.

```verilog
  end
```

- `end`: This ends the `always` block.

```verilog
 assign q = qq;
```

- `assign q = qq;`: This assigns the value of the `qq` register to the serial output `q`. This is the value that represents the data shifted through the PISO register.

</details>
<details>
<summary>Testbench and explaination</summary>

### CODE

```
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
```

### Explaination

```verilog
module piso_tb();
  // Input and output signals
  reg ld, clk, rst, en;
  reg [7:0] in;
  wire [7:0] q;

  // State variable and state parameters
  reg [2:0] state;
  parameter IDLE = 3'b000;
  parameter LOAD = 3'b001;
  parameter SHIFT = 3'b010;
```

- `reg ld, clk, rst, en;`: These are the input control signals for the PISO module. They correspond to load (`ld`), clock (`clk`), reset (`rst`), and enable (`en`) signals.

- `reg [7:0] in;`: This is the input data bus representing the parallel input data that you want to feed into the PISO module.

- `wire [7:0] q;`: This is the output wire representing the serial output data from the PISO module.

- `reg [2:0] state;`: This is a 3-bit wide register called `state` that is used to control the state of the finite state machine (FSM) for testing.

- `parameter IDLE = 3'b000;`, `parameter LOAD = 3'b001;`, `parameter SHIFT = 3'b010;`: These are parameters that define three states for the FSM: IDLE, LOAD, and SHIFT.

```verilog
  // Instantiate the 8-bit PISO module
  piso dut(in, ld, clk, rst, en, q);
```

- `piso dut(in, ld, clk, rst, en, q);`: This instantiates the PISO module (`piso`) using the signals and ports defined in the testbench.

```verilog
  // Clock generation
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end
```

- This section generates the clock signal (`clk`). It starts with an initial value of 1 and toggles its value every 5 time units (`#5`) to simulate a clock signal with a 50% duty cycle.

```verilog
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

      default: state = IDLE;
      
    endcase
  end
```

- This is the FSM behavior section. It defines the behavior of the finite state machine based on the `state` variable. The FSM goes through three states: IDLE, LOAD, and SHIFT.

  - In the IDLE state, it initializes control signals, sets `rst` to 1, `ld` to 0, `en` to 0, and `in` to all zeros. Then, it transitions to the LOAD state.

  - In the LOAD state, it releases the reset, sets `ld` to 1 (indicating data loading), and loads some random test data into `in`. It then transitions to the SHIFT state.

  - In the SHIFT state, it deasserts `ld` to stop loading, sets `en` to 1 to enable shifting, and tests various data patterns by loading random values into `in`. After some testing, it transitions back to the IDLE state to finish the simulation.

  - The `default` case is used for error handling or to reset the state machine to IDLE in case of an unexpected state.

```verilog
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
```

- This section sets up the simulation environment:
  - `$dumpfile("piso_tb.vcd")` and `$dumpvars(0, piso_tb)` specify that the simulation should generate a VCD (Value Change Dump) file for waveform analysis.
  - `state = IDLE` initializes the state machine to the IDLE state.
  - `$finish` is used to end the simulation after a certain number of time units (`#1000` in this case).


</details>
