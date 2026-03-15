module tb;

logic clk;
logic rst;

logic wr_en;
logic rd_en;

logic [7:0] data_in;
logic [7:0] data_out;

logic full;
logic empty;


// Instantiate FIFO
fifo dut(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);


// Clock generation
always #5 clk = ~clk;


// Test sequence
initial begin

$dumpfile("dump.vcd");
$dumpvars(0,tb);

clk = 0;
rst = 1;
wr_en = 0;
rd_en = 0;

#20 rst = 0;

// WRITE DATA
@(posedge clk)
wr_en = 1;
data_in = 8'd10;

@(posedge clk)
data_in = 8'd20;

@(posedge clk)
data_in = 8'd30;

@(posedge clk)
wr_en = 0;


// READ DATA
@(posedge clk)
rd_en = 1;

@(posedge clk)
rd_en = 1;

@(posedge clk)
rd_en = 1;

@(posedge clk)
rd_en = 0;

#50 $finish;

end

endmodule
