module CompuertasBasicas(
    input  logic a, b,
    output logic and_out, or_out, not_out
);
    
    // AND usando primitiva
    and (and_out, a, b);
    
    // OR usando dataflow
    assign or_out = a | b;
    
    // NOT usando behavioral
    always_comb not_out = ~a;

endmodule