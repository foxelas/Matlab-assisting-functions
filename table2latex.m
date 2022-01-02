function Ttex = table2latex(T, selectedCols, label, caption, colWidths, isLandscape, notes)
%     table2latex converts a table to the tabular form for use in LaTeX.
%
%     Input args
%     T: a table of elements
%     selectedCols: index vector of table columns that need to be printed
%
%     Output args
%     Ttex: the formatted text for the table
%
%     Dependencies
%     None
%
%     LaTeX requirements for landscape view:
%     \usepackage{afterpage}
%     \usepackage{pdflscape} %rotates page
%
%     LaTeX requirements for table notes:
%     \usepackage[flushleft]{threeparttable}
%     
%
%     Usage
%     Ttex = table2latex(T);
%     Ttex = table2latex(T, [1:5]);
%     The function prints the formatted table, which then
%     can be copied and pasted to LaTeX as is.
%     Created by https://github.com/foxelas/ (2020)

hasHeader = istable(T);
if hasHeader
    v = table2cell(T);
elseif iscell(T)
    v = T;
else
    error('Unsupported file format.');
end

rows = size(v, 1);

if nargin < 2 || isempty(selectedCols)
    columns = size(v, 2);
    selectedCols = 1:columns;
else
    columns = numel(selectedCols);
end

if nargin < 3
    label = '';
end

if nargin < 4
    caption = '';
end

if nargin < 5 
    colWidths = [];
end

if nargin < 6 
    isLandscape = false;
end

if nargin < 7 
    notes = [];
end 

hasNotes = ~isempty(notes);

symb = ' & ';
slant = '\\';
textRows = cell(2+rows+1, 1);
curRows = 1;

if isLandscape 
    textRows{curRows} = strcat(slant, 'afterpage{\n\n', slant,'begin{landscape}\n');
    curRows = curRows + 1;
end 
strParts = {slant, 'begin{table}[htb]\n', slant, 'caption{', caption, '}\n', slant, 'begin{center}\n', slant, 'label{tab:', label, '}\n{', slant, 'tt'};
if hasNotes 
    strParts = {slant, 'begin{table}[htb]\n', slant, 'begin{threeparttable}\n', slant, 'caption{', caption, '}\n', slant, 'begin{center}\n', slant, 'label{tab:', label, '}\n{', slant, 'tt'};
end 
    
textRows{curRows} = strcat(strParts{:});
curRows = curRows + 1; 
textRows{curRows} = strcat(slant, 'begin{tabular}{|');


if length(colWidths) ~= columns
    disp('Incorrect number of column widths');
end

for ii = 1:columns
    if isempty(colWidths)
        textRows{curRows} = strcat(textRows{curRows}, 'c|');
    else
        textRows{curRows} = strcat(textRows{curRows}, 'p{', num2str(colWidths(ii)), 'cm}|');
    end
end
textRows{curRows} = strcat(textRows{curRows}, '}', slant, 'hline');

if hasHeader
    curRows = curRows + 1;
    textRows{curRows} = strcat(strjoin(cellfun(@(x) convertCell(x, hasHeader), T.Properties.VariableNames(selectedCols),...
        'UniformOutput', false), symb), slant, slant, slant, 'hline');
end

hasExtraHeader = false; 
for ii = 1:rows
    curRows = curRows + 1;
    if sum(cellfun(@(x)sum(ismissing(x)) == numel(x), v(ii, selectedCols))) == numel(v(ii, selectedCols))
        hasExtraHeader = true; 
        textRows{curRows} = '';
    elseif hasExtraHeader
        textRows{curRows} = strcat(slant, 'hline');
        curRows = curRows + 1;
        textRows{curRows} = strcat(strjoin(cellfun(@(x) convertCell(x, true), v(ii, selectedCols), 'UniformOutput', false), symb), slant, slant, slant, 'hline');
        curRows = curRows + 1;
        textRows{curRows} = strcat(slant, 'hline');
        hasExtraHeader = false;
    else
        textRows{curRows} = strcat(strjoin(cellfun(@(x) convertCell(x), v(ii, selectedCols), 'UniformOutput', false), symb), slant, slant, slant, 'hline');
    end
end

curRows = curRows + 1;
if hasNotes 
    strParts = {slant, 'end{tabular}\n}\n', slant, 'end{center}\n'};
    textRows{curRows} = strcat(strParts{:});
    strParts = {slant, 'begin{tablenotes}\n', slant, 'small\n'};
    curRows = curRows + 1;
    textRows{curRows} = strcat(strParts{:});
    for j = 1:numel(notes)
        curRows = curRows + 1;
        strParts = {slant,  strjoin({'item', notes{j}}, {' '}), '\n'};
        textRows{curRows} = strcat(strParts{:});
    end
    strParts =  {slant, 'end{tablenotes}\n', slant, 'end{threeparttable}\n', slant, 'end{table}', '\n\n'};
    curRows = curRows + 1;
    textRows{curRows} = strcat(strParts{:});  
else 
    strParts = {slant, 'end{tabular}\n}\n', slant, 'end{center}\n', slant, 'end{table}', '\n\n'};
    textRows{curRows} = strcat(strParts{:});
end

if isLandscape 
    curRows = curRows + 1;
    textRows{curRows} = strcat(slant, 'end{landscape}\n', '\n}');
end 

Ttex = strjoin(textRows, '\n');
fprintf(Ttex);

end

function xnew = convertCell(x, hasHeader)
if nargin < 2 
    hasHeader = false;
end 
if ~isempty(x) && ~strcmp(x, '')
    if strcmpi(x, 'na') | isnan(x)
        xnew = 'N/A';
        
    elseif ischar(x) && ~isnan(str2double(x))
        xnew = num2str(str2double(x) * 100, '%.2f');
        xnew = strcat(xnew, '\\%%');

    elseif ischar(x)
        xnew = strrep(x, '%', '\\%%'); 
        xnew = strrep(xnew, '&', '\\&');
        xnew = strrep(xnew, '_', '\\_');
        xnew = strrep(xnew, '\cite', '\\cite');
    elseif isnumeric(x)
        if floor(x)==x
            xnew = num2str(x, '%d');
        else
            xnew = num2str(x, '%.3f');
        end
    elseif islogical(x)
        logVals = {'F', 'T'};
        xnew = logVals{x+1};
    end

    if hasHeader 
        xnew = strcat('\\', 'textbf{', xnew , '}');
    end
else 
    xnew = ' ';
end

end