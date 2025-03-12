function binario = decimalABinarioIEEE754(numero, precision)
    % Convierte un número decimal al formato IEEE 754 (32 o 64 bits)
    % Entradas:
    %   numero: número decimal a convertir
    %   precision: 'simple' (32 bits) o 'doble' (64 bits) [opcional, default: simple]
    % Salida: cadena binaria en formato IEEE 754
    
    % Establecer precisión por defecto
    if nargin < 2
        precision = 'simple';
    end
    
    % Configurar parámetros según precisión
    switch lower(precision)
        case 'simple'
            bits_total = 32;
            bits_exponente = 8;
            bits_mantisa = 23;
            bias = 127;
        case 'doble'
            bits_total = 64;
            bits_exponente = 11;
            bits_mantisa = 52;
            bias = 1023;
        otherwise
            error('Precisión no válida. Usar "simple" o "doble"');
    end
    
    % Manejar casos especiales
    if isnan(numero)
        binario = manejarNaN(bits_exponente, bits_mantisa);
        return;
    elseif isinf(numero)
        binario = manejarInfinito(numero > 0, bits_exponente, bits_mantisa);
        return;
    elseif numero == 0
        binario = manejarCero(numero > 0, bits_total);
        return;
    end
    
    % Determinar signo
    signo = numero < 0;
    numero = abs(numero);
    
    % Descomponer número en parte entera y fraccionaria
    parte_entera = floor(numero);
    parte_fraccionaria = numero - parte_entera;
    
    % Convertir parte entera a binario
    bin_entera = decimalEnteroABinario(parte_entera);
    
    % Convertir parte fraccionaria a binario
    bin_fraccionaria = convertirFraccion(parte_fraccionaria, bits_mantisa + 2);
    
    % Combinar y normalizar
    [mantisa, exponente] = normalizarNumero([bin_entera bin_fraccionaria]);
    
    % Aplicar bias al exponente
    exponente_biased = exponente + bias;
    
    % Convertir componentes a binario
    signo_bit = num2str(signo);
    exponente_bin = completarBits(decimalEnteroABinario(exponente_biased), bits_exponente);
    mantisa_bin = completarMantisa(mantisa, bits_mantisa);
    
    % Combinar todos los componentes
    binario = [signo_bit exponente_bin mantisa_bin];
    
    % Verificar longitud final
    if length(binario) ~= bits_total
        error('Error en la conversión: longitud incorrecta');
    end
end

%% Funciones auxiliares
function bin = manejarNaN(bits_exp, bits_man)
    % Todos unos en exponente y al menos un 1 en mantisa
    exponente = repmat('1', 1, bits_exp);
    mantisa = [1 repmat('0', 1, bits_man-1)]; % NaN señalizado
    bin = ['0' exponente mantisa];
end

function bin = manejarInfinito(positivo, bits_exp, bits_man)
    signo = num2str(~positivo);
    exponente = repmat('1', 1, bits_exp);
    mantisa = repmat('0', 1, bits_man);
    bin = [signo exponente mantisa];
end

function bin = manejarCero(positivo, bits_total)
    signo = num2str(~positivo);
    bin = [signo repmat('0', 1, bits_total-1)];
end

function [mantisa, exponente] = normalizarNumero(binario)
    % Encuentra la primera ocurrencia de '1' para normalizar
    punto = find(binario == '1', 1);
    
    if isempty(punto)
        % Cero (ya manejado anteriormente)
        mantisa = '0';
        exponente = 0;
    else
        % Calcular exponente y ajustar mantisa
        exponente = punto - 1;
        mantisa = binario(punto+1:end);
    end
end

function bin_fraccion = convertirFraccion(fraccion, max_bits)
    bin_fraccion = '';
    contador = 0;
    while fraccion > 0 && contador < max_bits
        fraccion = fraccion * 2;
        if fraccion >= 1
            bin_fraccion = [bin_fraccion '1'];
            fraccion = fraccion - 1;
        else
            bin_fraccion = [bin_fraccion '0'];
        end
        contador = contador + 1;
    end
end

function str = completarBits(binario, longitud)
    str = binario;
    if length(str) < longitud
        str = [repmat('0', 1, longitud - length(str)) str];
    else
        str = str(1:longitud);
    end
end

function mantisa = completarMantisa(binario, longitud)
    mantisa = binario;
    if length(mantisa) < longitud
        mantisa = [mantisa repmat('0', 1, longitud - length(mantisa))];
    else
        mantisa = mantisa(1:longitud);
    end
end

% Función de conversión entera a binario (versión optimizada)
function bin = decimalEnteroABinario(num)
    if num == 0
        bin = '0';
        return
    end
    bits = [];
    while num > 0
        bits = [num2str(mod(num,2)) bits];
        num = floor(num/2);
    end
    bin = char(bits);
end