function general_model_sigB_tuning_ana_2022_03_01_v1
%Default parameters
data_path={'\\slcu.cam.ac.uk\Data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\',...
'\\slcu.cam.ac.uk\Data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-19\subAuto\Data\',...
'\\slcu.cam.ac.uk\Data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-26\subAuto\Data\'};
iptg=[0,2,3,4,5,6,7,8,9];

data=general_model_classication_2022_03_01_v1(data_path);

%plotting individual classification of repeats
figure;

for i=1:size(data,3);
    subplot(2,2,i);
    do_now=data(:,:,i);
    iptg_now=iptg;
    f=find(isnan(do_now(1,:)));
    if ~isempty(f)
        do_now(:,f(1))=[];
        Model_data_only_2021_01_15
        iptg_now(f(1))=[];
    end
    plot(iptg_now,do_now);
    xlabel('IPTG [uM]');
    ylabel('Fraction [au]');
    box on;
    title(data_path{i}(66+1:76));
    legend({'Off','Pulsing','Oscillation','On'},'location','east');
end
legend({'Off','Pulsing','Oscillation','On'},'location','east');
%plotting mean of repeats
figure;
errorbar([iptg;iptg;iptg;iptg]',nanmean(data,3)',nanstd(data,0,3)');
xlabel('IPTG [uM]');
ylabel('Fraction [au]');
legend({'Off','Pulsing','Oscillation','On'},'location','east');
title('Mean of three repeats');
% figure;
% for i=1:size(data,1);
%     hold on;
%     shadedErrorBar(iptg,nanmean(data(i,:),3)',nanstd(data(i,:),0,3)',1);
% end
% xlabel('IPTG [uM]');
% ylabel('Fraction [au]');
% legend({'Off','Pulsing','Oscillation','On'});
% title('Mean of three repeats');




