function WaitStart()
global data
count = 0;
while 1
    [keyIsDown,secs,keyCode] = KbCheck(-1);
    if keyCode(data.button.escapeKey)
        count = count + 1;
        while KbCheck(-1);end;
    elseif keyCode(data.button.return)
        break;
    end
    if count == 2
        Priority(0);
        fclose all;
        Screen('CloseAll');
        clear all;
        break;
    end
end