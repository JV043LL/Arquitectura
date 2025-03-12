module CompuertasAvanzadas(
    input  logic a, b,
    output logic nand_out, nor_out, xor_out
);
    
    // NAND usando primitiva
    nand (nand_out, a, b);
    
    // NOR usando dataflow
    assign nor_out = ~(a | b);
    
    // XOR usando behavioral
    always_comb xor_out = a ^ b;

endmodule