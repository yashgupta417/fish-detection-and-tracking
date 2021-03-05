clc; close all; clear all;

x=input("0:FCM 1:k-Means 2:DBSCAN\n Algorithm Number:");
if x==0
   myPath="C:\\Users\\HP\\Desktop\\research intern\\output\\images";
   fName="C:\\Users\\HP\\Desktop\\research intern\\output\\myVideo.avi";
else
    myPath=sprintf("C:\\Users\\HP\\Desktop\\research intern\\output%d\\images",x);
    fName=sprintf("C:\\Users\\HP\\Desktop\\research intern\\output%d\\myVideo.avi",x);
end

a=dir(fullfile(myPath,'*.jpg'));
fileNames = arrayfun( @(x) fullfile( myPath, x.name ), a, 'UniformOutput', false );


writerObj = VideoWriter(fName);
writerObj.FrameRate = 10;
open(writerObj);

for frame_no=1:size(fileNames)
    im=imread( fileNames{frame_no});
    frame = im2frame(im);
    writeVideo(writerObj, frame);
end
 % close the writer object
 close(writerObj);
