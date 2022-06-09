function plotting_oscillation_2021_02_24_v3(do_shading)
close all;
to_do={'\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\',...
    '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-19\'...
    '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-26\'};

if ~exist('Figures');
    mkdir('Figures');
end

do_now={'0uM','2uM','3uM','4uM','5uM','6uM','7uM','8uM','9uM'};
name={'0 uM IPTG','2 uM IPTG','3uM IPTG','4uM IPTG','5 uM IPTG','6 uM IPTG','7 uM IPTG','8 uM IPTG','9 uM IPTG'};
ylim_data=[4000,4000,4000,4000,4000,4000,5000,5000,5000];
c_color={'b','r','g'};
% load('G:\2021-11-10\subAuto\Data\JLB254_50uM_IPTG.mat');
p={};
for j=1:length(to_do)
     for kk=1:length(do_now);
%      for kk=5:6
        D=dir([to_do{j},'subAuto\Data\*',do_now{kk},'*.mat']);

        if ~isempty(D)
            load([to_do{j},'subAuto\Data\',D(1).name]);
            MY(MY==0)=nan;
            cand=~isnan(MY(721,:));
            MY=MY(1:721,cand);
            MY_all{kk}(:,j)=nanmean(MY,2);
            pos_to_plot=randperm(size(MY,2));
            n_penals=5;
            
            if j==1 || isempty(p{kk})
                f = figure(kk);
                set(gcf, 'Units', 'centimeters','PaperUnits', 'centimeters', 'PaperPosition',[0 0 25 19],'PaperSize', [19, 25], 'PaperType','A4',...
                'Position',[15,3,25,19],'PaperOrientation','landscape');
                p{kk} = uipanel('Parent',f,'BorderType','none'); 
                p{kk}.Title = [name{kk} ,' ',to_do{j}(end-10:end-1)]; 
                p{kk}.TitlePosition = 'centertop'; 
                p{kk}.FontSize = 12;
                p{kk}.FontWeight = 'bold';

            else
                f = figure(kk);
            end
            
            for i=1:n_penals^2
                subplot(n_penals,n_penals,i,'parent',p{kk});
                try hold on;plot(smoothdata(MY(:,pos_to_plot(i)),'gaussian',5),c_color{j});
                end
                a=axis;
                axis([0 721 0 ylim_data(kk)]);
                if mod(i,n_penals)==1;
                    ylabel('MY (au)');
                end
                if i>n_penals^2-n_penals;
                    xlabel('Frames');
                end  
                if j==length(to_do)&&do_shading==1;
                    hold on;
                    shadedErrorBar(1:721,nanmean(MY_all{kk},2)',nanstd(MY_all{kk}'),'--k',1);
                end
            end
            
            if j==length(to_do)&&do_shading==1;
                %saving 
                saveas(gcf,[cd,'\Figures\',do_now{kk},'_shaded_mean' ,'.png']);
            elseif j==length(to_do)&&do_shading==0;
                saveas(gcf,[cd,'\Figures\',do_now{kk},'.png']);
            end
        end
%     saveas(gcf,[to_do{j}(1:end-3),'pdf'])
    end
end