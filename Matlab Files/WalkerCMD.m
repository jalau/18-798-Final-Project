function WalkerCMD()
    
    %Assume result is the file name of the resulting movie file.
    image = CaptureKinect();
    [result, res_img,distance] = ClassifyWalk(image);

    %display results within Status and the second axes.
    fprintf('Match to: %s\n With E-Distance %d',result,distance);
    
     figure(1),subplot(1,2,1),imshow(image)     
     title('Input Frame')
     subplot(1,2,2),imshow(uint8(res_img)) 
     title('Classifed as: ') 

end
