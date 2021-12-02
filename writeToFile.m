function [] = writeToFile(filename, filetext)
%writeToFile opens a new file with write options and writes the text on it

fileID = fopen(filename,'w');
fprintf(fileID, filetext);
fclose(fileID);

end 