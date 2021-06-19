function array = setfont(window, bound, text, varargin)
if length(varargin) == 1
    color = varargin{1};
else
    color = 0;
end
len         = length(text);
lefttextnum = 1;
LR_x        = bound(1);
LR_y        = bound(2);
for i = 1:len
    normBoundsRect = Screen('TextBounds', window, text(lefttextnum:i));
    if normBoundsRect(3) > (bound(3)-bound(1))
        Screen('DrawText', window, text(lefttextnum:(i-1)),LR_x,LR_y,color);
        lefttextnum = i;
        LR_x = bound(1);
        LR_y = LR_y + normBoundsRect(4);
    end
end
Screen('DrawText', window, text(lefttextnum:i),LR_x,LR_y,color);