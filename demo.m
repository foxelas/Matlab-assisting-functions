%% demo 
clc;

folderName = 'demo/';

infile = strcat(folderName, 'demoVals.xlsx');
T = readtable(infile,'Sheet', 'Test');
% T = removevars(T, 'Limits');

tabname = 'test-table';
latext1 = table2latex(T, [], tabname, 'List of Eligible Studies');
writeToFile(fullfile(folderName, strcat(tabname, '.txt')), latext1);