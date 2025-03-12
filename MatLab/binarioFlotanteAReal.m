% Función para convertir números binarios con punto flotante a decimal
% Entrada: binario - cadena con formato '101.101' (0s, 1s y máximo un punto)
% Salida: real_num - número decimal equivalente en base 10
function real_num = binarioFlotanteAReal(binario)
    % Validación 1: Entrada debe ser cadena de caracteres
    if ~ischar(binario)
        error('La entrada debe ser una cadena de caracteres');
    end
    
    % Validación 2: Solo caracteres permitidos (0, 1 y punto)
    caracteres_permitidos = ismember(binario, '01.');
    if ~all(caracteres_permitidos)
        pos = find(~caracteres_permitidos, 1);
        error('Carácter inválido "%s" en posición %d', binario(pos), pos);
    end
    
    % Validación 3: Máximo un punto decimal
    if sum(binario == '.') > 1
        error('Solo se permite un punto decimal');
    end
    
    % Dividir en parte entera y fraccionaria
    partes = strsplit(binario, '.');
    parte_entera = partes{1};
    
    % Manejar caso sin parte fraccionaria
    if length(partes) > 1
        parte_fraccionaria = partes{2};
    else
        parte_fraccionaria = '';
    end
    
    % Validación 4: Al menos una parte debe tener dígitos
    if isempty(parte_entera) && isempty(parte_fraccionaria)
        error('El número binario no contiene dígitos válidos');
    end
    
    % Convertir parte entera (usando función anterior)
    if isempty(parte_entera)
        decimal_entero = 0;
    else
        decimal_entero = binarioADecimalEntero(parte_entera);
    end
    
    % Convertir parte fraccionaria
    decimal_fraccionario = 0;
    if ~isempty(parte_fraccionaria)
        for i = 1:length(parte_fraccionaria)
            bit = parte_fraccionaria(i);
            decimal_fraccionario = decimal_fraccionario + ...
                                  (bit - '0') * 2^(-i);  % 1/2^i
        end
    end
    
    % Combinar resultados
    real_num = decimal_entero + decimal_fraccionario;
end