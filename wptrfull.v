module wptr_full #(parameter ADDRSIZE = 4

)(
    output reg wfull,
    output [ADDRSIZE-1:0] waddr,
    output reg [ADDRSIZE:0] wptr,
    input [ADDRSIZE:0] w2_rptr,
    input winc,
    input wclk,
    input wrst_n
);

    reg [ADDRSIZE:0] wbin;

    wire [ADDRSIZE:0] wgraynext, wbinnext;

    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) {wbin,wptr} <= 0;
        else {wbin,wptr} <= {wbinnext,wgraynext};
    end

    //Binary address for memory

    assign waddr = wbin[ADDRSIZE-1:0];

    // Next Binary: update if not full and winc = 1
    assign wbinnext = wbin + (winc & ~wfull);

    //Binary to Gray 

    assign wgraynext = (wbinnext >> 1) ^ wbinnext;


    wire wfull_val = (wgraynext == {~w2_rptr[ADDRSIZE:ADDRSIZE-1],w2_rptr[ADDRSIZE-2:0]});

    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) wfull <= 1'b0;
        else wfull <= wfull_val;
    end 



    
endmodule