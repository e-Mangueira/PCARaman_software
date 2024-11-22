% Interface para Análise de Dados Raman
function interface
    % Criação da janela principal e layout
    fig = createMainWindow('Análise de Dados Raman', [100, 100, 800, 500]);
    layout = createGridLayout(fig, {25, 30, 'fit', 100, 25, '1x'}, {'4x', '1x'});
    
    % Seção: Pasta para salvar resultados
    addSavePathSection(layout, 1, 2);
    
    % Seção: Seleção de arquivo
    addFileSelectionSection(layout, 3, 4);
    
    % Seção: Opções de análises de dados
    addAnalysisOptionsSection(layout, 5, 6);
end

%% Funções Auxiliares

function fig = createMainWindow(name, position)
    % Cria a janela principal da interface
    fig = uifigure('Name', name, 'Position', position);
end

function layout = createGridLayout(fig, rowHeight, colWidth)
    % Configura o layout em grade para a janela principal
    layout = uigridlayout(fig);
    layout.RowHeight = rowHeight;
    layout.ColumnWidth = colWidth;
    layout.RowSpacing = 10;
    layout.ColumnSpacing = 10;
    layout.Padding = [10, 10, 10, 10];
end

function addSavePathSection(layout, rowLabel, rowInput)
    % Adiciona a seção para inserir o caminho de salvamento
    lbl = uilabel(layout, 'Text', 'Pasta para salvar os resultados:', ...
        'FontWeight', 'bold', 'FontSize', 14, ...
        'HorizontalAlignment', 'left');
    lbl.Layout.Row = rowLabel;
    lbl.Layout.Column = [1 2];
    
    txtField = uieditfield(layout, 'text', ...
        'Placeholder', 'Insira o nome da pasta', ...
        'FontSize', 14, 'BackgroundColor', '#E6E6E6');
    txtField.Layout.Row = rowInput;
    txtField.Layout.Column = 1;
    
    btn = uibutton(layout, 'push', 'Text', 'Salvar', ...
        'FontSize', 16, 'BackgroundColor', '#37353A', ...
        'FontColor', '#EEECDF', ...
        'ButtonPushedFcn', @(btn, event) saveCallback(txtField));
    btn.Layout.Row = rowInput;
    btn.Layout.Column = 2;
end

function addFileSelectionSection(layout, rowLabel, rowInput)
    % Adiciona a seção para selecionar o arquivo de dados
    lbl = uilabel(layout, 'Text', 'Arquivo de dados:', ...
        'FontWeight', 'bold', 'FontSize', 14, ...
        'HorizontalAlignment', 'left');
    lbl.Layout.Row = rowLabel;
    lbl.Layout.Column = 1;
    
    frameArquivo = uipanel(layout, 'BackgroundColor', '#E6E6E6', ...
        'BorderType', 'line');
    frameArquivo.Layout.Row = rowInput;
    frameArquivo.Layout.Column = [1 2];
    
    frameLabel = uilabel(frameArquivo, 'Text', 'Nenhum arquivo selecionado', ...
        'FontSize', 12, 'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'top', ...
        'Position', [10, 70, 780, 20]);
    
    btn = uibutton(layout, 'push', 'Text', 'Selecionar arquivo', ...
        'FontSize', 16, 'BackgroundColor', '#37353A', ...
        'FontColor', '#EEECDF', ...
        'ButtonPushedFcn', @(btn, event) chooseDataCallback(frameLabel));
    btn.Layout.Row = rowLabel;
    btn.Layout.Column = 2;
end

