% Función para convertir cadena binaria a número entero decimal
% Entrada: binario - cadena de caracteres con 0s y 1s (ej: '1010')
% Salida: decimal - número entero equivalente en base 10
function decimal = binarioADecimalEntero(binario)
    % Validación 1: Verificar que la entrada sea una cadena de caracteres
    if ~ischar(binario)
        error('La entrada debe ser una cadena de caracteres (ej: ''1010'')');
    end
    
    % Validación 2: Cadena no vacía
    if isempty(binario)
        error('La cadena binaria no puede estar vacía');
    end
    
    % Validación 3: Solo caracteres 0 y 1
    caracteres_validos = ismember(binario, '01');
    if ~all(caracteres_validos)
        pos = find(~caracteres_validos, 1);
        error('Carácter inválido "%c" en posición %d', binario(pos), pos);
    end
    
    % Conversión principal
    longitud = length(binario);
    decimal = 0;
    
    % Recorrer cada bit de izquierda a derecha
    for i = 1:longitud
        bit = binario(i);                     % Obtener bit actual
        valor_posicion = 2^(longitud - i);    % Calcular peso posicional
        decimal = decimal + (bit - '0')*valor_posicion; % Sumar valor
    end
end