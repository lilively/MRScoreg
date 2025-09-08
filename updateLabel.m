function updateLabel(row, col, slice, x1y1zLabel)
    if ~isempty(row) && ~isempty(col) && ~isempty(slice) && ...
       row > 0 && col > 0 && slice > 0
        x1y1zLabel.Text = sprintf('%d×%d×%d (X×Y×Z)', col, row, slice);
    else
        x1y1zLabel.Text = '0×0×0 (X×Y×Z)';
    end
end