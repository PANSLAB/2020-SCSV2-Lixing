%Load data
%load('Experiments/data.mat');


%parameter setup
person=5;
t0 = data(person).t(1);
sensorPos = [[0.455, 2.900]; [0.455, 5.335]; [0.455, 6.550]; [0.455, 8.675]];

left=data(person).l;
right=data(person).r;
vision=(left+right)/2;
xt=linspace(0,max(vision(:,2)),201);
stepx=max(vision(:,2))/200;
t=data(person).t;
vib=data(person).vAligned;

% Detect and divide the data into parts, one part come to 14 from 0
points=[];
temp=vision(:,2);
while 1
[m1,argmin]=min(temp);
temp(max(1,argmin-80):min(argmin+80,length(temp)))=0;
% 
% [m2,argmax]=max(temp);
% temp(max(1,argmax-80):min(argmax+80,length(temp)))=0;
points=[points,argmin];
if m1>=-10
    break
end
end
points=sort(points);
points=[points,length(temp)];
part=length(points)-1;
points2=floor(points*length(vib)/length(vision));

%uniformly divide the data into 11 parts, and only use the first five.
part=11;
used=11;

location=zeros(size(vib,2),used);
baseline=zeros(size(vib,2),used);
beamsrecord=zeros(4,2,used);
vib(isnan(vib))=0;
for i=1:used
% %uniformly divide
% vibnow=vib(floor((i-1)*length(vib)/part)+1:floor(i*length(vib)/part),:);
% visionnow=vision(floor((i-1)*length(vision)/part)+1:floor(i*length(vision)/part),:);
% tnow=t(floor((i-1)*length(t)/part)+1:floor(i*length(t)/part));

%divide based on extraction
% vibnow=vib(points2(i):points2(i+1),:);
% visionnow=vision(points(i):points(i+1),:);

%convert to 2-d profile: footstep location vs signal energy
denseline=zeros(201,4);
for s=1:4
peaknum=length(data(person).steps(s).stepPeakIdx);
peakindex=data(person).steps(s).stepPeakIdx(((i-1)*peaknum/part)+1:floor(i*peaknum/part));
peakvalue=data(person).steps(s).stepPeakVal(((i-1)*peaknum/part)+1:floor(i*peaknum/part));
visionindex=ceil(peakindex/length(vib)*length(vision));
visionvalue=vision(visionindex,2);
remain=visionvalue>0;
visionvalue=visionvalue(remain);
peakvalue=peakvalue(remain);
denseline(:,s)=interp1(visionvalue,peakvalue,xt);
denseline(isnan(denseline(:,s)),s)=0;
end
loc=xt;

%another way
%convert to 1-d curve and also record average and max(baseline)
% denseline=zeros(size(vibnow));
% for j=1:4
% vv=[visionnow(:,2),vibnow(:,j)];
% sortvv=(sortrows(vv));
% denseline(:,j)=sortvv(:,2);
% end
% loc=sortvv(:,1);
% remain=loc>0;
% loc=loc(remain);
% denseline=denseline(remain,:);
% temp=zeros(length(xt),4);
% for k=1:length(loc)
%     for u=1:4
%     temp(ceil(loc(k)/stepx),u)=temp(ceil(loc(k)/stepx),u)+denseline(k,u);
%     end
% end
% denseline=temp;
% loc=xt;

%baseline, smooth, find beam, find sensor
[m,argmax]=max(denseline);
denseline=reshape(smooth(denseline,1),size(denseline));
beams=findbeam(denseline.',loc);
beamsrecord(:,:,i)=loc(beams);
[location(:,i),prediction]=findlocation(denseline.',loc,beams);
%record baseline and distance to sensor
baseline(:,i)=loc(argmax);
end
