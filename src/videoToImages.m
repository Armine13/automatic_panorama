function fileNames = videoToImages(videoPath)

d = '../imagesVideo/';
mkdir(d);

videoFReader = vision.VideoFileReader(videoPath);
fileNames = {};
i = 0;
k = 1;
while ~isDone(videoFReader)
    i = i + 1;
    
    frame = step(videoFReader);
    if mod(i, 30) == 0,
        fileNames{k} = strcat(d,[sprintf('%03d',k-1) '.jpg']);
        imwrite(frame, fileNames{k});
        k = k + 1;
    end
end
release(videoFReader);
