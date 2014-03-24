function [ aslpolar, facelocs] = fastpolar_roi_good(foregroundvid, facelocation, slflag, videoindex)

xyloObj = VideoReader(foregroundvid);
nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;

aslpolar= [];

facelocs = dlmread(facelocation);


mov(1:1800) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);

foregroundvid



% writerObj = VideoWriter('peaks.avi');
% writerObj.FrameRate = 2;
% open(writerObj);
nFrames
for k = 1 : length(facelocs)
  try
  if( k > nFrames)
    k
    return;
  end
  shapeInserter = vision.ShapeInserter;
  im = read(xyloObj, k);
  mov_frame = im;
  im = rgb2gray(im);
%   imshow(im)
%   im = double(im);

  if (facelocs(k) > 0)
    rects = [];
    loc  = 2;
    for r=1:facelocs(k)
     facerect = facelocs(k,loc:loc + 3);
     leftx = facerect(1);
     lefty = facerect(2);
     width = facerect(3);
     height = facerect(4);

     rectangle =  int32([leftx lefty width height]);
    
     centerx = leftx + width/2;
     centery = lefty + height/2;
       
       
     imgwidth = size(im,2);
     imgheight = size(im,1);
     
     if((leftx + 3*width) > imgwidth)
       rightbound = imgwidth;
     else
       rightbound = (leftx + 3*width);
     end
       
    if((leftx-2*width) < 0)
      leftbound = 0;
    else
      leftbound = (leftx-2*width);
    end
       
    imgwidth = rightbound - leftbound;
    
    if((lefty + 4*height) > imgheight)
      lowerbound = imgheight;
    else
      lowerbound = lefty + 4*height;
    end
    
    if((lefty - height) <0)
      upperbound = 0;
    else
      upperbound = lefty - height;
    end
    
    imgheight = lowerbound - upperbound;
    
    roirect = int32([leftbound upperbound imgwidth imgheight]);
    centerx = centerx - leftbound;
    centery = centery - upperbound;
%     imshow(im);
    im = imcrop(im,roirect);
    roi = im;
    imgheight = size(im,1);
    imgwidth = size(im,2);    
    
    mov_frame = imcrop(mov_frame,roirect);
%     imagesc(roi); xlabel('x'); ylabel('y'); title('original image'); 
%     hold on;
%     colormap gray;
%     plot(centerx,centery,'oy');
%     imshow(mov_frame);
  
   
%     imshow(im);
%     J = step(shapeInserter, im, int32([centerx centery 5 5]));
%     imshow(J);
      

     x = [];
     y = [];
     m = 1;
     n = imgwidth;
     cx = centerx;
     cy = centery;
     for i=1:imgheight
       ytemp = ones(1,imgwidth)*i;
       xtemp = 1:imgwidth;
       x = [x xtemp];
       y = [y ytemp];
     end
     
     if(imgheight*imgwidth > 0)   
       cx = ones(1,imgheight*imgwidth)*cx;
       cy = ones(1,imgheight*imgwidth)*cy;
     else
       cx =0;
       cy = 0;
     end
     
     distances = sqrt((x-cx).^2 + (y-cy).^2);
     angles = atan2(y-cy,x-cx)*180/pi + 180;
     angles = round(angles) + 1;
     distances = round(distances) + 1;
     
  
     imtranspose = im';
     
     
     pixelvalues = reshape(imtranspose,imgheight*imgwidth,1);
     cent = [centerx centery];
     dist1 = dist([0 0], cent');
     dist2 = dist([0 imgheight], cent');
     dist3 = dist([imgwidth 0], cent');
     dist4 = dist([imgwidth imgheight], cent');
     maxdist = max([dist1 dist2 dist3 dist4]);
     maxrho = round(maxdist) + 1;
     
     rho = zeros(1,maxrho);
     rhocount = zeros(1,maxrho);
     
     %Allocate accumulators for polar coordinates
     theta = zeros(1,361);
     thetacount = zeros(1,361);
     
     maxwhite =  max(max(im));
     minwhite =  min(min(im));
     for i=1:maxrho
       rhoidx = distances == i;
       pixelsToSum = pixelvalues(rhoidx);
       sbefore = size(pixelsToSum);
       whitepix = pixelsToSum > minwhite;
       safter = size(pixelsToSum(whitepix));
%        rho(i) = sum(pixelsToSum(whitepix));
       if sbefore(1) > 0
         rho(i) = safter(1)/sbefore(1);
       else
         rho(i) = 0;
       end    
     end
     
     for i=1:361
       thetaidx = angles == i;
       pixelsToSumforTheta = pixelvalues(thetaidx);
       sbefore = size(pixelsToSumforTheta);
       whitepix = pixelsToSumforTheta > minwhite;
       safter = size(pixelsToSumforTheta(whitepix));
%        theta(i) = sum(pixelsToSumforTheta(whitepix));
       theta(i) = safter(1)/sbefore(1);
       if sbefore(1) > 0
         theta(i) = safter(1)/sbefore(1);
       else
         theta(i) = 0;
       end
     end
     
%      figure;
%      subplot(221); plot(mean(im));  xlabel('x'); ylabel('accumulator')
%      subplot(223); plot(mean(im')); xlabel('y'); ylabel('accumulator')
%      subplot(222); plot(theta);  xlabel('\theta'); ylabel('accumulator')
%      subplot(224); plot(rho); xlabel('\rho'); ylabel('accumulator')

     
     percent = 1.0;
     m = 0.0;
     n = percent;
     rhosize = size(rho);
     x  = [1:rhosize(2)];
     y = x/rhosize(2) * 100 ;
     
     rhofeatures =  zeros(1,100);
     for i=1:100
       z = find((y >= m) & (y<n));
       sz = size(z);
       if (sz(2) > 0)
         rhofeatures(i) = sum(rho(:,z(1):z(sz(2))));
       else
         rhofeatures(i) = 0;
       end
       m  = m + percent;
       n  = n  + percent;
     end
     
    aslpolar = [aslpolar; theta rhofeatures slflag videoindex];
      
    rects = [rects;roirect];
    loc =  loc + 4;
    end
%     J = step(shapeInserter, mov_frame, uint8(rects));
%     writeVideo(writerObj,J );
 
  end
  catch err
  k
  err
  end  
end

% close(writerObj);
% close all
% figure;
% for i=1:100
%   plot(aslpolar(i,1:461));
%   hold on
%   pause(0.5)
% end
% hold off
% close(writerObj);
% hf = figure;
% set(hf, 'position', [150 150 vidWidth vidHeight])
% movie(hf, mov, 1,2);



