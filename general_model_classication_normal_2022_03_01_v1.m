function [class_cell,class_cell_num,period_all_freq,period_all_peak]=general_model_classication_normal_2022_03_01_v1(data_path,varargin);

% %out_path='\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\';
% to_do={'\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_0uM_IPTG.mat','\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_3uM_IPTG.mat','\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_4uM_IPTG.mat',...
%     '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_5uM_IPTG.mat','\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_6uM_IPTG.mat',...
%     '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_7uM_IPTG.mat','\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_8uM_IPTG.mat',...
%     '\\slcu.cam.ac.uk\data\Microscopy\TeamJL\Chris\movies\oscillations\2021-11-15\subAuto\Data\JLB254_9uM_IPTG.mat'};

%figure;
%for i=2:length(to_do);


%Default parameters
numlags=500;
numstd=3;
cond=1:8;
plot_now=2;
do_plot=0;
plot_color=1;
do_auto=0;
L=576;
calc_period=1;
% L=613;
%L=757;
lag=36;
name={'0 uM IPTG','2uM IPTG','3uM IPTG','4uM IPTG','5 uM IPTG','6 uM IPTG','7 uM IPTG','8 uM IPTG','9 uM IPTG'};
iptg=[0,2,3,4,5,6,7,8,9];
on_colors_all={'w','y','g','c'};
class_cell=zeros(4,length(iptg),length(data_path));
class_cell_num={};

period_all_freq=nan(300,length(iptg),length(data_path));
period_all_peak=nan(300,length(iptg),length(data_path));

for i=1:2:length(varargin)
    if strcmp(varargin{i},'numlag')
        numlags=varargin{i+1};
    elseif strcmp(varargin{i},'numstd')
        numstd=varargin{i+1};
    elseif strcmp(varargin{i},'cond')
        cond=varargin{i+1};
        iptg=iptg(cond);
    elseif strcmp(varargin{i},'plot_now')
        plot_now=varargin{i+1};
    elseif strcmp(varargin{i},'plot_do')
        do_plot=varargin{i+1};
    elseif strcmp(varargin{i},'plot_color')
        plot_color=varargin{i+1};
    elseif strcmp(varargin{i},'lag')
        lag=varargin{i+1};
    elseif strcmp(varargin{i},'last_frame')
        L=varargin{i+1};
    elseif strcmp(varargin{i},'do_auto')
        do_auto=varargin{i+1};
    end
end

for tt=1:length(data_path)
    kk=0;
    for i=1:length(iptg)
        kk=kk+1;
        ii=1;
        %load data
        %figure;
        D=dir([data_path{tt},'*',num2str(iptg(i)),'uM*.mat']);
        if ~isempty(D)
            load([data_path{tt},D(1).name]);
            %Filtering out traces which make it to the last frarme L
            MY(MY==0)=nan;
            good_cand=~isnan(MY(L,:));
            MY_long=MY(1:L,good_cand);
            
            %plotting single cell traces and their classification
            if do_plot==1
                figure;
                if size(MY_long,2)<25
                    do_now=size(MY_long,2);
                else
                    do_now=25;
                end
            else
                do_now=size(MY_long,2);
                norm=do_now;
            end
            
            %Looping of good single cell traces and classifing them 
            for trace=1:do_now
                if do_plot==1
                    subplot(5,5,trace);
                end
                %smoothing raw data and find peaks
                data=smoothdata(MY_long(lag:L,trace)-200,'gaussian',10);
                [m,loc,~,p]=findpeaks(data,'MinPeakProminence',200,'Annotate','extents');
                
                %calculating periogram
                if do_auto==1
                    [af,bounds]=autocorr(data-mean(data),500);
                    [m_af,loc_af]=findpeaks(af,'MinPeakHeight',bounds(1));
                else
                    af=data-mean(data);
                end
                [pd,freq]=pwelch(af,[],[],[],1/10);
                
                if do_auto==1
                    [m2,loc2]=findpeaks(pd,'MinPeakProminence',2);
                else
                    [m2,loc2]=findpeaks(pd,'MinPeakProminence',10^6);
                end
                
                
%                 %calculating autocorrelation
%                 [af,~,bounds]=autocorr(data-mean(data),'Numlags',numlags,'NumSTD',numstd);
%         %         [loc_af,m_af]=peakfinder_2016(af);
%                 [m_af,loc_af]=findpeaks(af,'MinPeakHeight',bounds(1));
                %Caldulating periogram
%                 af=data;
%                 [pd,freq]=pwelch(af-mean(af),[],[],[],1/10);
%                 [m2,loc2]=findpeaks(pd,'MinPeakProminence',1);
                if sum((m-p)>1500)~=0% on case: magenta
                    color_now=on_colors_all{4};
                    class_cell(4,kk,tt)=class_cell(4,kk,tt)+1;
                %elseif freq(loc2(1))>1/(5000/8); %oscillation case: green
                elseif sum(loc2>1)>0 && sum(freq(loc2)>10^-3)>0
                    color_now=on_colors_all{3};
                    class_cell(3,kk,tt)=class_cell(3,kk,tt)+1;
                    if calc_period==1
                        freq_pre_pre=freq(loc2);
                        freq_good_ind=freq_pre_pre>10^-3;
                        m2_pre=m2(freq_good_ind);
                        freq_pre=freq_pre_pre(freq_good_ind);
                        [~,ind_freq]=sort(m2_pre,'descend');
                        period_all_freq(ii,kk,tt)=freq_pre(ind_freq)^-1;
                        period_all_peak(ii,kk,tt)=nanmean((loc2(2:end)-loc2(1:end-1)));
                        ii=ii+1;
                    end   
                elseif length(loc)==0; %off case:  white
                    color_now=on_colors_all{1};
                    class_cell(1,kk,tt)=class_cell(1,kk,tt)+1;
                else
                    color_now=on_colors_all{2}; %pulsing case: yellow
                    class_cell(2,kk,tt)=class_cell(2,kk,tt)+1;
                end
                %Plotting singel cell traces
                
                if do_plot==1
                    if plot_now==1
                        findpeaks(data,'MinPeakProminence',200,'Annotate','extents');
                        yline(1500);
                        legend off;
                    elseif plot_now==2
                        %autocorr(data,'Numlags',numlags,'NumSTD',numstd);
                        plot(af);
                        hold on;
                        plot(loc_af,m_af,'rx');
                        yline(bounds(1));
                    else
                        plot(freq,pd);
                        xline(10^-3);
                        hold on;
                        plot(freq(loc2),m2,'rx');
                        %findpeaks(pd,'Annotate','extents');
                        set(gca,'Xscale','log');
                        a=axis;
                        %axis([0 a(2) 0 20]);
                        legend off
                    end
                    if plot_color==1;
                       set(gca,'color',color_now);
                    end
                end
            end
            %defining out put
            if do_plot==1
                title(name{i});
            else
                class_cell_num{tt}(:,kk)=class_cell(:,kk,tt);
                class_cell(:,kk,tt)=class_cell(:,kk,tt)/norm;
            end
        else
            class_cell(:,kk,tt)=nan(1,4);
        end
    end
end
% figure;
% plot(mean(class_cell,3));