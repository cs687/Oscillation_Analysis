to_do={'\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_3uM_IPTG.mat','\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_4uM_IPTG.mat',...
    '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_5uM_IPTG.mat','\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_6uM_IPTG.mat',...
    '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_7uM_IPTG.mat','\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_8uM_IPTG.mat',...
    '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_0uM_IPTG.mat','\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_9uM_IPTG.mat'};
name={'3uM IPTG','4uM IPTG','6 uM IPTG','5 uM IPTG','7 uM IPTG','8 uM IPTG','0 uM IPTG','9 uM IPTG'};
ylim_data=[4000,4000,4000,4000,5000,5000,4000,5000];
% load('G:\2021-11-10\subAuto\Data\JLB254_50uM_IPTG.mat');
for j=1:length(to_do)
    load(to_do{j});
    MY(MY==0)=nan;
    cand=~isnan(MY(721,:));
    MY=MY(1:721,cand);
    pos_to_plot=randperm(size(MY,2));
    n_penals=5;
    
    f = figure;
    set(gcf, 'Units', 'centimeters','PaperUnits', 'centimeters', 'PaperPosition',[0 0 25 19],'PaperSize', [19, 25], 'PaperType','A4',...
    'Position',[15,3,25,19],'PaperOrientation','landscape');
    p = uipanel('Parent',f,'BorderType','none'); 
    p.Title = name{j}; 
    p.TitlePosition = 'centertop'; 
    p.FontSize = 12;
    p.FontWeight = 'bold';
%     figure;

    for i=1:n_penals^2
        subplot(n_penals,n_penals,i,'Parent',p);
        try plot(smoothdata(MY(:,pos_to_plot(i)),'gaussian',5));
        end
        a=axis;
        axis([0 721 0 ylim_data(j)]);
        if mod(i,n_penals)==1;
            ylabel('MY (au)');
        end
        if i>n_penals^2-n_penals;
            xlabel('Frames');
        end
    end
    saveas(gcf,[to_do{j}(1:end-3),'png']);
%     saveas(gcf,[to_do{j}(1:end-3),'pdf'])
end