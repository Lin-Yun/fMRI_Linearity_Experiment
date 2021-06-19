function experiment(window,data,picpoi,ifi,fid,resfid,writeinfo)
%% 计算参数
position = round([data.ss(3)-data.ss(4),0,data.ss(3)+data.ss(4),2*data.ss(4)]/2);
dispT = 0.5/data.program.dispfreq;
dispN = data.program.disptime*data.program.dispfreq;
fixx = data.ss(3)/2;
fixy = data.ss(4)/2;
resorder = creatorder(2*data.program.ntrial*dispN,data.res.num,data.res.mininterval);
resorder = reshape(resorder,2,dispN,data.program.ntrial);
%% wait start
% setfont_C(window, data.ss, '请做好准备，等待扫描启动...实验中保持眼睛看着注视点', 0);
PicStart = imread(strcat([pwd '/'],'Start.jpg'));
% PicStart = imread(strcat([pwd '\'],'Start.jpg')); % for windows
TextureStart = Screen('MakeTexture',window,PicStart);
Screen('DrawTexture',window,TextureStart);

Screen('Flip',window);
while 1 % 等待机器启动
      [keyIsDown,secs,keyCode] = KbCheck(-1);
      if keyCode(data.key.start)
          break;
      end
end
STARTTIME = Screen('Flip',window);
%% 刺激呈现
t = STARTTIME;
buttontype = 0;
for i = 1:data.program.ntrial
    Onsettime = t - STARTTIME;
    for j = 1:dispN
        Screen('DrawTexture', window, picpoi(data.program.order(i),1),[],position);
        Screen('gluDisk', window, data.fix.color{resorder(1,j,i)}, fixx, fixy, data.fix.size);
        [response,restime,buttontype] = catchkb(t-ifi,data.key.res,buttontype);
        Screen('Flip',window,t);
        writeres(resfid,resorder(1,j,i),t,response,restime,STARTTIME,writeinfo)
        quitfun;
        t = t + dispT;
        Screen('DrawTexture', window, picpoi(data.program.order(i),2),[],position);
        Screen('gluDisk', window, data.fix.color{resorder(2,j,i)}, fixx, fixy, data.fix.size);
        [response,restime,buttontype] = catchkb(t-ifi,data.key.res,buttontype);
        Screen('Flip',window,t);
        writeres(resfid,resorder(2,j,i),t,response,restime,STARTTIME,writeinfo)
        quitfun;
        t = t + dispT;
    end
    [response,restime,buttontype] = catchkb(t,data.key.res,buttontype);
    writeres(resfid,1,t,response,restime,STARTTIME,writeinfo)
    quitfun;
    % 写入数据
    fprintf(fid,'%-15d%-15d%-15d%-15d%-15d%-15d%-25s\n',writeinfo.run,writeinfo.type,writeinfo.orientation,i,data.program.order(i),Onsettime,datestr(now));
end

function [response,restime,buttontype] = catchkb(deadtime,checkbutton,buttontype)
response = 0;
restime  = 0;
while GetSecs()<=deadtime
    [KeyIsDown,secs,KeyCode] = KbCheck(-1);
    if KeyCode(checkbutton) && ~buttontype
        buttontype = 1;
        restime = secs;
        response = 1;
    elseif ~KeyCode(checkbutton) && checkbutton
        buttontype = 0;
    end
end

function array = creatorder(totalnum,targetnum,interval)
orgarray = [repmat([2,ones(1,interval)],1,targetnum),ones(1,totalnum-targetnum*(1+interval))];
orgcell = mat2cell(orgarray,1,[(1+interval)*ones(1,targetnum),ones(1,totalnum-targetnum*(1+interval))]);
orgcell = orgcell(randperm(length(orgcell)));
array = cell2mat(orgcell);

function writeres(fid,order,t,response,restime,STARTTIME,writeinfo)
if order == 2
    fprintf(fid,'%-15d%-15s%-15d\n',writeinfo.run, 'target', round(1000*(t-STARTTIME)));
end
if response == 1
    fprintf(fid,'%-15d%-15s%-15d\n',writeinfo.run,'response',round(1000*(restime-STARTTIME)));
end