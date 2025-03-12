module sumador4bits(
    input  logic [3:0] a, b,
    output logic [3:0] sum,
    output logic carry_out
);
    logic [4:0] total = a + b;
    assign {carry_out, sum} = total;
endmodule

module full_adder(
    input  logic a, b, cin,
    output logic sum, cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder_4bit_structural(
    input  logic [3:0] a, b,
    output logic [3:0] sum,
    output logic carry_out
);
    logic [3:0] carry;
    
    full_adder fa0(a[0], b[0], 0,      sum[0], carry[0]);
    full_adder fa1(a[1], b[1], carry[0], sum[1], carry[1]);
    full_adder fa2(a[2], b[2], carry[1], sum[2], carry[2]);
    full_adder fa3(a[3], b[3], carry[2], sum[3], carry[3]);
    
    assign carry_out = carry[3];
endmodule