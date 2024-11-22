% Interface para Análise de Dados Raman
function interface
    % Janela principal
    fig = uifigure('Name', 'Análise de Dados Raman', 'Position', [100, 100, 800, 400]);

    % Layout da interface
    layout = uigridlayout(fig, [2, 2], ...
        'RowHeight', {'fit', 30}, ... 
        'ColumnWidth', {'4x', '1x'}); 

    % Label
    uilabel(layout, ...
        'Text', 'Pasta para salvar os resultados:', ...
        'FontWeight', 'bold', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'left', ...
        'Layout', struct('Row', 1, 'Column', [1 2]));

    % Campo de texto
    txtField = uieditfield(layout, 'text', ...
        'Placeholder', 'Insira o nome da pasta', ...
        'FontSize', 14, ...
        'BackgroundColor', '#E6E6E6', ...
        'HorizontalAlignment', 'left', ...
        'Layout', struct('Row', 2, 'Column', 1));

    % Botão "Salve"
    uibutton(layout, 'push', ...
        'Text', 'Salve', ...
        'FontSize', 16, ...
        'BackgroundColor', '#37353A', ...
        'FontColor', '#EEECDF', ...
        'ButtonPushedFcn', @(btn, event) saveCallback(txtField), ...
        'Layout', struct('Row', 2, 'Column', 2));
end

% Callback do botão "Salve"
function saveCallback(txtField)
    pasta = txtField.Value; % Obtém valor do campo
    if isempty(pasta)
        uialert(txtField.Parent, 'Por favor, insira um nome para a pasta.', 'Erro');
    else
        uialert(txtField.Parent, ['Pasta "' pasta '" salva com sucesso!'], 'Sucesso');
    end
end