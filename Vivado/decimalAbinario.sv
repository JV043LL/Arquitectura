module decimalAbinario(
    input  int       decimal, // Entrada decimal (0-15)
    output logic [3:0] binario // Salida binaria de 4 bits
);
    assign binario = decimal[3:0]; // Trunca a 4 bits
endmodule