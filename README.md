# Available functions in this repository 

- table2latex in [branch table2latex](https://github.com/foxelas/Matlab-assisting-functions/tree/table2latex)
  Gets a MATLAB table and prepares a text string with it's LaTeX equivalent. 
  Usage:
      Ttex = table2latex(T, [], label, caption, [], false, notes, false);
      writeToFile(filePath, Ttex);
	    
- getColorChartColors in [branch table2latex](https://github.com/foxelas/Matlab-assisting-functions/tree/getColorChartColors)
  Plots the spectral signatures of each patch of a Color Chart with their respective colors. 
  
- cutout in [branch cutout-modified](https://github.com/foxelas/Matlab-assisting-functions/tree/cutout-modified)
  Modification of function cutout, which splits / removes part of a plot's x axis 
  Usage: 
  	ax = gca;
  	cutout(ax, 100, 300, 10);