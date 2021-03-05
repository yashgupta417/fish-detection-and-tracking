clc; close all; clear all;
%read all the alrerady detected ojects
x=input("0:FCM 1:k-Means 2:DBSCAN\n Algorithm Number:");
if x==0
   path="C:\\Users\\HP\\Desktop\\research intern\\output\\objects";
   fName="C:\\Users\\HP\\Desktop\\research intern\\output\\trajectory.jpg";
else
    path=sprintf("C:\\Users\\HP\\Desktop\\research intern\\output%d\\objects",x);
    fName=sprintf("C:\\Users\\HP\\Desktop\\research intern\\output%d\\trajectory.jpg",x);
end

a1=dir(fullfile(path,'*.txt'));
saved_obs = arrayfun( @(x) fullfile( path, x.name ), a1, 'UniformOutput', false );
size_saved_obs=size(saved_obs);

img=ones(424,512);
colours={'yellow'  'blue' 'green' 'black' 'red' 'cyan'  'magenta'};

for i=1:size_saved_obs(1)
    recs=load(saved_obs{i});
    size_recs=size(recs);
    %x=sprintf('C:\\Users\\HP\\Desktop\\research intern\\output\\trajectory\\object%d.avi',i);
    %writerObj = VideoWriter(x);
    %writerObj.FrameRate = 1;
    %open(writerObj);
    for j=2:size_recs(1)
        img=insertShape(img,'Line',[recs(j,1) recs(j,2) recs(j-1,1) recs(j-1,2)],'LineWidth',1,'Color',colours(i));
        %frame = im2frame(img);
        %writeVideo(writerObj, frame);
    end 
    %close(writerObj);
end
img=insertShape(img,'Rectangle',[90 135 375 150],'LineWidth',2,'Color','black');
imwrite(img,fName);
