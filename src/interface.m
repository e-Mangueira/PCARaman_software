% Interface para Análise de Dados Raman
function interface
    % Janela principal
    fig = uifigure('Name', 'Análise de Dados Raman', 'Position', [100, 100, 800, 400]);

    % Layout da interface
    layout = uigridlayout(fig, [2, 2], ...
        'RowHeight', {'fit', 30}, ... 
        'ColumnWidth', {'4x', '1x'}); 

    % Label
    lbl = uilabel(layout, ...
        'Text', 'Pasta das análises:', ...
        'FontWeight', 'bold', ...
        'FontSize', 14, ...
        'HorizontalAlignment', 'left');
    lbl.Layout.Row = 1;
    lbl.Layout.Column = [1 2]; % Label ocupa as duas colunas

    % Campo de texto
    txtField = uieditfield(layout, 'text', ...
        'Placeholder', 'Insirir nome da pasta dos resultados', ...
        'FontSize', 14, ...
        'BackgroundColor', '#E6E6E6', ...
        'HorizontalAlignment', 'left');
    txtField.Layout.Row = 2;
    txtField.Layout.Column = 1;

    % Botão "Salve"
    btnSave = uibutton(layout, 'push', ...
        'Text', 'Salve', ...
        'FontSize', 16, ...
        'BackgroundColor', '#37353A', ...
        'FontColor', '#EEECDF', ...
        'ButtonPushedFcn', @(btn, event) saveCallback(txtField));
    btnSave.Layout.Row = 2;
    btnSave.Layout.Column = 2;
end

% Callback do botão "Salve"
function saveCallback(txtField)
    pastaRaiz = txtField.Value; % Obtém valor do campo
    if isempty(pastaRaiz)
        uialert(txtField.Parent, 'Por favor, insira um nome para a pasta.', 'Erro');
        return;
    end
    
    % Abrir janela para selecionar o caminho
    caminhoSelecionado = uigetdir('', 'Selecione o caminho para salvar os resultados');
    if caminhoSelecionado == 0 % Se o usuário cancelar
        uialert(txtField.Parent, 'Nenhum caminho foi selecionado.', 'Erro');
        return;
    end

    % Caminho completo da pasta raiz
    pastaRaizCompleta = fullfile(caminhoSelecionado, pastaRaiz);

    % Criar a pasta raiz se não existir
    if ~exist(pastaRaizCompleta, 'dir')
        mkdir(pastaRaizCompleta);
    end

    % Mensagem de sucesso
    uialert(txtField.Parent, ...
        sprintf('Pasta raiz "%s" configurada com sucesso!', pastaRaiz), ...
        'Sucesso');
end