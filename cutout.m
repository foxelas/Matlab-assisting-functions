%% Customized 
% M.Michalczuk 07.03.2019
% ver. 2.0
% ISEP
% cutout(axes_handle,Start,End,Gap);
function cutoff(axes_handle,Start,End,Gap)
xt=axes_handle.XTick;
xl=axes_handle.XLim;
p=allchild(axes_handle);
px={p.XData};
py={p.YData};
leg=findobj(axes_handle.Parent,'Tag','legend');
[leg.AutoUpdate]=deal('off');
kolor={p.Color};
hold on;
for i=[length(p):-1:1]
    if isempty(find(px{i}>=Start,1)) 
        p(i).XData=px{i}(1);
        p(i).YData=py{i}(1);
    else
        p(i).XData=px{i}(1:find(px{i}>=Start,1));
        p(i).YData=py{i}(1:find(px{i}>=Start,1));
    end
    x{i}=px{i}(find(px{i}>=End,1):end)-End+Start+Gap;
    y{i}=py{i}(find(px{i}>=End,1):end);
    
    if isempty(x{i})
        xend = x{i};
        yend = y{i};
    else
        xend = x{i}(1);
        yend = y{i}(1);
    end
    
    if isempty(x{i})
        xstart = p(i).XData;
        ystart = p(i).YData;
    else
        xstart = p(i).XData(end);
        ystart = p(i).YData(end);
    end
    
    if length(x{i}) == 1
        pl(i,:)=plot(x{i},y{i}, [xend], [yend], 'Color',kolor{i});
        pl(i,2).LineStyle=':';
    else
        pl(i,:)=plot(x{i},y{i},[xstart xend],[ystart yend],'Color',kolor{i});
    end
        
    pl(i,1).Marker=p(i).Marker;pl(i,1).MarkerSize=p(i).MarkerSize;pl(i,1).LineWidth=p(i).LineWidth;
end
hold off;
xta=xt(1:find(xt>=Start));
xta(end)=Start;
xtb=xt(find(xt>End):end);
xtb=[End xtb];
xtL=[xta xtb];
xt2=[xta xtb-End+Start+Gap];
axes_handle.XTick=xt2;
axes_handle.XTickLabel=xtL;
axes_handle.XLim=[xl(1) xl(2)-End+Start+Gap];
end