function runme(videoFile, startPoints, endPoints)

PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/local/bin/']);


if (length(startPoints) > length(endPoints))
    endPoints(length(endPoints):length(startPoints)) = -1;
elseif (length(startPoints) < length(endPoints))
    startPoints(length(endPoints):end) = [];
end

numCuts = length(startPoints);
    
%%
% readInVideo

v = VideoReader(videoFile);
[y,fs] = audioread(videoFile);
numFrames = floor(v.Duration*v.FrameRate);
audioPerFrame = size(y,1)/numFrames;

%%
% Calc Cut Points
startFrames = floor(startPoints * v.FrameRate);
endFrames = ceil(endPoints * v.FrameRate);
% cutLength = endFrames - startFrames;
for ii = 1:numCuts
    outFName{ii} = [videoFile(1:end-4) '_Cut' num2str(ii),'.avi'];
    vo{ii} = vision.VideoFileWriter(outFName{ii},'AudioInputPort',true, 'FrameRate', v.FrameRate);
end

cut = 0;
for i = 1:numFrames
% 	disp(['Read ing Frame No ', num2str(i)])
    frame = readFrame(v);
    
    for ii = 1:numCuts
        if (i >= startFrames(ii)) && (i <= endFrames(ii))
            if (cut < ii)
                cut = ii;
                disp(['In Edit Mode with Cut No ', num2str(ii), ' in Frame ' num2str(i)])
            end
            audioFrame = y(audioPerFrame*(i-1)+1:audioPerFrame*i,:);
            step(vo{ii},frame,audioFrame);
        end
        if (i == endFrames(ii))
            disp(['End Edit Mode with Cut No ', num2str(ii), ' in Frame ' num2str(i)])
            release(vo{ii})
            systemCall = ['ffmpeg -i ' outFName{ii} ' -b:a 128k -vcodec mpeg4 -b:v 1200k -flags +aic+mv4 ' outFName{ii}(1:end-4) '.mp4'];
            system(systemCall, '-echo')
        end
    end
end

% system(['mv ' videoFile ' edited/'])
system(['rm ' videoFile(1:end-4) '*.avi'])



end