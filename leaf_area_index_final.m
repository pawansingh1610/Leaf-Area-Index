clear all;
clc;
format long
%reading the point cloud data and saving it in a variable x,y,z
[x,y,z]=textread('tree.txt','%f %f %f');
%n is number of voxelization it depend upon the memory of the system it can
n=input('Enter the number of voxelization, more voxelization better result (suggested 100 or more depend on system)>>>>');
lenx=length(x);%number of x-cordinate which is also equal to total number of points 
scatter3(x,y,z) %plotting point cloud data in scatter plot
%% as name suggest minimum and maximum of each point cloud data
xmin=min(x);
ymin=min(y);
xmax=max(x);
ymax=max(y);
zmin=min(z);
zmax=max(z);
hold on;
P1=[xmin,ymin,zmin];
P2=[xmax,ymin,zmin];
P3=[xmax,ymin,zmax];
P4=[xmin,ymin,zmax];
P5=[xmin,ymax,zmin];
P6=[xmax,ymax,zmin];
P7=[xmax,ymax,zmax];
P8=[xmin,ymax,zmax];
P=[P1;P2;P3;P4;P1;P5;P6;P2;P6;P7;P3;P7;P8;P4;P8;P5];
plot3(P(:,1),P(:,2),P(:,3));
%% creating voxelization of tree cube
xvoxgap=(xmax-xmin)/n;%length of small cube or gap between 2 points
yvoxgap=(ymax-ymin)/n;
zvoxgap=(zmax-zmin)/n;

xyz=[x y z];
xvoxcord=xmin:xvoxgap:xmax; %x coordinate of small cube
yvoxcord=ymin:yvoxgap:ymax; %y coordinate of small cube
zvoxcord=zmin:zvoxgap:zmax; %z coordinate of small cube

%% Giving coordinates to every voxalized corner (replicating)
[xvoxcord,yvoxcord,zvoxcord]=ndgrid(xvoxcord,yvoxcord,zvoxcord);
xyzcube=[xvoxcord(:),yvoxcord(:),zvoxcord(:)];
treebox=[];
%plot3(xyzcube(:,1),xyzcube(:,2),xyzcube(:,3));
% sorting on basis of z axis
xyz=sortrows(xyz,3);
xyzcube=sortrows(xyzcube,3);
%% checking every PC w.r.t. every cube corner and voxgap
for i=1:n*n*n %to cover all points of  xyzcube
    for j=1:lenx
               if(xyzcube(i,3)<=xyz(j,3))&&(xyz(j,3)<xyzcube(i+(n+1)^2,3))
                   if(xyzcube(i,2)<=xyz(j,2))&&(xyz(j,2)<xyzcube(i+n+1,2))  
                       if((xyzcube(i,1)<=xyz(j,1))&&(xyz(j,1)<xyzcube(i+1,1)))
                            condtr=[xyzcube(i,1),xyzcube(i,2),xyzcube(i,3);xyzcube(i+1,1),xyzcube(i+n,2),xyzcube(i+(n+1)^2,3)];
                            treebox=vertcat(treebox,condtr);
                end
            end
        end
    end
end

%plot3(treebox(:,1),treebox(:,2),treebox(:,3));
hold on
%scatter3(xyz(:,1),xyz(:,2),xyz(:,3));
treeboxcorrect=[];
% removing 1 top(digonal) corner from the treebox
for i=1:2:length(treebox)
    treeboxcorrect=vertcat(treeboxcorrect,treebox(i,:)); 
end
[treeboxcorrectr,ia,ic] =unique(treeboxcorrect(:,1:3),'rows');
a_counts = accumarray(ic,1);
value_counts = [treeboxcorrectr, a_counts];
disp('Number of cube containing whole tree')
lentree=length(treeboxcorrectr)
treeboxcorrectr=sortrows(treeboxcorrectr,3);
presentz=[];
count=0;
pastz=[];
i=1;
numofpoints=[];
%% counting number of cubes per z
while(i<lentree)
    presentz=treeboxcorrectr(i,3);
    if(i==1) %|| (i==lengthtreebox)
        pastz=presentz;
       
    end
    if(pastz==presentz)
        count=count+1;
        i=i+1;
        pastz=presentz;
    else
        numofpoints=vertcat(numofpoints,count);
        i=i+1;
        pastz=presentz;
        count=1;
       
    end
   
end
treelength=length(numofpoints);
tree_crown=[];
%% finding crown by countion number of cubes
for i=1:treelength
    if(numofpoints(i)>35)
        tree_crown=numofpoints(i:end);
        break
    end
end
disp('Total number of cube containg crown of tree')
sum(tree_crown)

max_point=max(tree_crown);
number_of_leaf=sum(tree_crown);
leaf_area=number_of_leaf*xvoxgap*yvoxgap;
%% for the shadow of tree using 2 semicircle technique
area_of_semicir_1=(pi*(abs(xyz(1,1)-xmax))^2)/2;
area_of_semicir_2=(pi*(abs(xyz(1,1)-xmin))^2)/2;
shadow_of_tree=area_of_semicir_1+area_of_semicir_2;

%% LEAF AREA INDEX
leaf_area_index=leaf_area/shadow_of_tree




    




    
    
    