%generate the association of vibration and vision
figure(1)
subplot(3,1,1)
exp=5;
t0 = datetime('05-Nov-2019 22:24:59.6');
t = data(exp).t-t0; 
plot(t, [data(exp).l data(exp).r], 'LineWidth',1.1);
xlim(seconds([67 76.5]));
ylim([-1, 14]);
legend('Left ankle''s x', 'Left ankle''s y', 'Right ankle''s x', 'Right ankle''s y', 'Orientation','horizontal', 'Position',[0.036 0.93 0.94 0.06]);
title('a','Fontsize',20)
xlabel('Time (mm:ss)','Fontsize',25);
ylabel('Pos .m','Fontsize',25)
subplot(3,1,2)
t = data(exp).tVib-t0;
plot(t, data(exp).vAligned(:,1));
xlim(seconds([67 76.5]));
ylim(0.95.*[-1 1]);
xlabel('Time (mm:ss)','Fontsize',25);
ylabel('vibration','Fontsize',25)
title('b','Fontsize',20)
s = data(exp).steps(1);
for k = 1:length(s.stepPeakVal)
				tS = t(s.stepStartIdx(k)); tE = t(s.stepEndIdx(k)); v = s.stepPeakVal(k);
    			tS=days(tS); tE=days(tE);
				rectangle('Position',[tS -v tE-tS 2*v], 'EdgeColor',[1,0.6,0.1], 'LineWidth',1);
end
			if j==1
				rectangle('Position',[days(seconds(82.75)) -0.6 days(seconds(0.4)) 1.2], 'EdgeColor',[1,0.6,0.1], 'LineWidth',1);
				rectangle('Position',[days(seconds(83.25)) -0.65 days(seconds(0.4)) 1.3], 'EdgeColor',[1,0.6,0.1], 'LineWidth',1);
			elseif j==4
				rectangle('Position',[days(seconds(72.73)) -0.77 days(seconds(0.37)) 1.54], 'EdgeColor',[1,0.6,0.1], 'LineWidth',1);
            end
subplot(3,1,3)
t = data(exp).tVib-t0;
v = (data(exp).l(:,2)+data(exp).r(:,2))/2;
peakindex=t(data(exp).steps(1).stepPeakIdx)>=seconds(67) & t(data(exp).steps(1).stepPeakIdx)<=seconds(76.5);
needpeak=floor(6158/2565413*data(exp).steps(1).stepPeakIdx(peakindex));
needvalue=data(exp).steps(1).stepPeakVal(peakindex);
plot(v(needpeak),needvalue);hold on
plot([2.9,2.9],[0,1])
text(2.8, 0.5, 'sensor location','Fontsize',12)
xlabel('footstep location .m','Fontsize',25)
ylabel('vibration','Fontsize',25)
title('c','Fontsize',20)


%%
figure(2)
%final result, randomly pick
truth=sensorPos(:,2);
randomresult=zeros(30,11,4);
randombaseline=zeros(30,11,4);
for used=2:11
iteratelocation=zeros(4,used);
for t=1:30
randomorder=randperm(11);
locationrand=location(:,randomorder);
baselinerand=baseline(:,randomorder);
for i=1:4    
    iteratelocation(i,1)=locationrand(i,1);
    for j=2:used
        if ((sqrt(var(locationrand(i,1:j-1)))*1+mean(locationrand(i,1:j-1)))>=locationrand(i,j)) & ((-sqrt(var(locationrand(i,1:j-1)))*1+mean(locationrand(i,1:j-1)))<=locationrand(i,j));
            iteratelocation(i,j)=0.5*locationrand(i,j)+0.5*iteratelocation(i,j-1);
        else
            iteratelocation(i,j)=iteratelocation(i,j-1);
        end
    end
end
randombaseline(t,used,:)=(abs(baselinerand(:,used)-truth));
randomresult(t,used,:)=(abs(iteratelocation(:,used)-truth));
end
end
for i=1:4
subplot(2,2,i) 
value=mean(randomresult(:,2:11,i),1);
err=var(randomresult(:,2:11,i),1);
partsize=2:11;
errorbar(partsize,value,err);hold on
valuebase=mean(randombaseline(:,2:11,i),1);
errbase=var(randombaseline(:,2:11,i),1);
partsize=2:11;
errorbar(partsize,valuebase,errbase);
xlim([1,12])
title(["sensor",i])
xlabel("data cycles we use")
end
%%
%beam error plot
figure(3)
truebeam=6.1;
bar(reshape(mean(beamsrecord(1:2,2,:))-truebeam,[1,11]));
xlabel('cycles we use','Fontsize',15)
ylabel('error/meters','Fontsize',15)
title('error of beam estimation','Fontsize',15)
%%
%formula test, may only use when part==1, so the shape will be nicer.
figure(4)
for i=1:4
    subplot(2,2,i)
     y=vibrationfunc(loc,location(i),loc(beams(i,:)));
     y=y/max(y);
    plot(loc,denseline(:,i)/max(denseline(:,i)));hold on
     plot(loc,y);
    title(["sensor",i]);
    xlabel("footstep through hallway/meter")
    ylabel("normalized energy")
end
legend('Data-driven model','physical model')