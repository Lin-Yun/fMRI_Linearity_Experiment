  function data = initializeData(type,baseline)
%% 基本参数
data.disp.screenResolution = [1920,1080]; %屏幕分辨率
data.disp.backGroundColor  = [128,128,128]; %屏幕背景颜色
data.disp.refreshRate = 60;
%% 内部数据
baselineContrastList = [0.125,0.25];
stimulateContrastList = [baselineContrastList/4;baselineContrastList*4];
%% 注视点参数
data.fix.color = 255;
data.fix.size = 8;
data.fix.taskcolor = [255,0,0];
%% 刺激物参数
data.stimulant.horizontal = 240; % 距中心水平偏离位置
data.stimulant.vertical = 240; % 距中心垂直偏离位置
data.stimulant.width = 312; % 单个色块的宽度
data.stimulant.height = 312; % 单个色块的高度
data.stimulant.unitWidth = 24; % 色块中小单元的宽度
data.stimulant.centre = [data.disp.screenResolution/2+[-data.stimulant.horizontal,-data.stimulant.vertical];...
                         data.disp.screenResolution/2+[-data.stimulant.horizontal,data.stimulant.vertical];...
                         data.disp.screenResolution/2+[data.stimulant.horizontal,-data.stimulant.vertical];...
                         data.disp.screenResolution/2+[data.stimulant.horizontal,data.stimulant.vertical]];
data.stimulant.position = [data.stimulant.centre+repmat(-[data.stimulant.width,data.stimulant.height]/2,4,1),data.stimulant.centre+repmat([data.stimulant.width,data.stimulant.height]/2,4,1)];                     
data.stimulant.amplificationFactor = 5; % 为了保证边缘圆滑，采用将大图缩小的方法，这里是放大倍数


%% 实验参数
switch type
    case 0 % baseline
        data.stimulant.gradientNum = 2; % 渐变梯度个数，指baselineContrast和stimulationContrast之间的渐变梯度（blank与其它阶段间不渐变），
                                        % 数量上包含初始和结束时的contrast，数量等于2意味着没有渐变，数量等于9意味着有7个梯度
        data.procedure.blankTime          = 0;     % 初始空屏时间
        data.procedure.baselineTime       = 30;    % 初始基线时间
        data.procedure.baselineContrast   = 0;     % 基线对比度
        data.procedure.stimulateContrast  = 1;     % 刺激对比度
        data.procedure.fre                = 6;     % 刺激闪烁频率
        data.procedure.switchTime         = 0.5/data.procedure.fre; % 刺激闪烁转换时间
        data.procedure.breakTime          = 30;    % 中间间隔时间
        data.procedure.presentTime        = 30;    % 呈现时间
        data.procedure.repeatTimes        = 3;
        data.procedure.trialsPreRun       = length(data.procedure.presentTime)*data.procedure.repeatTimes*length(data.procedure.stimulateContrast);    % 一个run里面有几个试次
        data.procedure.presentTimeIndex   = ones(1,data.procedure.trialsPreRun); % 选择刺激时间的指标
        data.procedure.presentTimeList    = data.procedure.presentTime(data.procedure.presentTimeIndex);
        data.procedure.presentContrastIndex = ones(1,data.procedure.trialsPreRun);
        data.procedure.totalTime          = data.procedure.blankTime + data.procedure.baselineTime + data.procedure.presentTime*data.procedure.repeatTimes*length(data.procedure.stimulateContrast) + data.procedure.breakTime*(data.procedure.repeatTimes-1);
        
        data.task.presentTime = 0.2;      % 刺激呈现时间
        data.task.responseTimeLim = 1;    % 反应限制时间
        data.task.meanTimeGap = 3;
        data.task.timeGapPlus = [0,2];
    case 1
        data.stimulant.gradientNum = 9; % 渐变梯度个数
        data.procedure.blankTime          = 30;     % 初始空屏时间
        data.procedure.baselineTime       = 60;    % 初始基线时间
        data.procedure.baselineContrast   = baselineContrastList(baseline);  % 基线对比度
        data.procedure.stimulateContrast  = stimulateContrastList(:,baseline);     % 刺激对比度
        data.procedure.fre                = 6;     % 刺激闪烁频率
        data.procedure.switchTime         = 0.5/data.procedure.fre; % 刺激闪烁转换时间
        data.procedure.breakTime          = 30;    % 中间间隔时间
        data.procedure.presentTime        = [1,3,6];    % 呈现时间
        data.procedure.repeatTimes        = 4;
        data.procedure.trialsPreRun       = length(data.procedure.presentTime)*data.procedure.repeatTimes*length(data.procedure.stimulateContrast);    % 一个run里面有几个试次
        indexTmp = repmat(1:length(data.procedure.presentTime),1,data.procedure.repeatTimes*length(data.procedure.stimulateContrast)); % duration index * repeat time e.g. [1 2 3 1 2 3 1 2 3 1 2 3]
        contrastTmp = repmat(1:length(data.procedure.stimulateContrast),data.procedure.repeatTimes*length(data.procedure.presentTime),1);contrastTmp = contrastTmp(:)'; % [1 1 1 1 1 1 2 2 2 2 2 2]
        randIndex = randperm(length(indexTmp)); % shuffle trial seq
        data.procedure.presentTimeIndex   = indexTmp(randIndex); % duration index for certain trial
        data.procedure.presentContrastIndex = contrastTmp(randIndex); % contrast for certain trial
        data.procedure.presentTimeList    = data.procedure.presentTime(data.procedure.presentTimeIndex); % duration for certain trial
        data.procedure.totalTime          = data.procedure.blankTime + data.procedure.baselineTime + sum(data.procedure.presentTime)*data.procedure.repeatTimes*length(data.procedure.stimulateContrast) + data.procedure.breakTime*data.procedure.trialsPreRun;
        
        data.task.presentTime = 0.2;
        data.task.responseTimeLim = 1;
        data.task.meanTimeGap = 3;
        data.task.timeGapPlus = [0,2];
end
procedureTimeList = [0];
for i = 1:data.procedure.trialsPreRun
    switch i
        case 1
            procedureTimeList(end+1) = procedureTimeList(end) + data.procedure.baselineTime;
        otherwise
            procedureTimeList(end+1) = procedureTimeList(end) + data.procedure.presentTime(data.procedure.presentTimeIndex(i-1)) + data.procedure.breakTime;
    end
end
data.procedure.timeList = [0, procedureTimeList + data.procedure.blankTime];
taskTimeList = 0:data.task.meanTimeGap:data.procedure.totalTime;
if (data.procedure.totalTime-taskTimeList(end) < max(data.task.timeGapPlus))
    taskTimeList = taskTimeList(1:end-1);
end
data.task.timeList = taskTimeList + (data.task.timeGapPlus(2)-data.task.timeGapPlus(1))*rand(size(taskTimeList)) + data.task.timeGapPlus(1);
%% 实验按键
data.button.respons = KbName('1!'); % 按键1
data.button.return = KbName('s'); % 字母S
data.button.escapeKey = KbName('q'); % 字母Q