function quitfun()

% if key 'escape' is pressed, then shut down the program

[keyIsDown,secs,keyCode] = KbCheck(-1);
if keyCode(KbName('q'))
    ShowCursor;
    Screen('CloseAll');
end