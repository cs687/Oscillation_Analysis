function comparing_data_2022_02_24_v2

in_path={'\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\',...
    '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-19\subAuto\Data\', '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-26\subAuto\Data\'};

comp_cond={'0uM','2uM','3uM','4uM','5uM','6uM','7uM','8uM'};
plot_colours='rbk';

figure;
set(gcf, 'Units', 'centimeters','PaperUnits', 'centimeters', 'PaperPosition',[0 0 19 25],'PaperSize', [19, 25], 'PaperType','A4');
for i=1:length(comp_cond);
    subplot(4,2,i);
    for j=1:length(in_path)
        D=dir([in_path{j},'*',comp_cond{i},'*.mat']);
        if ~isempty(D)
            data=load([in_path{j},D(1).name]);
            MY=data.MY;
            MY(MY==0)=nan;
            hold on;
            plot(nanmean(MY,2),plot_colours(j));
        end
    end
    xlabel('Frame');
    ylabel('MY (au)');
    title([comp_cond{i},' IPTG']);
    box on;
    if i==1
        legend({'Mean Repeat 1','Mean Repeat 2','Mean Repeat 3'},'location','northwest');
    end
    
end
    