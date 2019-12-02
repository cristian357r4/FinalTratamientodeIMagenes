imgray= imread('cameraman.tif');
%%imgray = rgb2gray(im);

imgray1 = imrotate(imgray, 32);
imgray2 = imrotate(imgray,95);
imgray3 = padarray(imgray, [100 100], 'both' );

muHU(:,1) = invmoments(imgray);
muHU(:,2) = invmoments(imgray1);
muHU(:,3) = invmoments(imgray2);
muHU(:,4) = invmoments(imgray3);


 