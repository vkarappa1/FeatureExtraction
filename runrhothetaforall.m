vidlist = dir('E:\related_193\nonasl\compressed\');
vidsize = size(vidlist);
vidsize(1);
save('imporved_nonasl_list.mat','vidlist');
imporved_nonasl= []; 
ids = [];
names = {};
parfor i=1:vidsize(1)
  try
  vidlocation = ['E:\related_193\nonasl\compressed\', vidlist(i).name];
  facelocation = ['E:\related_193\nonasl\compressed\', vidlist(i).name, '.txt'];
  namelength = size(vidlist(i).name);
  vidname = vidlist(i).name;
  fgvidname = [vidname(1:namelength(2)-4),'_foregnd.avi'];
  fglocation = ['E:\related_193\nonasl\compressed\',fgvidname];
  fcheck = exist(facelocation, 'file');
  fgcheck = exist(fglocation, 'file');
  
  if (fcheck==2) && (fgcheck==2)
    ids = [ids;i];
%     names{end + 1} = vidlist(i).name;
    aslpolar = fastpolar_roi_good(fglocation,facelocation,1,i);
    imporved_nonasl = [imporved_nonasl;aslpolar];
  end
  catch err
    err
  end
end
save('imporved_nonasl.mat','imporved_nonasl');

figure;
hold on;
for i=1:12
  plot(averageaslpolar(i,1:461));
end
hold off;


vidlist = dir('E:\videos\videos\subsampledASLvideos2\');
vidsize = size(vidlist);
vidsize(1);

aslpolarforall2 = []; 
parfor i=1:vidsize(1)
  vidlocation = ['E:\videos\videos\subsampledASLvideos2\', vidlist(i).name]
  facelocation = ['E:\videos\videos\subsampledASLvideos2\', vidlist(i).name, '.bin'];
  namelength = size(vidlist(i).name);
  vidname = vidlist(i).name;
  fgvidname = [vidname(1:namelength(2)-4),'_foregnd.avi'];
  fglocation = ['E:\videos\videos\subsampledASLvideos2\',fgvidname]
  fcheck = exist(facelocation, 'file');
  fgcheck = exist(fglocation, 'file');
  
  if (fcheck==2) && (fgcheck==2)
    aslpolar = fastpolar(fglocation,facelocation,1,i);
    aslpolarforall2 = [aslpolarforall2;aslpolar];
  end
end
save('caioaslpolarforall2.mat','aslpolarforall2');


vidids = aslpolarforall2(:,463);
uvidids = unique(vidids);
svid = size(uvidids);
averageaslpolar2 = []
for i=1:svid(1)
  idx = find(vidids == uvidids(i));
  aslpolarsfori = aslpolarforall2(idx,1:461);
  averageaslpolar2 = [averageaslpolar2;mean(aslpolarsfori(50:end,:)) uvidids(i)];
%   break;
end

nvidids = naslpolarforall2(:,463);
nuvidids = unique(nvidids);
svid = size(nuvidids);
averagenaslpolar2 = []
for i=1:svid(1)
  idx = find(nvidids == nuvidids(i));
  naslpolarforalli = naslpolarforall2(idx,1:461);
  averagenaslpolar2 = [averagenaslpolar2;mean(naslpolarforalli(50:end,:)) nuvidids(i)];
%   break;
end



for j=1:31
  s = sum(averagepolar(j,:));
  q = isnan(s);
  if (q==1)
    averagepolar(j,:) = [];
  end
end


asltruepolar = []
for j=1:17
  avp = averagepolar(j,181:361);
  asltruepolar = [asltruepolar;avp];
end

randompolar = [];
for i=1:17
  r = rand(1,181);
  randompolar = [randompolar;r];
end


for i=1:14
  figure;
  plot(averagepolar(i,1:361));
end



aslpolar = [];
nonaslpolar = [];
for i=11:12
  aslpolar = [aslpolar;averagepolar(i,181:361)];
  nonaslpolar = [nonaslpolar;averagenonaslpolar(i,181:361)];
end
test = [aslpolar;nonaslpolar];

for j=12:19
  test = [test;averagepolar(i,181:361)];
end

data = [asltruepolar;randompolar];
clab1 = ones(10,1);
clab2 = zeros(10,1);
clab = [clab1;clab2];


for j=1:44
  s = sum(averagenaslpolar(j,1:461))
  q = isnan(s)
  if (q==1)
    averagenaslpolar(j,:) = [];
  end
end

for j=1:39
  s = sum(averagepolar(j,1:461))
  q = isnan(s)
  if (q==1)
    averagepolar(j,:) = [];
  end
end

data = [averagepolar(1:20,181:461);averagenaslpolar(1:20,181:461)];
group = [ones(20,1);zeros(20,1)];
test = [averagepolar(16:38,181:461);averagenaslpolar(16:38,181:461)];
svmstruct = svmtrain(data,group);
result = svmclassify(svmstruct,test);

for i=1:41
  figure;
  plot(averagepolar(i,1:461));
  axis tight
  drawnow
end



close all;
figure;
for i=1:20000
  plot(aslpolarforall(i,181:361));
  axis tight
  drawnow
end

asvidids = imporved_nonasl(:,463);
uvidids = unique(asvidids);
frames = [];


svid = size(uvidids);
averageaslpolar = []
parfor i=1:svid(1)
  obj = VideoReader(['Z:\related\compressed\' vidlist(uvidids(i)).name]);
  if( obj.NumberOfFrames < 3600)
    frames = [frames;obj.NumberOfFrames];
  else
    frames = [frames;3600];
  end
end


for i=1:svid(1)
  idx = find(asvidids == uvidids(i));
  aslpolarsfori = imporved_nonasl(idx,1:461);
  averageaslpolar = [averageaslpolar;sum(aslpolarsfori(50:end,:))/(frames(i)-50) uvidids(i)];
%   break;
end

nuvidids = unique(nasvidids);
svid = size(nuvidids);
averagenaslpolar = []
for i=1:svid(1)
  idx = find(nasvidids == nuvidids(i));
  naslpolarforalli = naslpolar(idx,1:461);
  averagenaslpolar = [averagenaslpolar;mean(naslpolarforalli(50:end,:)) nuvidids(i)];
%   break;
end

for j=1:size(averageaslpolar,1)
  s = sum(averageaslpolar(j,1:461))
  q = isnan(s)
  if (q==1)
    averageaslpolar(j,:) = [];
  end
end

for j=1:size(averagenaslpolar,1)
  s = sum(averagenaslpolar(j,1:461))
  q = isnan(s)
  if (q==1)
    averagenaslpolar(j,:) = [];
  end
end
%%
samples = [15 20 25 30 35 40 45 50 55 60];
pmeans = [];
rmeans = [];
fmeans = [];
accmeans = [];
for sam = 1:length(samples);
  sam
  numberofsamples = samples(sam);
  tempp = [];
  tempr = [];
  tempf = [];
  for j=1:1000
    numberoftests = 1:100;
    sampleindex = randi(100,numberofsamples,1);
    remainingindex = setdiff(numberoftests,sampleindex)';
    
    numberoffeatures = 1:461;
    data = [averageaslpolar(sampleindex,numberoffeatures);averagenaslpolar(sampleindex,numberoffeatures)];
    %%%%%%%%%%%%%%%%%%%%%
    datasize1 = size(data)
    temp = data;
    [l,s,latent] = princomp(temp);
    avgs = mean(temp);
    data = s(:,1:70);
    datasize = size(data)
    %%%%%%%%%%%%%%%%%%%%%%
    labels = [ones(numberofsamples,1);zeros(numberofsamples,1)];
    test = [averageaslpolar(remainingindex,numberoffeatures);averagenaslpolar(remainingindex,numberoffeatures)];
    %%%%%%%%%%%%%%%%
    test = bsxfun(@minus, test, avgs);
    test = test*l;
    
    test = test(:,1:70);
    testsize = size(test)
    %%%%%%%%%%%%%%%%%%
    svmstruct = svmtrain(data,labels, 'Kernel_Function','linear');
    result = svmclassify(svmstruct,test);
    sl = find(result(1:size(test,1)/2)==1);
    nsl = find(result(size(test,1)/2 + 1:size(test,1))==0);
    accuracy = (length(sl) + length(nsl))/size(test,1);
    fp = size(test,1)/2 - length(nsl);
    fn = size(test,1)/2 - length(sl);
    tp = length(sl);
    tn = length(nsl);
    
    if((tp + fp)>0)
      precision = tp/(tp + fp);
      tempp = [tempp;precision];
    end
    
    if((tp + fn)>0)
      recall = tp/(tp + fn);
      tempr = [tempr;recall];
    end
    
    if((precision + recall) > 0)
      f1 = (2*(precision*recall))/(precision + recall);
      tempf = [tempf;f1];
    end
   
  end
  meanp = mean(tempp);
  meanr = mean(tempr);
  meanf = mean(tempf);
  
  pmeans = [pmeans;meanp];
  rmeans = [rmeans;meanr];
  fmeans = [fmeans;meanf];
end

%%
figure;
hold on;
s = 10:5:60;
plot(s, pmeans,'-*r');
plot(s, rmeans,'-*b');
plot(s, fmeans, '-*m');
% plot(s, accmeans,'g');
legend('precision','recall','f1');
xlabel('Sample Size');
ylabel('Score');
% for i=1:9
%   text(s(i),pmeans(i),num2str(pmeans(i)));
%   text(s(i),fmeans(i),num2str(rmeans(i)));
%   text(s(i),rmeans(i),num2str(rmeans(i)));
% end
[minp, minpi] = min(pmeans);
[maxp, maxpi] = max(pmeans);
text(s(minpi),pmeans(minpi) - 0.002,num2str(pmeans(minpi)));
text(s(maxpi)- 3 ,pmeans(maxpi) - 0.002,num2str(pmeans(maxpi)));

[minp, minpi] = min(fmeans);
[maxp, maxpi] = max(fmeans);
text(s(minpi),fmeans(minpi) - 0.002,num2str(fmeans(minpi)));
text(s(maxpi)- 3 ,fmeans(maxpi) - 0.002,num2str(fmeans(maxpi)));

[minp, minpi] = min(rmeans);
[maxp, maxpi] = max(rmeans);
text(s(minpi),rmeans(minpi) - 0.002,num2str(rmeans(minpi)));
text(s(maxpi)- 3 ,rmeans(maxpi) - 0.002,num2str(rmeans(maxpi)));

title('Features - "theta: 0-360, rho"','FontSize',14); 
hold off;

%%
close all;
X = 10:5:50;
for j=1:4
  figure;
  plot(X,pmeans(:,j),'-*',X,rmeans(:,j),'-*',X,fmeans(:,j),'-*');
  legend('precision','recall','f1');
end


%%caio's
figure;
hold on;
X = [15 30 45 60];
precision = [0.8173 0.8362 0.8067 0.8221];
recall = [0.8647 0.8811 0.9100 0.9083];
F1 = [0.84 0.85 0.85 0.86];

plot(X, precision','-*r');
plot(X, recall','-*b');
plot(X, F1', '-*m');
legend('precision','recall','f1');
xlabel('Sample Size');
ylabel('Score');
title('Caio results','FontSize',14); 
hold off;






