function decimal = binarioIEEE754Adecimal(binario)
    % Convierte una cadena binaria IEEE 754 (32 o 64 bits) a número decimal
    % Entrada: cadena binaria de 32 o 64 caracteres ('0'/'1')
    % Salida: número decimal o símbolos especiales (Inf, NaN)
    
    % Validación inicial
    if ~ischar(binario) || ~all(ismember(binario, '01'))
        error('Entrada inválida: debe ser cadena binaria (solo 0 y 1)');
    end
    
    longitud = length(binario);
    if ~ismember(longitud, [32, 64])
        error('Longitud inválida: debe ser 32 bits (simple) o 64 bits (doble)');
    end
    
    % Parámetros según precisión
    if longitud == 32
        bias = 127;
        bits_exponente = 8;
        bits_mantisa = 23;
    else
        bias = 1023;
        bits_exponente = 11;
        bits_mantisa = 52;
    end
    
    % Extraer componentes
    signo = binario(1) - '0';            % Bit de signo (0 positivo, 1 negativo)
    exponente_bin = binario(2:bits_exponente+1); % Exponente en binario
    mantisa_bin = binario(bits_exponente+2:end); % Mantisa
    
    % Convertir exponente a decimal
    exponente = binarioADecimalEntero(exponente_bin) - bias;
    
    % Manejar casos especiales
    if all(exponente_bin == '1')  % Todos unos en exponente
        if all(mantisa_bin == '0') % Infinito
            decimal = (-1)^signo * Inf;
        else                     % NaN
            decimal = NaN;
        end
        return;
    elseif all(exponente_bin == '0') % Cero o subnormal
        if all(mantisa_bin == '0')  % Cero
            decimal = (-1)^signo * 0;
            return;
        else                        % Subnormal: exponente = -bias + 1
            exponente = -bias + 1;
            mantisa = binarioFraccionarioADecimal(mantisa_bin);
        end
    else                          % Normalizado
        mantisa = 1 + binarioFraccionarioADecimal(mantisa_bin); % +1 implícito
    end
    
    % Calcular valor final
    decimal = (-1)^signo * mantisa * 2^exponente;
end

% Función auxiliar para convertir parte fraccionaria binaria
function decimal = binarioFraccionarioADecimal(binario)
    decimal = 0;
    for i = 1:length(binario)
        decimal = decimal + (binario(i) - '0') * 2^(-i);
    end
end

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