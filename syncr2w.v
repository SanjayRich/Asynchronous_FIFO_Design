module sync_r2w #(parameter ADDRSIZE = 4)
(
    output reg [ADDRSIZE:0] w2_rptr, 
    input [ADDRSIZE:0] rptr,
    input wclk,
    input wrst_n 
);
    reg [ADDRSIZE:0] w1_rptr;

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) {w2_rptr,w1_rptr} <= 0;
        else {w2_rptr, w1_rptr} <= {w1_rptr, rptr};        
    end


endmodule
