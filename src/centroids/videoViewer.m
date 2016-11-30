v = VideoReader('wbrlift.avi');
nth = 5;
a = 0; % Skip every nth

% View the video
while hasFrame(v)
    frame = readFrame(v);
    a = mod(a, nth);
    if a == 0
        image(frame, 'Parent', axes);
        axis('image');
        axis ij;
    %     pause(1/v.FrameRate);
    end
    a = a + 1;
end

% View a single frame
pause;
frame = read(v, ceil(v.NumberOfFrames/2));
image(frame, 'Parent', axes);
axis('image');
axis ij;

clear v;
