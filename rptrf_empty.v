module rptr_empty #(
    parameter ADDRSIZE = 4
    
)(
    output reg rempty, // FIFO Empty flag generation 
    output [ADDRSIZE-1:0] raddr, //binary addr -> goes to the memory to get the read data address
    output reg [ADDRSIZE:0] rptr, // gray code of read pointer goes to write empty module to calculate the empty condition 
    input [ADDRSIZE:0] r2_wptr, // synchronized write pointer from the sync_w2r module 
    input rinc, // read increment
    input rclk,
    input rrst_n 
);

    reg [ADDRSIZE:0] rbin; //binary counter

    wire [ADDRSIZE:0] rgraynext, rbinnext; //next values

    always @(posedge rclk or negedge rrst_n) begin
        if(!rrst_n) {rbin,rptr} <= 0;
        else {rbin, rptr} <= {rbinnext,rgraynext}; //update both of them 
    end

    //Binary address for memory is jus the lower addrsize bits
    assign raddr = rbin[ADDRSIZE-1:0];

    //increment only if fifo is not empty and read increment is 1
    assign rbinnext = rbin + (rinc & ~rempty);

    // Binary to Gray Conversion 
    assign rgraynext = (rbinnext >> 1)^rbinnext;


    // empty condition generation

    wire rempty_val = (rgraynext == r2_wptr);

    always @(posedge rclk or negedge rrst_n) begin
        if(!rrst_n) rempty <= 1'b1;
        else rempty <= rempty_val;
    end



endmodule 