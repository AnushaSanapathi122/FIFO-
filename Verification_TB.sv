//FIFO TESTBENCH CODE

//1️⃣ FIFO Interface
interface fifo_if(input logic clk);
  logic rst;
  logic wr_en;
  logic rd_en;
  logic [7:0] din;
  logic [7:0] dout;
  logic full;
  logic empty;
endinterface

//2️⃣ Transaction
class fifo_trans;
  bit wr_en;
  bit rd_en;
  bit [7:0] data;
endclass

//3️⃣ Generator
class fifo_generator;
  mailbox gen2drv;

  function new(mailbox m);
    gen2drv = m;
  endfunction

  task run();
    fifo_trans t;

    t = new(); t.wr_en=1; t.data=8'hA1; gen2drv.put(t);
    t = new(); t.wr_en=1; t.data=8'hB2; gen2drv.put(t);
    t = new(); t.rd_en=1;               gen2drv.put(t);
    t = new(); t.rd_en=1;               gen2drv.put(t);
  endtask
endclass

//4️⃣ Driver
class fifo_driver;
  virtual fifo_if vif;
  mailbox gen2drv;

  function new(virtual fifo_if v, mailbox m);
    vif = v;
    gen2drv = m;
  endfunction

  task run();
    fifo_trans t;
    forever begin
      gen2drv.get(t);

      @(posedge vif.clk);
      vif.wr_en <= t.wr_en;
      vif.rd_en <= t.rd_en;
      vif.din   <= t.data;

      @(posedge vif.clk);
      vif.wr_en <= 0;
      vif.rd_en <= 0;
    end
  endtask
endclass

//5️⃣ Monitor
class fifo_monitor;
  virtual fifo_if vif;
  mailbox mon2scb;

  function new(virtual fifo_if v, mailbox m);
    vif = v;
    mon2scb = m;
  endfunction

  task run();
    fifo_trans t;
    forever begin
      @(posedge vif.clk);

      if (vif.wr_en && !vif.full) begin
        t = new(); t.wr_en=1; t.data=vif.din;
        mon2scb.put(t);
      end

      if (vif.rd_en && !vif.empty) begin
        t = new(); t.rd_en=1; t.data=vif.dout;
        mon2scb.put(t);
      end
    end
  endtask
endclass

//6️⃣ Scoreboard
class fifo_scoreboard;
  mailbox mon2scb;
  bit [7:0] q[$];

  function new(mailbox m);
    mon2scb = m;
  endfunction

  task run();
    fifo_trans t;
    forever begin
      mon2scb.get(t);

      if (t.wr_en) q.push_back(t.data);
      if (t.rd_en) begin
        if (t.data == q.pop_front())
          $display("PASS: %h", t.data);
        else
          $display("FAIL");
      end
    end
  endtask
endclass

//7️⃣ Environment
class fifo_env;
  fifo_generator gen;
  fifo_driver drv;
  fifo_monitor mon;
  fifo_scoreboard scb;

  mailbox gen2drv;
  mailbox mon2scb;

  function new(virtual fifo_if vif);
    gen2drv = new();
    mon2scb = new();

    gen = new(gen2drv);
    drv = new(vif, gen2drv);
    mon = new(vif, mon2scb);
    scb = new(mon2scb);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none
  endtask
endclass

//8️⃣ Top Testbench
module tb_fifo;
  logic clk=0;
  always #5 clk = ~clk;

  fifo_if fif(clk);

  fifo dut (
    .clk(clk),
    .rst(fif.rst),
    .wr_en(fif.wr_en),
    .rd_en(fif.rd_en),
    .din(fif.din),
    .dout(fif.dout),
    .full(fif.full),
    .empty(fif.empty)
  );

  fifo_env env;

  initial begin
    fif.rst = 1;
    #10 fif.rst = 0;

    env = new(fif);
    env.run();

    #200 $finish;
  end
endmodule
