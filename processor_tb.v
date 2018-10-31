`timescale 1 ns / 1 ps

module processor_tb;

// ----------------------------------
// Local parameter declaration
// ----------------------------------
localparam CLK_PERIOD = 20.0;  // clock period: 5ns

// ----------------------------------
// Interface of the CPUtop module
// ----------------------------------
reg clk, rst;
reg [17:0] INST_MEM[1023:0];
reg [15:0] DATA_MEM[1023:0];
wire done;
reg [17:0] instruction_in;
reg [15:0] data_in;
wire [15:0] data_out;
wire [9:0] instruction_address;
wire [9:0] data_address;
wire data_R;
wire data_W;
// ----------------------------------
// Instantiate the CPUtop
// ----------------------------------
CPUtop uut (
  .clk        (clk),          // system clock
  .rst        (rst),          // system reset (active high)
  .instruction_in (instruction_in),
  .data_in(data_in),
  .data_out(data_out),
  .instruction_address(instruction_address),
  .data_address(data_address),
  .data_R(data_R),
  .data_W(data_W),
  .done(done)
);

initial begin
  $sdf_annotate("CPUtop.mapped.sdf", uut);
end

//instructions and memory initialization
initial begin
  INST_MEM[0]  = 18'b100110_00_0000000000;  // load MEM0 into H0          load16bit R0 im=0000000000
  INST_MEM[1]  = 18'b100110_01_0000000001;  // load MEM1 into H1          load16bit R1 im=0000000001
  INST_MEM[2]  = 18'b100110_10_0000000010;  // load MEM2 into H2          load16bit R2 im=0000000010
  INST_MEM[3]  = 18'b000000_00000000_00_01; // add H1 to H0               add16bit R0=0000000000000101 R1=0000000000001111
  INST_MEM[4]  = 18'b000000_00000000_10_00; // add H0 to H2               add16bit R2=0000000000000100 R0=0000000000010100
  INST_MEM[5]  = 18'b101001_00_0000000000;  // store H0 back into MEM0    store16bit R0=0000000000010100 im=0000000000
  INST_MEM[6]  = 18'b101100_01_0100100010;  // set H1 to 0100100010       set16bit R1 im=0100100010
  INST_MEM[7]  = 18'b000000_00000000_01_10; // add H2 to H1               add16bit R1=0000000100100010 R2=0000000000011000
  INST_MEM[8]  = 18'b101001_01_0000000011;  // store H1 back into MEM3    store16bit R1=0000000100111010 im=0000000011
  INST_MEM[9]  = 18'b101001_10_0000000100;  // store H2 back into MEM4    store16bit R2=0000000000011000 im=0000000100
  INST_MEM[10] = 18'b101001_00_0000000101;  // store H0 back into MEM5    store16bit R0=0000000000010100 im=0000000101

  INST_MEM[11]  = 18'b100111_01_0000000010; // load MEM2 into O1          load8bit R1 im=0000000010
  INST_MEM[12]  = 18'b100111_10_0000000011; // load MEM3 into O2          load8bit R2 im=0000000011
  INST_MEM[13]  = 18'b100111_00_0000000100; // load MEM4 into O0          load8bit R0 im=0000000100
  INST_MEM[14]  = 18'b101101_01_0001011010; // set each register in O1    set8bit R1 im=0001011010

  INST_MEM[15]  = 18'b100101_00_0000000010; // setloop = 2                setloop im=   2

  INST_MEM[16]  = 18'b000001_00000000_00_01; // add O0 to O1              add8bit R0=0000000000011000 R1=0101101001011010
  INST_MEM[17]  = 18'b000001_00000000_10_00; // add O2 to O0              add8bit R2=0000000100111010 R0=0101101001110010
  INST_MEM[18]  = 18'b000111_00000000_10_01; // sub O1 from O2            sub8bit R2=0101101110101100 R1=0101101001011010
  INST_MEM[19]  = 18'b001101_00000000_10_01; // mul O2 with O1            mul8bit R2=0000000101010010 R1=0101101001011010
  INST_MEM[20]  = 18'b101010_01_0000000101; // store O1 MEM5 into         store8bit R1=0101101001011010 im=0000000101
  INST_MEM[21]  = 18'b101010_10_0000000110; // store O2 MEM6 into O2      store8bit R2=0101101011010100 im=0000000110
  INST_MEM[22]  = 18'b101010_00_0000000111; // store O0 MEM7 into O0      store8bit R0=0101101001110010 im=0000000111
  
  INST_MEM[23]  = 18'b100110_01_0000000101; // load MEM5 into H1          load16bit R1 im=0000000101
  INST_MEM[24]  = 18'b100110_10_0000000111; // load MEM7 into H2          load16bit R2 im=0000000111
  INST_MEM[25]  = 18'b001100_00000000_10_01; // mul H2 with H1            mul16bit R2=0101101001110010 R1=0101101001011010
  INST_MEM[26]  = 18'b000110_00000000_10_01; // sub H1 from H2            sub16bit R2=1110000000010100 R1=0101101001011010
  INST_MEM[27]  = 18'b011000_0000000000_01; // shift right H1             Rshift16bit R1=0101101001011010
  INST_MEM[28]  = 18'b010101_0000000000_10; // shift left H2              Lshift16bit R2=1000010110111010
  INST_MEM[29]  = 18'b000011_10_0000001110; // add im_number into H2      add16bit R2=0000101101110100 im=0000001110
  INST_MEM[30]  = 18'b001001_10_0000001110; // sub im_number from H2      sub16bit R2=0000101110000010 im=0000001110
  INST_MEM[31]  = 18'b100001_0000000000_10; // not H2                     not16bit R2=0000101101110100
  INST_MEM[32]  = 18'b011011_00000000_01_00; // H1 and H0                 and16bit R1=0010110100101101 R0=0000000000010100
  INST_MEM[33]  = 18'b011110_00000000_10_01;  // H2 or H1                 or16bit R2=1111010010001011 R1=0000000000000100
  INST_MEM[34]  = 18'b101100_00_0000001111;  // set H0 to 0000001111      set16bit R0 im=0000001111
  INST_MEM[35]  = 18'b101100_01_0000000100;  // set H1 to 0000000100      set16bit R1 im=0000000100
  INST_MEM[36]  = 18'b101100_10_0000000010;  // set H2 to 0000000010      set16bit R2 im=0000000010
  INST_MEM[37]  = 18'b010010_000000_00_01_10;  // H0+H1*H2                MAC16bit R0=0000000000001111 R1=0000000000000100 R2=0000000000000010
  INST_MEM[38]  = 18'b001001_00_0000001000;  // sub im_number from H0     sub16bit R0=0000000000010111 im=0000001000
  INST_MEM[39]  = 18'b001111_01_0000001101;  // mul H1 with im_number     mul16bit R1=0000000000000100 im=0000001101
  INST_MEM[40]  = 18'b101001_01_0000000111;  // store H1 back into MEM7   store16bit R1=0000000000110100 im=0000000111
  INST_MEM[41]  = 18'b101001_10_0000000100;  // store H2 back into MEM4   store16bit R2=0000000000000010 im=0000000100
  INST_MEM[42]  = 18'b101001_00_0000001000;  // store H0 back into MEM8   store16bit R0=0000000000001111 im=0000001000
  
  INST_MEM[43]  = 18'b100111_01_0000000110; // load MEM6 into O1          load8bit R1 im=0000000110
  INST_MEM[44]  = 18'b100111_10_0000000111; // load MEM7 into O2          load8bit R2 im=0000000111
  INST_MEM[45]  = 18'b100111_00_0000001000; // load MEM8 into O0          load8bit R0 im=0000001000
  INST_MEM[46]  = 18'b011001_0000000000_01; // shift right O1             Rshift8bit R1=0101101011010100
  INST_MEM[47]  = 18'b010110_0000000000_10; // shift left O2              Lshift8bit R2=0000000000110100
  INST_MEM[48]  = 18'b000100_10_0000001110; // add im_number into O2      add8bit R2=0000000001101000 im=0000001110
  INST_MEM[49]  = 18'b001010_10_0000001110; // sub im_number from O2      sub8bit R2=0000111001110110 im=0000001110
  INST_MEM[50]  = 18'b100010_0000000000_10; // not O2                     not8bit R2=0000000001101000
  INST_MEM[51]  = 18'b011100_00000000_01_00; // O1 and O0                 and8bit R1=0010110101101010 R0=0000000000001111
  INST_MEM[52]  = 18'b011111_00000000_10_01;  // O2 or O1                 or8bit R2=1111111110010111 R1=0000000000001010
  INST_MEM[53]  = 18'b101101_00_0000001111;  // set O0 to 0000001111      set8bit R0 im=0000001111
  INST_MEM[54]  = 18'b101101_01_0000000100;  // set O1 to 0000000100      set8bit R1 im=0000000100
  INST_MEM[55]  = 18'b101101_10_0000000010;  // set O2 to 0000000010      set8bit R2 im=0000000010
  INST_MEM[56]  = 18'b010011_000000_00_01_10;  // O0+O1*O2                MAC8bit R0=0000111100001111 R1=0000010000000100 R2=0000001000000010
  INST_MEM[57]  = 18'b001010_00_0000001000;  // sub im_number from O0     sub8bit R0=0001011100010111 im=0000001000
  INST_MEM[58]  = 18'b010000_01_0000001101;  // mul O1 with im_number     mul8bit R1=0000010000000100 im=0000001101
  INST_MEM[59]  = 18'b101010_01_0000001001; // store O1 into MEM9         store8bit R1=0011010000110100 im=0000001001
  INST_MEM[60]  = 18'b101010_10_0000000110; // store O2 into MEM6         store8bit R2=0000001000000010 im=0000000110
  INST_MEM[61]  = 18'b101010_00_0000000111; // store O0 into MEM7         store8bit R0=0000111100001111 im=0000000111

  
  INST_MEM[62]  = 18'b101000_01_0000001001; // load MEM9 into Q1          load4bit R1 im=0000001001
  INST_MEM[63]  = 18'b101000_10_0000000110; // load MEM6 into Q2          load4bit R2 im=0000000110
  INST_MEM[64]  = 18'b101000_00_0000000111; // load MEM7 into Q0          load4bit R0 im=0000000111
  INST_MEM[65]  = 18'b101110_10_0001011010; // set each register in Q2    set4bit R2 im=0001011010
  INST_MEM[66]  = 18'b011010_0000000000_01; // shift right Q1             Rshift4bit R1=0011010000110100
  INST_MEM[67]  = 18'b010111_0000000000_10; // shift left Q2              Lshift4bit R2=1010101010101010
  INST_MEM[68]  = 18'b000101_10_0000001110; // add im_number into Q2      add4bit R2=0100010001000100 im=0000001110
  INST_MEM[69]  = 18'b001011_10_0000001110; // sub im_number from Q2      sub4bit R2=0010001000100010 im=0000001110
  INST_MEM[70]  = 18'b100011_0000000000_10; // not Q2                     not4bit R2=0100010001000100
  INST_MEM[71]  = 18'b011101_00000000_01_00; // Q1 and Q0                 and4bit R1=0001001000010010 R0=0000111100001111
  INST_MEM[72]  = 18'b100000_00000000_10_01;  // Q2 or Q1                 or4bit R2=1011101110111011 R1=0000001000000010
  INST_MEM[73]  = 18'b101110_00_0000001111;  // set Q0 to 0000001111      set4bit R0 im=0000001111
  INST_MEM[74]  = 18'b101110_01_0000000100;  // set Q1 to 0000000100      set4bit R1 im=0000000100
  INST_MEM[75]  = 18'b101110_10_0000000010;  // set Q2 to 0000000010      set4bit R2 im=0000000010
  INST_MEM[76]  = 18'b010100_000000_00_01_10;  // Q0+Q1*Q2                MAC4bit R0=1111111111111111 R1=0100010001000100 R2=0010001000100010
  INST_MEM[77]  = 18'b001011_00_0000001000;  // sub im_number from Q0     sub4bit R0=0111011101110111 im=0000001000
  INST_MEM[78]  = 18'b010001_01_0000000101;  // mul Q1 with im_number     mul4bit R1=0100010001000100 im=0000000101  
  INST_MEM[79]  = 18'b101110_01_0001011010; // set each register in Q1    set4bit R1 im=0001011010
  INST_MEM[80]  = 18'b000010_00000000_00_01; // add Q0 to O1              add4bit R0=1111111111111111 R1=1010101010101010
  INST_MEM[81]  = 18'b000010_00000000_10_00; // add Q2 to Q0              add4bit R2=0010001000100010 R0=1001100110011001
  INST_MEM[82]  = 18'b001000_00000000_10_01; // sub Q1 from Q2            sub4bit R2=1011101110111011 R1=1010101010101010
  INST_MEM[83]  = 18'b001110_00000000_10_01; // mul Q2 with Q1            mul4bit R2=0001000100010001 R1=1010101010101010 
  INST_MEM[84]  = 18'b101011_01_0000001001; // store Q1 into MEM9         store4bit R1=1010101010101010 im=0000001001
  INST_MEM[85]  = 18'b101011_10_0000000110; // store Q2 into MEM6         store4bit R2=1010101010101010 im=0000000110
  INST_MEM[86]  = 18'b101011_00_0000000111; // store Q0 into MEM7         store4bit R0=1001100110011001 im=0000000111
  
  INST_MEM[87]  = 18'b100100_00_0000010000; // jump to 16                 loopjump LC=   x im=  16
  
  INST_MEM[88]  = 18'b111111_000000000000; // halt
  
  DATA_MEM[0] = 5;
  DATA_MEM[1] = 15; 
  DATA_MEM[2] = 4;  
end


// ----------------------------------
// Clock generation
// ----------------------------------
initial begin
  clk = 1'b0;
  forever #(CLK_PERIOD/2.0) clk = ~clk;
end


// ----------------------------------
// Memory(BRAM/low latency Cache) Simulation
// ----------------------------------
always @(negedge clk)
begin
    if (data_R)
    begin
        if (data_W) 
	begin
		DATA_MEM[data_address] <= data_out;
		$display("write mem %d: %b",data_address,data_out);
	end
        else
            data_in <= DATA_MEM[data_address];
    end
end

always @(negedge clk)
begin
   instruction_in <= INST_MEM[instruction_address];
   $display("inst_addr %d: %b",instruction_address,INST_MEM[instruction_address]);
end

// ----------------------------------
// Input stimulus
// Generate the ad-hoc stimulus
// ----------------------------------
initial 
begin
  // Reset
  rst         = 1'b1;
  #(2*CLK_PERIOD) rst = 1'b0;
end

// ----------------------------------
// Output monitor
// ----------------------------------
always @(posedge clk) 
begin
  if (done) begin
    $finish;
  end
end

endmodule
