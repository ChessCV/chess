% Good example: https://www.mathworks.com/matlabcentral/answers/127581-how-can-i-cut-every-nth-frame-of-a-video-and-save-it-without-those-frames
v = VideoReader('piece_lifting.mp4');
out = VideoWriter('wbrlift.mp4');
out.FrameRate = v.FrameRate;
open(out);

% 7.802 as that's the ending time of wbr movement
while (hasFrame(v) && (v.CurrentTime < 7.802))
    frame = readFrame(v);
    image(frame, 'Parent', axes);
    axis('image');
    axis ij;
    writeVideo(out, frame);
    pause(1/v.FrameRate);
end

close(out)
clear out;
