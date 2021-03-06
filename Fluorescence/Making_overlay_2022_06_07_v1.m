data_path={'\\slcu.cam.ac.uk\Data\Microscopy\TeamJL\Chris\movies\oscillations\alldata\2021-11-10\subAuto\',...
'\\slcu.cam.ac.uk\Data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-19\subAuto\',...
'\\slcu.cam.ac.uk\Data\Microscopy\TeamJL\Chris\movies\oscillations\2022-01-26\subAuto\'};

% for i=1:length(data_path);
for i=1
    D=dir([data_path{i},'*-p-001*']);
    names={D.name};
    f=strfind(D(1).name,'-');
    file_names=cellfun(@(a) a(1:f(2)-1),names,'UniformOutput',false);
     for j=1:length(file_names);
    %for j=50:55
    if i==4
        %p=initschnitz(file_names{j},'2022-03-23','bacillus','rootDir',data_path,'imageDir',data_path);
        im_t=mat2gray(double(imread([data_path{1}(1:end-8),'Bacillus1_w2RFP - Camera_s',num2str(j)','_t500.tif'])),[400,3000]);
        im_y=mat2gray(double(imread([data_path{1}(1:end-8),'Bacillus1_w3YFP - Camera_s',num2str(j)','_t500.tif'])),[250,4000]);
        im_p=mat2gray(double(imread([data_path{1}(1:end-8),'Bacillus1_w1Brightfield - Camera_s',num2str(j)','_t500.tif'])));
    else
        im_t=mat2gray(double(imread([data_path{i},file_names{j},'-t-500.tif'])),[400,3000]);
        im_y=mat2gray(double(imread([data_path{i},file_names{j},'-y-500.tif'])),[250,4000]);
        im_p=mat2gray(double(imread([data_path{i},file_names{j},'-p-500.tif'])));
    end
        imry=cat(3,im_t,im_y,zeros(size(im_t)));
        impr=cat(3,im_t+im_p,im_p,im_p);
        impy=cat(3,im_p,im_y+im_p,im_p);
        im_out=[imry;impr;impy];
%         im_out=zeros(size(im_t,1),size(im_t,2)*3,3);
%         im_out=
%         im(:,:,1)=imread([data_path{i},file_names{j},'-t-001.tif']);
%         im(:,:,2)=imread([data_path{i},file_names{j},'-y-001.tif']);
%         im(:,:,3)=zeros(size(im(:,:,1)));
%         figure;
        imshow(im_out);
%         subplot(3,1,1);
%         imshow(imry);
%         subplot(3,1,2);
%         imshow(impr);
%         subplot(3,1,3);
%         imshow(impy);

    
    
    if ~exist([data_path{i},'Data\Problems\']);
        mkdir([data_path{i},'Data\Problems\']);
    end
        %text(1000,100,file_names{j},'color','white');
        %im_out=insertext(im_out,1000,100,file_names{j},'color','white');
        im_out2=insertText(im_out,[1000,50],file_names{j},'Textcolor','white','FontSize',50,'BoxOpacity',0);imshow(im_out2);
        
%         pause(0.1);
        imwrite(im_out2,[data_path{i},'Data\Problems\',file_names{j},'.jpg']);
%         saveas(gcf,[data_path{i},'Data\Problems\',file_names{j},'.jpg']);
    end
end
        