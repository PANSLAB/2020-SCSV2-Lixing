%{
Find the locations of beams
Input: signal profile for all the sensors y-dimension location array.
Output: beams locations, correspond to each sensor.
%}
function beams=findbeam(denseline,xt)
%one method: shift windows, require the length of beam
% maxdense=max(maxdensematrix,[],2);
% beamslocation=[];
% len=86;
% for t=1:2
% before=0;
% for i=1:length(xt)-len
%         if sum(maxdense(i:i+len))>before
%             before=sum(maxdense(i:i+len));
%             bestbeam=[xt(i),xt(i+len)];
%             bestindex=i;
%         end
% end
% beamslocation=[beamslocation,bestbeam];
% maxdense(bestindex:bestindex+len)=0;
% end
% beams=zeros(size(denseline,1),2);
% for i=1:size(denseline,1)
%     energymax=0;
%     for j=1:length(beamslocation)-1
%         dense=denseline(i,:);
%         energy=sum(dense((xt>=beamslocation(j)) & (xt<beamslocation(j+1))));
%         if energy>energymax
%             beams(i,:)=[beamslocation(j),beamslocation(j+1)];
%             energymax=energy;
%         end
%     end
% end

%find valley
smoothmaxline=smooth(max(denseline,[],1),40,'lowess');
diffmax=[0;diff(smoothmaxline)];
beamslocation=[];
beamsindex=[];
signdiffmax=sign(diffmax);
before=signdiffmax(1);

for k=2:length(signdiffmax)
    if signdiffmax(k)~=-1& before==-1
        beamslocation=[beamslocation,xt(k)];
        beamsindex=[beamsindex,k];
        threshold=smoothmaxline(k);
    end
    before=signdiffmax(k);
end
%discard bad valley
discard=[];
for j=1:length(beamsindex)
    if smoothmaxline(beamsindex(j))>1.2*min(smoothmaxline(beamsindex))
        discard=[discard,j];
    end
end
%use length of beam to find the first and last beam 
beamslocation(discard)=[];
beamsindex(discard)=[];
[m1,firstbeam]=min(abs((xt-((beamslocation(1))-6.1))));
[m2,lastbeam]=min(abs((xt-((beamslocation(end))+6.1))));
beamslocation=[xt(firstbeam),beamslocation,xt(lastbeam)];
beamsindex=[firstbeam,beamsindex,lastbeam];

%using threshold
% gap=abs(smoothmaxline-0.5*mean(threshold));
% m=1000;
% for u=1:beamsindex(1)-1
%     if gap(u)<m & signdiffmax(u)==1
%         m=gap(u);
%         fu=u;
%     end 
% end
% beamslocation=[xt(fu),beamslocation];
% beamsindex=[fu,beamsindex];
% m=1000;
% for u=beamsindex(end)+1:length(xt)
%     if gap(u)<m & signdiffmax(u)==-1
%         m=gap(u);
%         fu=u;
%     end 
% end
% beamslocation=[beamslocation,xt(fu)];
% beamsindex=[beamsindex,fu];

%allocating the beams
beams=zeros(size(denseline,1),2);
for i=1:size(denseline,1)
    energymax=0;
    dense=denseline(i,:);
    for j=1:length(beamslocation)-1
%         energy=sum(dense((xt>=beamslocation(j)) & (xt<beamslocation(j+1))));
        energy=sum(dense(beamsindex(j):beamsindex(j+1)));
        if energy>energymax
            beams(i,:)=[beamsindex(j),beamsindex(j+1)];
            energymax=energy;
        end
    end
end
end