program class_data_hiding;
  parameter RAND_MIN = 10;
  parameter RAND_MAX = 20;

  class A;
    integer data;
    local   integer addr;
    protected integer cmd;
    static integer credits;

    rand bit [7:0] rand_vector;
    constraint c_rand_vector { rand_vector inside {[RAND_MIN:RAND_MAX]}; }

    rand bit [7:0] rand_vector2;
    constraint c_rand_vector2 { rand_vector2 inside {[RAND_MIN:RAND_MAX]}; }

    function new();
      begin
        data = 100;
        addr = 200;
        cmd  = 1;
        credits = 10;
      end
    endfunction
    task printA();
      begin
        $write ("value of data %0d in A\n", data);
        $write ("value of addr %0d in A\n", addr);
        $write ("value of cmd  %0d in A\n", cmd);
      end
    endtask
    task print();
      begin
        $write("print A\n");
      end
    endtask
    virtual task vprint();
      begin
        $write("vprint A\n");
      end
    endtask
    virtual task special_print(); endtask
  endclass

  class B extends A;
    task printB();
      begin
        $write ("value of data %0d in B\n", data);
        // Below line will give compile error
        //$write ("value of addr %0d in B\n", addr);
        $write ("value of cmd  %0d in B\n", cmd);
      end
    endtask
    task print();
      begin
        $write("print B\n");
      end
    endtask
    task vprint();
      begin
        $write("vprint B\n");
      end
    endtask
    task special_print();
      begin
        $write("B only print\n");
      end
    endtask
  endclass

  class C;
    A a;
    B b;
    function new();
      begin
        a = new();
        b = new();
        b.data = 2;
      end
    endfunction
    task printC();
      begin
        $write ("value of data %0d in C\n", a.data);
        $write ("value of data %0d in C\n", b.data);
        // Below line will give compile error
        //$write ("value of addr %0d in C\n", a.addr);
        //$write ("value of cmd  %0d in C\n", a.cmd);
        //$write ("value of addr %0d in C\n", b.addr);
        //$write ("value of cmd  %0d in C\n", b.cmd);
      end
    endtask
  endclass

  typedef struct packed {
    bit aa;
    bit bb;
    bit cc;
    bit dd;
  } test_struct_s;

  A a;
  B b;
  C c;
  A rand_test_a = new();

  test_struct_s ts;

  `define STRING "asdf.jkl"
  initial begin
    ts = 'h0;
    $display("ts.aa = %0b", ts[1:0]);
    c = new();
    c.a.printA();
    c.b.printB();
    c.printC();
    $display("This is a string: %s", "I am a string");
    $display("This is a preprocessor string: %s", `STRING);
    $write("value of credits is %0d\n",c.a.credits);
    $write("value of credits is %0d\n",c.b.credits);
    c.a.credits ++;
    $write("value of credits is %0d\n",c.a.credits);
    $write("value of credits is %0d\n",c.b.credits);
    c.b.credits ++;
    $write("value of credits is %0d\n",c.a.credits);
    $write("value of credits is %0d\n",c.b.credits);
    $write("-----------------------\n");
    b = new();
    b.data = 52;
    b.printB();

    a = b;
    a.printA();
    $write("-----------------------\n");
    a.print();
    b.print();
    $write("-----------------------\n");
    a.vprint();
    b.vprint();
    $write("-----------------------\n");
    a.special_print();

    for(int ii = -2; ii <= 2; ii++) begin
       if(ii) $display("if(%0d) = true",  ii);
       else   $display("if(%0d) = false", ii);
    end

    for(int ii = 0; ii < 10; ii++) $display("random number 10 times: %0d", $random(1));

    $display("rand_vector before uninitialized randomize: %0x", rand_test_a.rand_vector);
    if(!rand_test_a.randomize(rand_vector)) $display("FATAL cannot randomize");
    $display("rand_vector after uninitialized randomize: %0x", rand_test_a.rand_vector);
    rand_test_a.rand_vector = 0;
    if(!rand_test_a.randomize(rand_vector)) $display("FATAL cannot randomize");
    $display("rand_vector after initialized randomize: %0x", rand_test_a.rand_vector);

    for(int ii = 0; ii < 10; ii++) $display("random number from 5 to 10: %0d", random_range(5,10));
    for(int ii = 0; ii < 10; ii++) $display("random number: %0d, %0d", $random(0), $random(1));
  end

  function int random_range(int low, int high);
     return low + $unsigned($random(8)) % (high - low + 1);
  endfunction
endprogram
