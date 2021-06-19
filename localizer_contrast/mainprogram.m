function mainprogram()
global data
%% ����
clc
%% ������Ϣ
try
    [id age gender type baseline] = personalInformation();
catch exception
    throw(exception);
end
%% ���ô��ڲ���
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
scrnNum = max(Screen('Screens'));
%% ��ȡʵ����Ϣ
data = initializeData(type,baseline);
%% ��¼����

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

%% �������
HideCursor;
%% ������
window = Screen('OpenWindow',scrnNum,data.disp.backGroundColor,[0,0,data.disp.screenResolution]);%[0,0,data.disp.screenResolution]
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
data.disp.ifi = round(10000*Screen('GetFlipInterval', window))/10000;
Priority(1);
Screen('Preference', 'SkipSyncTests', 1);
%% ����ͼƬ
picPoi = setPic(window);
%% ʵ��̼�
experiment(window,picPoi,Rfid,Sfid);
%% ��ʾ���
ShowCursor;
%% �ر��ļ�
fclose all;
%% �رմ���
Screen('CloseAll');