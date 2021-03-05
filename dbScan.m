clc; close all; clear all;
%reading frames 
myPath='C:\Users\HP\Desktop\research intern\depthframe\background_subtracted_depthframe\';
a=dir(fullfile(myPath,'*.jpg'));
fileNames = arrayfun( @(x) fullfile( myPath, x.name ), a, 'UniformOutput', false );
id=1;

for frame_no=36:1661
    frame_no
    %reading background subtracted image
    bsi = imread( fileNames{frame_no});
    
    %binarizing the image
    Image =imbinarize(bsi);
    
    %generating name for corresponding depthframe
    x = numel(num2str(frame_no));
    if x == 1
        astr=strcat('000',num2str(frame_no));
    elseif x == 2
        astr = strcat('00',num2str(frame_no));
    elseif x == 3
        astr = strcat('0',num2str(frame_no));
    else
        astr = num2str(frame_no);  
    end
    
    %loading corresponding depth frame
    M = load(strcat('C:\Users\HP\Desktop\research intern\depthframe\depthframe\DepthFrame',astr,'.mat'));
    depth_frame = M.(strcat(strcat('Dep',astr),'_'));
    depth_frame=flip(depth_frame,2);
    depth_frame=imrotate(depth_frame,90);
    
    %making a list of all required pixels from background subtracted image
    pix=[];
    [L,n] = bwlabel(Image);
    s= regionprops(L, 'all');
    for v=1:n
        pix=[pix;s(v).PixelList];
    end
    
    %adding depth coordinate to the pixels
    xyz=[];
    size_pixels=size(pix);
    for v=1:size_pixels(1)
        d=depth_frame(fix(pix(v,2)),fix(pix(v,1)));
        %taking only non-zero depth pixels
        if d~=0
            xyz=[xyz; [pix(v,1), pix(v,2), d] ];
        end
    end
    
    data=double(xyz);
    data=normalize(data,'range');
    sizedata=size(data);
    data=double(data);
    
    %Applying DB SCAN clustering
    min_pts=5;
    epsilon=8;
    cluster=0;
    details=[];
    idx=dbscan(data, epsilon, min_pts);
    for i=1:sizedata(1)
        if idx(i)>cluster
            cluster=idx(i);
        end
    end
 
    
    id_track=zeros(1,1000);
    %looping through all the clusters
    for i=1:cluster
       
        %creating an image of same size and marking all pixels as black
        theImage=zeros(414,512);

        %checking membership of all the pixels with the ith cluster
        for j=1:sizedata(1)
            if idx(j)==i
                theImage(xyz(j,2),xyz(j,1))=1; 
            end
        end
        %imshow(theImage)
        %finding all the objects from the image created
        [L1,n1]=bwlabel(theImage);  
        s1=regionprops(L1,'all');
        
        %Now looping through all the objects of this cluster
        for j=1:n1
            index=-1;
            f_dist_xyz=Inf;
            %Checking if the object detected is a noise
            if(s1(j).Area<100)
                continue;
            end
           
            if index==-1
                id_match=-1;
                %read all the alrerady detected ojects
                path='C:\Users\HP\Desktop\research intern\output2\objects';
                a1=dir(fullfile(path,'*.txt'));
                saved_obs = arrayfun( @(x) fullfile( path, x.name ), a1, 'UniformOutput', false );
                size_saved_obs=size(saved_obs);
                f_dist_xy1=Inf;

                for k=1:size_saved_obs(1)
                    recs=load(saved_obs{k});
                    size_recs=size(recs);
                    last_rec=recs(size_recs(1),:);
                    dist_z= pdist2((double(depth_frame(fix(s1(j).Centroid(2)),fix(s1(j).Centroid(1))))),last_rec(3)); 

                    dist_xy=pdist2([s1(j).Centroid(1) s1(j).Centroid(2)], [last_rec(1) last_rec(2)],'euclidean'); 

                    dist_xyz=pdist2([s1(j).Centroid(1) s1(j).Centroid(2) double(depth_frame(fix(s1(j).Centroid(2)),fix(s1(j).Centroid(1))))], [last_rec(1) last_rec(2) last_rec(3)],'euclidean'); 

                    if dist_xy<=12 && id_track(k)==0 && dist_z<350
                        if dist_xy<f_dist_xy1
                            f_dist_xy1=dist_xy;
                            id_match=k;
                        end
                    end
                end
                
                if id_match~=-1
                    new_object=[id_match s1(j).Centroid(1) s1(j).Centroid(2) double(depth_frame(fix(s1(j).Centroid(2)),fix(s1(j).Centroid(1)))) s1(j).Area s1(j).BoundingBox(1) s1(j).BoundingBox(2) s1(j).BoundingBox(3) s1(j).BoundingBox(4)];
                    details=[details; new_object];
                    id_track(id_match)=1;
                elseif id<=7
                    new_object=[id s1(j).Centroid(1) s1(j).Centroid(2) double(depth_frame(fix(s1(j).Centroid(2)),fix(s1(j).Centroid(1)))) s1(j).Area s1(j).BoundingBox(1) s1(j).BoundingBox(2) s1(j).BoundingBox(3) s1(j).BoundingBox(4)];
                    details=[details; new_object];
                    id=id+1;  
                end       
            end
        end % end of object loop inside cluster
    end % end of cluster loop

    size_details= size(details);       


    %storing the final Centroid to each objects file
    for i=1:size_details(1)
        %storing object deatils in object files
        h=sprintf("C:\\Users\\HP\\Desktop\\research intern\\output2\\objects\\object%d.txt",details(i,1));
        fid = fopen(h,'a+');
        fprintf(fid,'%f,%f,%f,%d\r\n',details(i,2),details(i,3),details(i,4),frame_no); 
        fclose(fid);
        
        %storing the bounding box of all objects in a common file
        h1="C:\Users\HP\Desktop\research intern\output2\result_detailed.txt";
        fid = fopen(h1,'a+');
        fprintf(fid,'Frame: %d, Id: %d, Boundary Box: %f, %f, %f, %f\r\n',frame_no,details(i,1),details(i,6),details(i,7),details(i,8),details(i,9));
        fclose(fid);
        bsi = insertShape(bsi,'rectangle',[details(i,6),details(i,7),details(i,8),details(i,9)],'LineWidth',1,'Color','red');
        bsi=insertText(bsi,[details(i,6),details(i,7)],details(i,1),'FontSize',12,'BoxOpacity',0,'TextColor','green','AnchorPoint','LeftBottom');
    end
        
    bsi=insertText(bsi,[30,30],"Frame: "+int2str(frame_no),'FontSize',14,'BoxOpacity',0,'TextColor','yellow');
    bsi=insertText(bsi,[30,53],"Total Fishes: "+int2str(size_details(1)),'FontSize',14,'BoxOpacity',0,'TextColor','yellow');

    fName= fullfile("C:\Users\HP\Desktop\research intern\output2\images\", sprintf('%06d.jpg', frame_no));
    imwrite(bsi,fName);
    
    %store the number of objects detected in the frame in the file
    h2="C:\Users\HP\Desktop\research intern\output2\result.txt"; 
    fid = fopen(h2,'a+');
    fprintf(fid,"Frame: %d  Number of fishes: %d\n",frame_no,size_details(1)); 
    fclose(fid);%file closes
end

