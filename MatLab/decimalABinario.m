% Función para convertir un número decimal (base 10) a binario (base 2)
% Entrada: decimal - número decimal a convertir (no negativo)
% Salida: cadena de texto con la representación binaria
function binario = decimalABinario(decimal)
    % Verificar si el número es negativo
    if decimal < 0
        error('El número debe ser no negativo.');
    end
    
    % Separar parte entera y fraccionaria
    parte_entera = floor(decimal);               % Parte entera del número
    parte_fraccionaria = decimal - parte_entera; % Parte decimal del número
    
    % Conversión de la parte entera a binario
    if parte_entera == 0
        bin_entera = '0'; % Caso especial para cero
    else
        residuos = [];    % Arreglo para almacenar los residuos
        num = parte_entera;
        
        % Calcular residuos mediante división sucesiva por 2
        while num > 0
            residuo = mod(num, 2);       % Obtener residuo
            residuos = [residuo, residuos]; % Agregar al frente del arreglo
            num = floor(num / 2);        % Actualizar número
        end
        
        % Convertir arreglo numérico a cadena y eliminar espacios
        bin_entera = num2str(residuos);
        bin_entera = bin_entera(bin_entera ~= ' ');
    end
    
    % Conversión de la parte fraccionaria a binario
    precision_max = 16; % Límite de precisión para evitar bucles infinitos
    bin_fraccionaria = '';
    
    if parte_fraccionaria > 0
        bin_fraccionaria = '.'; % Iniciar parte fraccionaria
        contador = 0;
        
        % Calcular bits mediante multiplicación sucesiva por 2
        while parte_fraccionaria > 0 && contador < precision_max
            parte_fraccionaria = parte_fraccionaria * 2; % Multiplicar por 2
            bit = floor(parte_fraccionaria);             % Obtener bit entero
            bin_fraccionaria = [bin_fraccionaria, num2str(bit)]; % Agregar bit
            parte_fraccionaria = parte_fraccionaria - bit; % Actualizar fracción
            contador = contador + 1;                      % Control de precisión
        end
    end
    
    % Combinar ambas partes para obtener resultado final
    binario = [bin_entera, bin_fraccionaria];
end