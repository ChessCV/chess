function [ FENStr ] = FENString( FEN )
FENStr = '';
for i=1:size(FEN, 2) % Iterate over each column.
    str = mat2str(cell2mat(FEN(:, i))');
    [start, stop] = regexp(str, '(\.+)+');
    while ~isempty(start)
        str = strrep(str, str(start(1):stop(1)), ...
            num2str(length(start(1):stop(1))));
        [start, stop] = regexp(str, '(\.+)+');
    end
    FENStr = strcat(FENStr, str, '/');
end
FENStr = FENStr(1:end-1);
FENStr = strrep(FENStr, '''', '');
end
