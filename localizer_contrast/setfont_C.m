function setfont_C(window, bound, text, varargin)
if length(varargin) == 1
    color = varargin{1};
    backcolor = [];
elseif length(varargin) == 2
    color = varargin{1};
    backcolor = varargin{2};
else
    color = [];
    backcolor = [];
end
Rect = Screen('TextBounds', window, text);
Screen('DrawText', window, text, (bound(3)+bound(1)-Rect(3))/2, (bound(4)+bound(2)-Rect(4))/2,color,backcolor);
