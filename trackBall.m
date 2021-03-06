% This script process a video file and tries to detect a certain
%colour by its HSV value. For each frame, center of the weight is stored
%in order to plot the position graph

%Load Video and get needed info
video=VideoReader('assets/rollingLandscape.mp4');
height=get(video,'Height');
width=get(video,'Width');
frameCount=video.NumberOfFrames;
frameRate=get(video,'FrameRate');

posX=1:frameCount; %An array which holds the position of the ball on X
posY=1:frameCount; %An array which holds the position of the ball on Y

%Loop for each frame and try to calculate the position of the ball
for curFrame=1:frameCount
    
    %Get the frame
    IMG=read(video,curFrame);
    
    %Converting RGB to HSV
    IMGHsv=rgb2hsv(IMG);

    %Extracting Hue, Saturation and Value
    IMGHue=IMGHsv(:,:,1);
    IMGSat=IMGHsv(:,:,2);
    IMGVal=IMGHsv(:,:,3);

    %Adjust these thresholds to get the needed colour (These are for a tennis
    %ball
    hueLow=0.15;
    hueHigh=0.2;

    satLow=0.7;
    satHigh=0.99;

    valueLow=0.4;
    valueHigh=0.95;

    hueMask=(IMGHue >= hueLow) & (IMGHue<=hueHigh);
    satMask=(IMGSat >= satLow)&(IMGSat <= satHigh);
    valueMask=(IMGVal >= valueLow) & (IMGVal <= valueHigh);

    maskHsv=uint8(hueMask & satMask & valueMask); %uint8 is needed for the multiplication with IMG

    maskRgbRed=maskHsv.*IMG(:,:,1);
    maskRgbGreen=maskHsv.*IMG(:,:,2);
    maskRgbBlue=maskHsv.*IMG(:,:,3);

    maskRgb=cat(3,maskRgbRed,maskRgbGreen,maskRgbBlue);

    %Convert RGB image to Binary
    IMGBin=im2bw(maskRgb,0.3);

    %Calculate the position of the ball...
    
    %find functions gets the indices where the value is other than zero
    [centerX,centerY]=find(IMGBin);
    
    %Get the center of weight
    
    %If video taken on landscape mode...
    posX(curFrame)=mean(centerX);%Mirror the image on x axis 
    posY(curFrame)=height-mean(centerY);
    
    %If video taken on portrait mode...
    %posX(curFrame)=width-mean(centerX);%Mirror the image on x axis 
    %posY(curFrame)=height-mean(centerY);
    
end

plot(posX,posY);
axis([0,width,0,height]);
