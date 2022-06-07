function comparing_data_rfp2022_02_24_v2

in_path={'\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\',...
    '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-19\subAuto\Data\', '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-26\subAuto\Data\'};

comp_cond={'0uM','2uM','3uM','4uM','5uM','6uM','7uM','8uM'};
plot_colours='rbk';
L=576;

% figure;
% set(gcf, 'Units', 'centimeters','PaperUnits', 'centimeters', 'PaperPosition',[0 0 19 25],'PaperSize', [19, 25], 'PaperType','A4');
for i=1:length(comp_cond);
    %subplot(4,2,i);
    MY_mean=nan(1200,3);
    %for j=1:length(in_path)
    for j=3
        D=dir([in_path{j},'*',comp_cond{i},'*.mat']);
        if ~isempty(D)
            data=load([in_path{j},D(1).name]);
            MF=data.MR;
            MF(MF==0)=nan;
            good_cand=~isnan(MF(L,:));
            MF_long=MF(1:L,good_cand);
            figure;
            if nansum(~isnan(MF_long(L,:)))>=25
                do_now=25;
            else
                do_now=nansum(~isnan(MF_long(L,:)));
            end
            
            for kk=1:do_now
                subplot(5,5,kk);
                plot(MF_long(:,kk));
            end
            title(comp_cond{i});
%                 
%             MY(MY==0)=nan;
%             hold on;
%             plot(nanmean(MY,2),plot_colours(j));
%             MY_mean(1:length(nanmean(MY,2)),j)=nanmean(MY,2);
        end
    end
    MY_mean_all(:,i)=nanmean(MY_mean,2);
    xlabel('Frame');
    ylabel('MY (au)');
    title([comp_cond{i},' IPTG']);
    box on;
    if i==1
        legend({'Mean Repeat 1','Mean Repeat 2','Mean Repeat 3'},'location','northwest');
    end
    
end
figure;
plot(MY_mean_all);
colororder(jet(8));
xlabel('Frame');
ylabel('MR (au)');
title('RFP');
 legend(comp_cond,'location','north','NumColumns',4);