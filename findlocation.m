%{
Find the sensor location
Input: 1-d density curve for sensors;xt, array of y dimension;beams:
location of beams for all the sensors;
Output: Predicted location for sensors
%}
function [location,prediction]=findlocation(denseline,xt,beams)
prediction=zeros(size(denseline,1),length(xt));
for i=1:size(prediction,1)
    start=beams(i,1);
    final=beams(i,2);
    denseline(i,1:start)=0;
    denseline(i,final:end)=0;
    for j=1:1:length(xt)
        if j<=beams(i,1) || j>=beams(i,2)
            continue
        else
        simulation=vibrationfunc(xt,xt(j),xt(beams(i,:)));
        simulation=simulation/max(simulation);
        corr=corrcoef(denseline(i,:)/max(denseline(i,:)),simulation);
        prediction(i,j)=corr(1,2);
        end
    end
end
location=zeros(size(prediction,1),1);
for i=1:size(prediction,1)
    [value,argmax]=max(prediction(i,:));
    location(i)=xt(argmax);
end
end
