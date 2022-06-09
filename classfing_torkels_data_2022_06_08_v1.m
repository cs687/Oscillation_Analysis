function classfing_torkels_data_2022_06_08_v1
%Function to classify the model data

%Loading data in 
load(['C:\Users\christian.schwall\OneDrive - University Of Cambridge\Matlab\Ocillation Analysis\Data\all_sim']);

%samled IPTG concentrations
to_do=[0.0:0.1:10];
%Defining variables
kk=1;
pre=zeros(4,size(out,3));
%Loop over all conditions
for i=1:1:length(to_do);
    data=out(:,:,i);
    for j=1:size(data,1);
        [m_data,~]=findpeaks(data(j,:),'MinPeakProminence',0.5);
        [pd]=pwelch(data(j,:)-mean(data(j,:)));
        [m_pd,~]=findpeaks(pd);
        %classifying data
        if (sum(data(j,:)>0.5)>size(out,2)*0.75) %defining on cells
            pre(4,i)=pre(4,i)+1;
        elseif sum(m_pd>=1)>0 %defining ocillations 
            pre(3,i)=pre(3,i)+1;
        elseif isempty(m_data) % Off cells
            pre(1,i)=pre(1,i)+1;
        else % pulsing cells
            pre(2,i)=pre(2,i)+1;
        end
    end
    pre(:,i)=pre(:,i)/size(data,1);
%     plot(smoothdata(data(10,:),'gaussian',5));
%     title(['sim S ',num2str(to_do(i),'%0.1f')]);

end

%Plotting data
figure;
plot(to_do,pre','-x');
xlabel('Stress (au)');
ylabel('Fraction');
legend({'OFF','Pulsing','Oscillation','ON'},'location','east');

