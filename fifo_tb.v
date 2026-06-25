`timescale 1ns/1ps


module tb_fifo;

parameter DSIZE = 8;
parameter ASIZE = 4;  //depth = 2^4 = 16 locations


//-- Input Test Signals -- //
reg [7:0] wdata;
reg winc, wclk, wrst_n;
reg rinc, rclk, rrst_n;


//-- Output Test Signals -- //
wire [7:0] rdata;
wire wfull, rempty;


integer i;

// Instantiate the design for testing

fifo #(DSIZE,ASIZE) dut(
    .rdata(rdata), .wfull(wfull), .rempty(rempty),
    .wdata(wdata), .winc(winc), .wclk(wclk), .wrst_n(wrst_n),
    .rinc(rinc), .rclk(rclk), .rrst_n(rrst_n)
);

// Write Clk -- 100 MHz
initial wclk = 0; 
always #5 wclk = ~wclk;

//Read Clk less than write Clk -- 67Mhz
initial rclk = 0; 
always #7.5 rclk = ~rclk;


// Test Cases 


initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb_fifo);


    $display("--- RESET ---");
    winc=0; rinc=0; wdata=0;
    wrst_n=0; rrst_n=0;
    repeat(4) @(posedge wclk);          //After a write or read, the pointer has to cross the clock domain through a 2 flip-flop synchronizer. That takes at least 2 cycles of the destination clock, wait for 4 cycles to  safely check the flags
    wrst_n=1; rrst_n=1;
    repeat(2) @(posedge rclk);
    $display("rempty=%b wfull=%b (expect 1 0)", rempty, wfull);

    // check if empty flag goes down when data is written

    $display("\n--- WRITE 4 WORDS ---");
    for(i=1;i<=4;i=i+1)begin 

        @(negedge wclk);
        wdata = i*10;
        winc = 1;
        @(negedge wclk);
        winc = 0;
        $display("Wrote 0x%02h", wdata);

    end

    repeat(4) @(posedge rclk);
    $display("rempty = %b",rempty);

    // READ those 4 data written

    $display("Read 4 Words");
    for (i = 0; i < 4; i = i+1) begin
      @(negedge rclk);
      $display("read  0x%02h", rdata);  // capture before rinc because logic for output read data is combinational when raddr updates read data is fetched out
      rinc = 1;
      @(negedge rclk);
      rinc = 0;

    end

    repeat(4) @(posedge rclk);
    $display("rempty=%b ", rempty); // should come as 1 because all the data is read from the memory;
    
    // write full and check if full flag gets asserted 


    $display("\n--- FILL TO FULL ---");
    for (i = 0; i < 16; i = i+1) begin
      @(negedge wclk);
      wdata = i;
      winc  = 1;
      @(negedge wclk);
      winc  = 0;
    end
    repeat(4) @(posedge wclk);
    $display("wfull=%b (expect 1)", wfull);

    // Try write when full (overflow check)
    $display("\n--- WRITE WHEN FULL ---");
    @(negedge wclk);
    wdata = 8'hFF; winc = 1;
    @(negedge wclk);
    winc = 0;
    repeat(2) @(posedge wclk);
    $display("wfull=%b", wfull); // expect 1, no overflow.
 
    // read completely (16 reads)
    $display("\n--- DRAIN TO EMPTY ---");
    for (i = 0; i < 16; i = i+1) begin
      @(negedge rclk);
      rinc = 1;
      @(negedge rclk);
      rinc = 0;
    end
    repeat(4) @(posedge rclk);
    $display("rempty=%b", rempty); //(expect 1)
 
    
    // Try read when empty (underflow check)
    
    $display("\n--- READ WHEN EMPTY ---");
    @(negedge rclk);
    rinc = 1;
    @(negedge rclk);
    rinc = 0;
    repeat(2) @(posedge rclk);
    $display("rempty=%b", rempty); //(expect 1, no underflow)
 
    $display("\n--- DONE ---");
    $finish;
  end
 
endmodule


 