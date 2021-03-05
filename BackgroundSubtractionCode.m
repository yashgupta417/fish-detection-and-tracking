clc;close all;clear;

Folder = 'C:\Users\HP\Desktop\research intern\depthframe\background_subtracted_depthframe';
m0 = load('C:\Users\HP\Desktop\research intern\depthframe\depthframe\DepthFrame0000.mat');
a = m0.Dep0000_;
a=flip(a,2);
a=imrotate(a,90);

%ts1=1285; ts2=1330;
ts=5;
for l=1:1661
    disp(l);
    x = numel(num2str(l));
    if x == 1
       astr=strcat('000',num2str(l));
    elseif x ==2
       astr = strcat('00',num2str(l));
    elseif x == 3
       astr = strcat('0',num2str(l));
    else
       astr = num2str(l);
    end
    
    M = load(strcat('C:\Users\HP\Desktop\research intern\depthframe\depthframe\Depthframe',astr,'.mat'));
    b = M.(strcat(strcat('Dep',astr),'_'));
    
    b=flip(b,2);
    b=imrotate(b,90);
    
%     for I=1:424
%         for J=1:512
%             if b(I,J)>1200 && b(I,J)<1300
%                 e(I,J)=1;
%             end
%         end
%     end
    %imshow(e);
    
    for I=1:424
        for J=1:512
            if(abs(a(I,J) - b(I,J)) > 6)
                c(I,J) = b(I,J);
            else
                c(I,J) = 0;
            end
        end
    end
    
    %imshow(c);    
%     fName= fullfile('C:\Users\HP\Desktop\research intern\BSC_threshold', sprintf('%06d.jpg', ts));
%     imwrite(c,fName);
%     break;

%     finding region of interest
    for i=1:size(b,1)
        for j=1:size(b,2)
            if( j>90 && j<465 && i>135) % && b(i,j)>=ts1 && b(i,j)<=ts2)
                c(i,j) = c(i,j);
            else
                c(i,j) = 0;
            end
        end
    end
    %imshow(c);

    %%%Dynamically finding region of interest
%     cnt_last=0; i1=1; i2=size(c,1); j1=1; j2=size(c,2);
%     for i=1:size(c,1)
%         cnt=0;
%         for j=1:size(c,2)
%             if c(i,j)>0
%                 cnt=cnt+1;
%             end
%         end
%         if i~=1 && cnt-cnt_last>20
%             i1=i;
%             break;
%         end
%         cnt_last=cnt;
%     end
%     
%     cnt_last=0;
%     for i=size(c,1):-1:1
%         cnt=0;
%         for j=1:size(c,2)
%             if c(i,j)>0
%                 cnt=cnt+1;
%             end
%         end
%         if i~=size(c,1) && cnt-cnt_last>20
%             i2=i;
%             break;
%         end
%         cnt_last=cnt;
%     end
%     
%     cnt_last=0;
%     for j=1:size(c,2)
%         cnt=0;
%         for i=1:size(c,1)
%             if c(i,j)>0
%                 cnt=cnt+1;
%             end
%         end
%         if j~=1 && cnt-cnt_last>20
%             j1=j;
%             break;
%         end
%         cnt_last=cnt;
%     end
%     
%     cnt_last=0;
%     for j=size(c,2):-1:1
%         cnt=0;
%         for i=1:size(c,1)
%             if c(i,j)>0
%                 cnt=cnt+1;
%             end
%         end
%         if j~=size(c,2) && cnt-cnt_last>20
%             j2=j;
%             break;
%         end
%         cnt_last=cnt;
%     end
%     i1; 
%     i2; 
%     j1;
%     j2;
%     for i=1:i1
%         for j=1:size(c,2)
%             c(i,j)=0;
%         end
%     end
%     
%     for i=size(c,1):-1:i2
%         for j=1:size(c,2)
%             c(i,j)=0;
%         end
%     end
%     
%     for j=1:j1
%         for i=1:size(c,1)
%             c(i,j)=0;
%         end
%     end
%     
%     for j=size(c,2):-1:j2
%         for i=1:size(c,1)
%             c(i,j)=0;
%         end
%     end
    
    %imshow(c);
    FilteredMat=medfilt2(c,[5 5]);
    [L num]=bwlabel(FilteredMat);

    STATS=regionprops(L,'all');

    %Remove the noisy regions
    for i=1:num
        dd=STATS(i).Area;
        if (dd < 200)
            L(L==i)=0;
        end
    end
    for row=1:size(L,1)
        for col=1:size(L,2)
            if L(row,col)>0
                c(row,col)=255;
            else
                c(row,col)=0;
            end
        end
    end
    %imshow(c);
    fName= fullfile(Folder, sprintf('%06d.jpg', l));
    imwrite(c,fName);
end
disp("Done")