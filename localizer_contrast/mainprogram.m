function mainprogram()
global data
%% 清屏
clc
%% 输入信息
try
    [id age gender type baseline] = personalInformation();
catch exception
    throw(exception);
end
%% 设置窗口参数
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
scrnNum = max(Screen('Screens'));
%% 获取实验信息
data = initializeData(type,baseline);
%% 记录数据

% windows
%{
if (type==0)
    filePath = [pwd,'\result\sub-',num2str(id),'-LOC-RESPONSE.dat'];
    if (exist(filePath)==0)
        data.info.run = 1;data.info.id = id;data.info.age = age;data.info.gender = gender;data.info.type = type;
        Rfid = fopen([pwd,'\result\sub-',num2str(id),'-LOC-RESPONSE.dat'],'w+');
        fprintf(Rfid,'%-15s%-15s%-15s%-15s\n','RUN','ONSET','ACC','RT');
        Sfid = fopen([pwd,'\result\sub-',num2str(id),'-LOC-STIMULATE.dat'],'w+');
        fprintf(Sfid,'%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s\n','RUN','NO.','ID','AGE','GENDER','DURATION','CONTRAST','ONSET');
    elseif (exist(filePath)==2)
        runlist = textread(filePath,'%d%*f%*d%*f','headerlines',1);
        data.info.run = max(runlist)+1;data.info.id = id;data.info.age = age;data.info.gender = gender;data.info.type = type;
        Rfid = fopen([pwd,'\result\sub-',num2str(id),'-LOC-RESPONSE.dat'],'a+');
        Sfid = fopen([pwd,'\result\sub-',num2str(id),'-LOC-STIMULATE.dat'],'a+');
    else
        return;
    end
elseif(type==1)
    filePath = [pwd,'\result\sub-',num2str(id),'-EXP-RESPONSE.dat'];
    if (exist(filePath)==0)
        data.info.run = 1;data.info.id = id;data.info.age = age;data.info.gender = gender;data.info.type = type;
        Rfid = fopen([pwd,'\result\sub-',num2str(id),'-EXP-RESPONSE.dat'],'w+');
        fprintf(Rfid,'%-15s%-15s%-15s%-15s\n','RUN','ONSET','ACC','RT');
        Sfid = fopen([pwd,'\result\sub-',num2str(id),'-EXP-STIMULATE.dat'],'w+');
        fprintf(Sfid,'%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s\n','RUN','NO.','ID','AGE','GENDER','DURATION','CONTRAST','ONSET');
    elseif (exist(filePath)==2)
        runlist = textread(filePath,'%d%*f%*d%*d','headerlines',1);
        data.info.run = max(runlist)+1;data.info.id = id;data.info.age = age;data.info.gender = gender;data.info.type = type;
        Rfid = fopen([pwd,'\result\sub-',num2str(id),'-EXP-RESPONSE.dat'],'a+');
        Sfid = fopen([pwd,'\result\sub-',num2str(id),'-EXP-STIMULATE.dat'],'a+');
    else
        return;
    end
else
    return
end
%}
% os
if (type==0)
    filePath = [pwd,'/result/sub-',num2str(id),'-LOC-RESPONSE.dat'];
    if (exist(filePath)==0) % if this subject has not done this experiment before
        data.info.run = 1;data.info.id = id;data.info.age = age;data.info.gender = gender;data.info.type = type;
        Rfid = fopen([pwd,'/result/sub-',num2str(id),'-LOC-RESPONSE.dat'],'w+');
        fprintf(Rfid,'%-15s%-15s%-15s%-15s\n','RUN','ONSET','ACC','RT');
        Sfid = fopen([pwd,'/result/sub-',num2str(id),'-LOC-STIMULATE.dat'],'w+');
        fprintf(Sfid,'%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s\n','RUN','NO.','ID','AGE','GENDER','DURATION','CONTRAST','ONSET');
    elseif (exist(filePath)==2)
        runlist = textread(filePath,'%d*%f%*d%*f','headerlines',1); % read numeric data under headerline
        data.info.run = max(runlist)+1;data.info.id = id;data.info.age = age;data.info.gender = gender;data.info.type = type;
        Rfid = fopen([pwd,'/result/sub-',num2str(id),'-LOC-RESPONSE.dat'],'a+');
        Sfid = fopen([pwd,'/result/sub-',num2str(id),'-LOC-STIMULATE.dat'],'a+');
    else
        return;
    end
elseif(type==1)
    filePath = [pwd,'/result/sub-',num2str(id),'-EXP-RESPONSE.dat'];
    if (exist(filePath)==0)
        data.info.run = 1;data.info.id = id;data.info.age = age;data.info.gender = gender;data.info.type = type;
        Rfid = fopen([pwd,'/result/sub-',num2str(id),'-EXP-RESPONSE.dat'],'w+');
        fprintf(Rfid,'%-15s%-15s%-15s%-15s\n','RUN','ONSET','ACC','RT');
        Sfid = fopen([pwd,'/result/sub-',num2str(id),'-EXP-STIMULATE.dat'],'w+');
        fprintf(Sfid,'%-10s%-10s%-10s%-10s%-10s%-10s%-10s%-10s\n','RUN','NO.','ID','AGE','GENDER','DURATION','CONTRAST','ONSET');
    elseif (exist(filePath)==2)
        runlist = textread(filePath,'%d*%f%*d%*f','headerlines',1);
        data.info.run = max(runlist)+1;data.info.id = id;data.info.age = age;data.info.gender = gender;data.info.type = type;
        Rfid = fopen([pwd,'/result/sub-',num2str(id),'-EXP-RESPONSE.dat'],'a+');
        Sfid = fopen([pwd,'/result/sub-',num2str(id),'-EXP-STIMULATE.dat'],'a+');
    else
        return;
    end
else
    return
end

%% 隐藏鼠标
HideCursor;
%% 开窗口
window = Screen('OpenWindow',scrnNum,data.disp.backGroundColor,[0,0,data.disp.screenResolution]);%[0,0,data.disp.screenResolution]
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
data.disp.ifi = round(10000*Screen('GetFlipInterval', window))/10000;
Priority(1);
Screen('Preference', 'SkipSyncTests', 1);
%% 制作图片
picPoi = setPic(window);
%% 实验刺激
experiment(window,picPoi,Rfid,Sfid);
%% 显示鼠标
ShowCursor;
%% 关闭文件
fclose all;
%% 关闭窗口
Screen('CloseAll');