% Función para convertir números enteros decimales a binario
% Entrada: decimal - número entero no negativo (base 10)
% Salida: cadena de texto con la representación binaria
function binario = decimalEnteroABinario(decimal)
    % Validación 1: Números negativos
    if decimal < 0
        error('El número debe ser no negativo');
    end
    
    % Validación 2: Verificar que sea entero
    if decimal ~= floor(decimal)
        error('El número debe ser entero');
    end
    
    % Caso especial para cero
    if decimal == 0
        binario = '0';
        return
    end
    
    % Algoritmo de división sucesiva por 2
    residuos = [];  % Arreglo para almacenar dígitos binarios
    
    while decimal > 0
        residuo = mod(decimal, 2);        % Calcular residuo
        residuos = [residuo, residuos];   % Prepend al arreglo
        decimal = floor(decimal / 2);     % Actualizar número
    end
    
    % Convertir arreglo numérico a cadena y eliminar espacios
    binario = num2str(residuos);
    binario = binario(binario ~= ' ');
end