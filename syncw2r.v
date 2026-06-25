module sync_w2r #(parameter ADDRSIZE = 4)
(
    output reg [ADDRSIZE:0] rd2_wptr, 
    input [ADDRSIZE:0] wptr,
    input rclk,
    input rrst_n 
);
    reg [ADDRSIZE:0] rd1_wptr;

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) {rd2_wptr,rd1_wptr} <= 0;
        else {rd2_wptr, rd1_wptr} <= {rd1_wptr, wptr};        
    end


endmodule
