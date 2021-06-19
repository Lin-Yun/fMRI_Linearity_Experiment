function experiment(window,picPoi,Rfid,Sfid)
global data
%% 函数预热
GetSecs();
%% 计算相关参数
gradientTime = data.disp.ifi*(data.stimulant.gradientNum-1);
%% 等待开始
% Str = '请注意屏幕，实验马上开始';
% setfont(window, [data.disp.screenResolution,data.disp.screenResolution]/2+[-400,-100,400,100],Str,255);
PicStart = imread(strcat([pwd '/'],'Start.jpg'));
% PicStart = imread(strcat([pwd '\'],'Start.jpg')); % for windows
TextureStart = Screen('MakeTexture',window,PicStart);
Screen('DrawTexture',window,TextureStart);

Screen('Flip', window);
WaitStart;
%% 开始实验
% 初始化参数
procedureIndex = 0;  % 刺激指标
procedureIndexTmp = procedureIndex; % 记录上次循环的刺激指标，用来判断刺激指标变化
procedureIndexFlag = 0; % 刺激指标变化标识
procedureFlipType = 1; % 刺激交替变化类型
procedureGradientIndex = 1; % 刺激对比度梯度指标

taskIndex = 0;
taskIndexTmp = taskIndex;
taskIndexFlag = 0;

writeFlag = 0;

responseStruct = [];
writeStruct    = [];

% 实验流程
Screen('gluDisk', window, data.fix.color, data.disp.screenResolution(1)/2, data.disp.screenResolution(2)/2,data.fix.size);
T0 = Screen('Flip', window);  t = T0; %T0 = round(1000*T0)/1000;
while t-T0 <= data.procedure.totalTime
    deltaT = round((t - T0 + data.disp.ifi)*1000)/1000;
    procedureIndex = find(data.procedure.timeList<=deltaT,1,'last');
    [procedureIndexFlag,procedureIndexTmp] = setFlag(procedureIndex,procedureIndexTmp);
    timeFromProcedure = deltaT - data.procedure.timeList(procedureIndex);
%     disp([num2str(procedureIndex),'------------',sprintf('%-10.3f',timeFromProcedure)]);
    taskIndex = find(data.task.timeList<=deltaT,1,'last');
    [taskIndexFlag,taskIndexTmp] = setFlag(taskIndex,taskIndexTmp);
    timeFromTask = deltaT - data.task.timeList(taskIndex);
    % 计算交替变化类型
    if mod(timeFromProcedure,2*data.procedure.switchTime)<=data.procedure.switchTime
        procedureFlipType = 1;
    else
        procedureFlipType = 2;
    end
    % 实验呈现设置
    if procedureIndex == 2
        Screen('DrawTextures', window, picPoi{1}(procedureGradientIndex,procedureFlipType),[],data.stimulant.position');
    elseif procedureIndex > 2
        if timeFromProcedure <= (data.procedure.presentTimeList(procedureIndex-2) - gradientTime)
            procedureGradientIndex = min(procedureGradientIndex+1, data.stimulant.gradientNum);
        else
            procedureGradientIndex = max(procedureGradientIndex-1, 1);
        end
        Screen('DrawTextures', window, picPoi{data.procedure.presentContrastIndex(procedureIndex-2)}(procedureGradientIndex,procedureFlipType),[],data.stimulant.position');
    end
    % 任务呈现设置
    if timeFromTask<=data.task.presentTime
        Screen('gluDisk', window, data.fix.taskcolor, data.disp.screenResolution(1)/2, data.disp.screenResolution(2)/2,data.fix.size);
    else
        Screen('gluDisk', window, data.fix.color, data.disp.screenResolution(1)/2, data.disp.screenResolution(2)/2,data.fix.size);
    end
    % 刺激呈现
    t = Screen('Flip', window, t + data.disp.ifi);
    % 反应设置
    lengthStruct = length(responseStruct);
    if taskIndexFlag
        responseStruct(lengthStruct+1).displayTime  = t;
        responseStruct(lengthStruct+1).responseFlag = 0;
        responseStruct(lengthStruct+1).responseTime = 0;
        responseStruct(lengthStruct+1).limTime      = t + data.task.responseTimeLim;
    end
    % 键盘监测
    if lengthStruct
        [keyIsDown, secs, keyCode] = KbCheck(-1);
        if keyIsDown && keyCode(data.button.respons)
            responseStruct(1).responseFlag = 1;
            responseStruct(1).responseTime = round(1000*(secs - responseStruct(1).displayTime))/1000;
            writeFlag = 1;
            writeStruct = responseStruct(1);
            responseStruct = responseStruct(2:end);
        elseif secs >= responseStruct(1).limTime
            writeFlag = 1;
            writeStruct = responseStruct(1);
            responseStruct = responseStruct(2:end);
        elseif keyIsDown && keyCode(data.button.escapeKey)
            Priority(0);
            Screen('CloseAll');
            fclose all;
            clear all;
            break;
        end
    end
    % 写入信息
    if procedureIndexFlag % 呈现刺激写入
        if procedureIndex==2
            fprintf(Sfid,'%-10d%-10d%-10d%-10d%-10d%-10.3f%-10.3f%-10.3f\n',data.info.run, procedureIndex, data.info.id, data.info.age, data.info.gender, 0, 0, round((t-T0)*1000)/1000);
        elseif procedureIndex>2
            fprintf(Sfid,'%-10d%-10d%-10d%-10d%-10d%-10.3f%-10.3f%-10.3f\n',data.info.run, procedureIndex, data.info.id, data.info.age, data.info.gender, round(data.procedure.presentTimeList(procedureIndex-2)*1000)/1000, data.procedure.stimulateContrast(data.procedure.presentContrastIndex(procedureIndex-2))*100, round((t-T0)*1000)/1000);
        end
    end
    if writeFlag % 写入反应
        fprintf(Rfid,'%-15d%-15.3f%-15d%-15.3f\n',data.info.run, round((writeStruct.displayTime-T0)*1000)/1000, writeStruct.responseFlag, writeStruct.responseTime);
        writeStruct = [];
        writeFlag = 0;
    end
end
function [flag,indexTmp] = setFlag(index,indexTmp)
if index>indexTmp
    flag = 1;
    indexTmp = index;
else
    flag = 0;
end