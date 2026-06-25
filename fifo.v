module fifo #(
    parameter DSIZE = 8, 
    parameter ASIZE = 4
)(
    output [DSIZE-1:0] rdata,
    output wfull,
    output rempty,
    input [DSIZE-1:0] wdata,
    input winc, wclk, wrst_n,
    input rinc, rclk, rrst_n
);

    wire [ASIZE-1:0] waddr, raddr; // addresses to access the fifo memory
    wire [ASIZE:0] wptr, rptr, w2_rptr, r2_wptr; //pointers for address generation and full and empty condition generation


    //Synchronize the read pointer to the write clock domain

    sync_r2w #(ASIZE) sync_r2w(
        .w2_rptr(w2_rptr),.rptr(rptr),
        .wclk(wclk),.wrst_n(wrst_n)
    );

    //Synchronize the write pointer to the read clock domain


    sync_w2r #(ASIZE) sync_w2r (
    .rd2_wptr(r2_wptr), .wptr(wptr),
    .rclk(rclk), .rrst_n(rrst_n));

    // instantiate dual port ram 
    fifomem #(DSIZE,ASIZE) fifomem(
        .rdata(rdata), .wdata(wdata),
        .waddr(waddr), .raddr(raddr),
        .wclken(winc), .wfull(wfull),
        .wclk(wclk)
    );

    // Empty condition generation and read pointer logic

    rptr_empty #(ASIZE) rptr_empty (
        .rempty(rempty), .raddr(raddr),
        .rptr(rptr), .r2_wptr(r2_wptr),
        .rinc(rinc), .rclk(rclk), .rrst_n(rrst_n)
    );


    // Full condition generation and Write Pointer Logic 

    wptr_full #(ASIZE) wptr_full(
        .wfull(wfull), .waddr(waddr),
        .wptr(wptr), .w2_rptr(w2_rptr),
        .winc(winc), .wclk(wclk), .wrst_n(wrst_n)
    );



endmodule 