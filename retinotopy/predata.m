function data = predata(type,orientation)
%% 屏幕背景
data.main.background = 128;
%% 棋盘格参数
data.checkerboard.maxsize     = 1000; %控制棋盘格精细程度
data.checkerboard.R0          = 1; %最内圈半径
data.checkerboard.beta        = 1.25; % 放大系数
data.checkerboard.nspoke      = 6; % 每90度所包含的瓣数
data.checkerboard.ncircle     = 12;% 外环保留几层
data.checkerboard.background  = data.main.background;
%% 实验参数
data.program.disptime  = 2; % 呈现时间
data.program.dispfreq  = 2; % 呈现频率
data.program.restMintime = 4; % 休息间隔最小时间
data.program.restNstep   = 3; % 休息间隔有多少种
data.program.reststep    = 2; % 休息间隔步长
data.program.baselinetime = 0; % baseline time
switch type
    case 'sector' % 扇形
        data.program.nsize     = 6; % 扇形瓣数
        data.program.step      = 2; % 扇形一次变化的瓣数（每个试次）
        data.program.start     = 22; % 扇形起始从哪瓣开始制作图片
        data.program.ncircle   = 10.5; % 循环几次
        data.program.ntrialpercircle = data.checkerboard.nspoke*4/data.program.step; % 扇形转一圈需要几个试次
        data.program.ntrial    = data.program.ncircle*data.program.ntrialpercircle; % 总共的试次数        
        data.program.condition = num2cell(mod(repmat((0:data.program.nsize-1),data.program.ntrialpercircle,1)+...
            repmat((data.program.start:data.program.step:data.program.start+data.program.step*(data.program.ntrialpercircle-1))',1,data.program.nsize)-...
            1,4*data.checkerboard.nspoke)+1,2); % 最终得到cell形式的12种扇形六个扇瓣所在的位置
        switch orientation
            case 1 % 逆时针
                data.program.first = 10; % 从哪一幅图片开始呈现
                data.program.order = mod((data.program.first:data.program.ntrial+data.program.first-1)-1,data.program.ntrialpercircle)+1;
            case 0 % 顺时针
                data.program.first = 9; % 从哪一幅图片开始呈现
                data.program.order = mod((data.program.first:-1:-data.program.ntrial+data.program.first+1)-1,data.program.ntrialpercircle)+1;
            otherwise % order为1-12的顺序序列 e.g. [10 11 12 0 1 2 3 ……]
        end
        resttime = mod((data.program.reststep:data.program.reststep:data.program.reststep*data.program.ntrial)-1,data.program.reststep*data.program.restNstep)+1+data.program.restMintime-data.program.reststep;
        data.program.resttime = resttime(randperm(length(resttime)));
    case 'circle'
%         data.program.step      = 1; % 棋盘格每次变化的环数
        data.program.ncircle   = 10.5; % 循环几次
        data.program.ntrialpercircle = 12;
        data.program.ntrial    = data.program.ncircle*data.program.ntrialpercircle; % total trial number
        switch orientation
            case 0 % 扩大
                data.program.first = 7; % 从哪一幅图片开始呈现
                data.program.order = mod((data.program.first:data.program.ntrial+data.program.first-1)-1,data.program.ntrialpercircle)+1;
            case 1 % 缩小
                data.program.first = 6; % 从哪一幅图片开始呈现
                data.program.order = mod((data.program.first:-1:-data.program.ntrial+data.program.first+1)-1,data.program.ntrialpercircle)+1;
            otherwise
        end
        resttime = mod((data.program.reststep:data.program.reststep:data.program.reststep*data.program.ntrial)-1,data.program.reststep*data.program.restNstep)+1+data.program.restMintime-data.program.reststep;
        data.program.resttime = resttime(randperm(length(resttime))); % resttime seq
end
%% 按键
data.key.start = KbName('s');
data.key.res   = KbName('1!');
%% 注视点大小
data.fix.size = 8;
data.fix.color = {[0,0,0],[255,0,0]};
%% 反应次数
data.res.num = 26;
data.res.mininterval = 8;