  function data = initializeData(type,baseline)
%% ��������
data.disp.screenResolution = [1920,1080]; %��Ļ�ֱ���
data.disp.backGroundColor  = [128,128,128]; %��Ļ������ɫ
data.disp.refreshRate = 60;
%% �ڲ�����
baselineContrastList = [0.125,0.25];
stimulateContrastList = [baselineContrastList/4;baselineContrastList*4];
%% ע�ӵ����
data.fix.color = 255;
data.fix.size = 8;
data.fix.taskcolor = [255,0,0];
%% �̼������
data.stimulant.horizontal = 240; % ������ˮƽƫ��λ��
data.stimulant.vertical = 240; % �����Ĵ�ֱƫ��λ��
data.stimulant.width = 312; % ����ɫ��Ŀ��
data.stimulant.height = 312; % ����ɫ��ĸ߶�
data.stimulant.unitWidth = 24; % ɫ����С��Ԫ�Ŀ��
data.stimulant.centre = [data.disp.screenResolution/2+[-data.stimulant.horizontal,-data.stimulant.vertical];...
                         data.disp.screenResolution/2+[-data.stimulant.horizontal,data.stimulant.vertical];...
                         data.disp.screenResolution/2+[data.stimulant.horizontal,-data.stimulant.vertical];...
                         data.disp.screenResolution/2+[data.stimulant.horizontal,data.stimulant.vertical]];
data.stimulant.position = [data.stimulant.centre+repmat(-[data.stimulant.width,data.stimulant.height]/2,4,1),data.stimulant.centre+repmat([data.stimulant.width,data.stimulant.height]/2,4,1)];                     
data.stimulant.amplificationFactor = 5; % Ϊ�˱�֤��ԵԲ�������ý���ͼ��С�ķ����������ǷŴ���


%% ʵ�����
switch type
    case 0 % baseline
        data.stimulant.gradientNum = 2; % �����ݶȸ�����ָbaselineContrast��stimulationContrast֮��Ľ����ݶȣ�blank�������׶μ䲻���䣩��
                                        % �����ϰ�����ʼ�ͽ���ʱ��contrast����������2��ζ��û�н��䣬��������9��ζ����7���ݶ�
        data.procedure.blankTime          = 0;     % ��ʼ����ʱ��
        data.procedure.baselineTime       = 30;    % ��ʼ����ʱ��
        data.procedure.baselineContrast   = 0;     % ���߶Աȶ�
        data.procedure.stimulateContrast  = 1;     % �̼��Աȶ�
        data.procedure.fre                = 6;     % �̼���˸Ƶ��
        data.procedure.switchTime         = 0.5/data.procedure.fre; % �̼���˸ת��ʱ��
        data.procedure.breakTime          = 30;    % �м���ʱ��
        data.procedure.presentTime        = 30;    % ����ʱ��
        data.procedure.repeatTimes        = 3;
        data.procedure.trialsPreRun       = length(data.procedure.presentTime)*data.procedure.repeatTimes*length(data.procedure.stimulateContrast);    % һ��run�����м����Դ�
        data.procedure.presentTimeIndex   = ones(1,data.procedure.trialsPreRun); % ѡ��̼�ʱ���ָ��
        data.procedure.presentTimeList    = data.procedure.presentTime(data.procedure.presentTimeIndex);
        data.procedure.presentContrastIndex = ones(1,data.procedure.trialsPreRun);
        data.procedure.totalTime          = data.procedure.blankTime + data.procedure.baselineTime + data.procedure.presentTime*data.procedure.repeatTimes*length(data.procedure.stimulateContrast) + data.procedure.breakTime*(data.procedure.repeatTimes-1);
        
        data.task.presentTime = 0.2;      % �̼�����ʱ��
        data.task.responseTimeLim = 1;    % ��Ӧ����ʱ��
        data.task.meanTimeGap = 3;
        data.task.timeGapPlus = [0,2];
    case 1
        data.stimulant.gradientNum = 9; % �����ݶȸ���
        data.procedure.blankTime          = 30;     % ��ʼ����ʱ��
        data.procedure.baselineTime       = 60;    % ��ʼ����ʱ��
        data.procedure.baselineContrast   = baselineContrastList(baseline);  % ���߶Աȶ�
        data.procedure.stimulateContrast  = stimulateContrastList(:,baseline);     % �̼��Աȶ�
        data.procedure.fre                = 6;     % �̼���˸Ƶ��
        data.procedure.switchTime         = 0.5/data.procedure.fre; % �̼���˸ת��ʱ��
        data.procedure.breakTime          = 30;    % �м���ʱ��
        data.procedure.presentTime        = [1,3,6];    % ����ʱ��
        data.procedure.repeatTimes        = 4;
        data.procedure.trialsPreRun       = length(data.procedure.presentTime)*data.procedure.repeatTimes*length(data.procedure.stimulateContrast);    % һ��run�����м����Դ�
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
%% ʵ�鰴��
data.button.respons = KbName('1!'); % ����1
data.button.return = KbName('s'); % ��ĸS
data.button.escapeKey = KbName('q'); % ��ĸQ