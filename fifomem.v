

//Dual Port Ram -- Fifo Mem 
module fifomem #(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 4
)(
    output [DATASIZE-1:0] rdata,
    input [DATASIZE-1:0] wdata,
    input [ADDRSIZE-1:0] waddr, raddr,
    input wclken, // Write enable same as win
    input wfull, 
    input wclk
);

    localparam DEPTH = 1 << ADDRSIZE; // Depth == 2^addrsize, here 2^4 -- 16. 16 locations (0->15).
 
    reg [DATASIZE-1:0] mem[0:DEPTH-1];

    //Asynchronous Read in this fifo design read - data appears immediately when raddr changes
    assign rdata = mem[raddr];

    //Synchronous write -- only when fifo is not full 

    always @(posedge wclk) begin
        if(wclken && !wfull)
            mem[waddr] <= wdata;
    end



endmodule 

