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
<details>
<summary>Commands required to RUN-SIMULATE-CODE_COVERAGE-SYNTHESIZE</summary>
	
## Steps to start CADENCE on linux

&gt; create a folder in the desktop, with your srn/name

&gt; open the folder

&gt; right-click and create files for design and testbench,
eg. db_fsm.v and db_tb.v

&gt; right-click on the files and open them using gedit, save the design and
testbench codes in the respective files

&gt; right-click inside the folder and select open in terminal

&gt; enter the following commands in the terminal
`csh`

Enters the C-Shell

`source /home/&lt;install location`
&gt; `/cshrc`

&gt; Navigates to the Cadence Tools install path and starts the tool

Note: You can use the upper arrow in the terminal to navigate quickly to the already used paths/commands and use tab-key to auto-complete commands.

&gt; A new window appears that welcomes the user to the Cadence Design Suite,the following tools can be invoked in this window.

## Simulation Tool

&gt;To start reading the design and testbench files, to obtain a waveform in the Graphical User Interface (simvision), enter the following commands.
Note: No space between +access and +rw, but mandatory space between +rw and +gui. (make sure to follow all similar spacing patterns given in the tool reference)

&gt; ncverilog &lt;design&gt; &lt;testbench&gt; +access+rw +gui

eg. ncverilog db_fsm.v db_tb.v +access+rw +gui

Note: the +gui starts up the ncverilog GUI window.

&gt; navigate through the design hierarchy and select the signals you want to
analyze in the design browser (hold down ctrl-key while selecting), right-click
and select send to waveform

&gt; in the simvision window, select the play button, followed by the pause button
to start and stop the simulation. The simulation will end automatically if the
$finish statement is executed in the HDL.

&gt; select the ‘=’ symbol at the top right corner of the window, to fit the
waveform’s entirety in the same frame.

&gt; drag the red marker to the beginning of the waveform and select on the ‘+’
symbol on the top right corner, to magnify until the waveform pulses are
visible for verifying the functionality of the design.

## Code Coverage Check

&gt; ncverilog design.v tb.v +access+rw +gui +nccoverage+all

&gt; Check for the path of the file “cov_work” generated in the terminal then
type:

(Invoke Incisive Metrics Center)

&gt;enter the command ‘imc’ in the terminal which will launch the IMC GUI.

`imc`

&gt; In he IMC’s Graphical User Interface, you can navigate and select the file to
check the Code Coverage (block, branch, expression, toggle) and FSM
Coverage, represented in percentages.

## Synthesis

`genus -gui`

Opens the genus tool with gui, alternatively you can show and hide gui using
command gui_show and gui_hide

&gt; read_libs &lt;path of .lib file&gt;

Reads library file for synthesis, from the specified path. Eg. saed90nm_typ.lib
the 90 nanometer typical library

&gt; read_hdl &lt;path of design file&gt;

Reads design file to be synthesized, written in HDL (eg. verilog, systemverilog)

`elaborate`

Elaborates the design in the tool, and can be viewed in the GUI by selecting

Hier Cell &gt; Schematic View(Module) &gt; in New.
*For Synthesis with constraints*

&gt; read_sdc &lt;path of .sdc constraints file&gt;

`syn_generic`

Synthesizes the design to the G Tech cells (default cells for the Cadence Tool)

`syn_map`

maps the synthesized cells to the library specified earlier in read_libs
command

`syn_opt -incremental`

Incrementally optimizes the synthesized design

&gt; report_timing &gt; (path for .rpt file to save timing report)

Reports timing Time Borrowed, Uncertainty, Required Time, Launch Clock,
Data Path and Slack.

&gt; report_area &gt; (path for .rpt file to save area report)

Reports area of the synthesized design in micro-meters-square

&gt; report_power &gt; (path for .rpt file to save power report)

Reports power in nano Watts (nW)

&gt; write_hdl &gt; (path for .v file for netlist to be written)

Writes the netlist in HDL format in the path specified

`quit`

Exits the genus tool

</details>

<details>
<summary>Simulation</summary>

![image](https://github.com/ShashidharReddy01/parallel_in_serial_out_converter/assets/142148810/d319914f-32ef-40ac-bc71-74daa13217e8)

</details>

<details>
<summary>Elaborated schematic</summary>

![image](https://github.com/ShashidharReddy01/parallel_in_serial_out_converter/assets/142148810/f765fb6d-6787-4c5d-bc44-960352e53ba0)

</details>

<details>
<summary>Code Coverage</summary>

![image](https://github.com/ShashidharReddy01/parallel_in_serial_out_converter/assets/142148810/d80543ad-ee44-48fc-b342-336152e01c49)


</details>

<details>
<summary>Timing.rpt</summary>

![image](https://github.com/ShashidharReddy01/parallel_in_serial_out_converter/assets/142148810/069eaaad-dd93-4435-be81-c5c933704d47)



</details>

<details>
<summary>Power.rpt</summary>

![image](https://github.com/ShashidharReddy01/parallel_in_serial_out_converter/assets/142148810/d179cedb-5131-4b59-b703-f9aafbc7e5d2)


</details>

<details>
<summary>Area.rpt</summary>

![image](https://github.com/ShashidharReddy01/parallel_in_serial_out_converter/assets/142148810/d0519062-f2d8-4d75-8f80-b1913d7a2e9f)


</details>