function addAnalysisOptionsSection(layout, rowLabel, rowInput)
    % Adiciona a seção para selecionar as opções de análises de dados
    lbl = uilabel(layout, 'Text', 'Análises de dados:', ...
        'FontWeight', 'bold', 'FontSize', 14, ...
        'HorizontalAlignment', 'left');
    lbl.Layout.Row = rowLabel;
    lbl.Layout.Column = 1;
    
    frameAnalises = uipanel(layout, 'BackgroundColor', '#E6E6E6', ...
        'BorderType', 'line');
    frameAnalises.Layout.Row = rowInput;
    frameAnalises.Layout.Column = [1 2];
    
    % Adicionar labels para identificar as colunas
    uilabel(frameAnalises, 'Text', 'Pré-Processamento', ...
        'FontWeight', 'bold', 'FontSize', 12, ...
        'Position', [10, 200, 150, 20], ... % Primeira coluna checkbox
        'HorizontalAlignment', 'left');
    
    uilabel(frameAnalises, 'Text', 'Ajustes de dados', ...
        'FontWeight', 'bold', 'FontSize', 12, ...
        'Position', [300, 200, 150, 20], ... % Segunda coluna checkbox
        'HorizontalAlignment', 'left');
    
    uilabel(frameAnalises, 'Text', 'Análise dos dados', ...
        'FontWeight', 'bold', 'FontSize', 12, ...
        'Position', [550, 200, 200, 20], ... % Terceira coluna checkbox
        'HorizontalAlignment', 'left');
    
    % Posicionar checkboxes em três colunas na mesma linha
    uicheckbox(frameAnalises, 'Text', 'Remover 1a coluna', ...
        'FontSize', 14, 'Position', [10, 180, 150, 20]); 
    uicheckbox(frameAnalises, 'Text', 'Remover 2a linha', ...
        'FontSize', 14, 'Position', [10, 160, 150, 20]); 
    uicheckbox(frameAnalises, 'Text', 'Remover Outliers', ...
        'FontSize', 14, 'Position', [10, 140, 150, 20]); 
    
    uicheckbox(frameAnalises, 'Text', 'Transf. Logarítmica', ...
        'FontSize', 14, 'Position', [300, 180, 150, 20]);
    uicheckbox(frameAnalises, 'Text', 'Transf. Polinomial', ...
        'FontSize', 14, 'Position', [300, 160, 150, 20]); 
    uicheckbox(frameAnalises, 'Text', 'Normalizar', ...
        'FontSize', 14, 'Position', [300, 140, 150, 20]);    
    uicheckbox(frameAnalises, 'Text', 'Estatística básica', ...
        'FontSize', 14, 'Position', [550, 180, 200, 20]);
    uicheckbox(frameAnalises, 'Text', 'PCA', ...
        'FontSize', 14, 'Position', [550, 160, 200, 20]); 
    uicheckbox(frameAnalises, 'Text', 'ANOVA', ...
        'FontSize', 14, 'Position', [550, 140, 200, 20]); 
     
    
end

%% Callbacks

function saveCallback(txtField)
    % Callback para salvar o caminho configurado
    pastaRaiz = txtField.Value;
    if isempty(pastaRaiz)
        uialert(txtField.Parent, 'Por favor, insira um nome para a pasta.', 'Erro');
        return;
    end
    
    caminhoSelecionado = uigetdir('', 'Selecione o caminho para salvar os resultados');
    if caminhoSelecionado == 0
        uialert(txtField.Parent, 'Nenhum caminho foi selecionado.', 'Erro');
        return;
    end
    
    pastaRaizCompleta = fullfile(caminhoSelecionado, pastaRaiz);
    if ~exist(pastaRaizCompleta, 'dir')
        mkdir(pastaRaizCompleta);
    end
    
    uialert(txtField.Parent, sprintf('Pasta "%s" configurada com sucesso!', pastaRaiz), 'Sucesso');
end

function chooseDataCallback(frameLabel)
    % Callback para selecionar o arquivo de dados
    [file, path] = uigetfile({'*.*', 'Todos os Arquivos'; ...
                              '*.csv', 'Arquivos CSV (*.csv)'; ...
                              '*.xlsx', 'Arquivos Excel (*.xlsx)'}, ...
                              'Selecione o arquivo de dados');
    if isequal(file, 0)
        frameLabel.Text = 'Nenhum arquivo selecionado';
    else
        frameLabel.Text = sprintf('Arquivo selecionado: %s', file);
    end
end