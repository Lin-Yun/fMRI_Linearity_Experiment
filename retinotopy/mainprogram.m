function mainprogram(varargin)
%% ������Ϣ
if isempty(varargin) % if no input for mainprogram
    [id age gender type orientation] = personalInformation();
elseif length(varargin)==5 % if 5 input for subject info has been input
    id = varargin{1};
    age = varargin{2};
    gender = varargin{3};
    type = varargin{4};
    orientation = varargin{5};
    [result,msgstr] = check(id,age,gender,type,orientation); % script for check function is written in the end of this file
    if result==0
        error(msgstr);
    end
else
    error('������5��������˳��ֱ��� id age gender(0:female | 1:male) type(0:sector | 1:circle) orientation(0:˳or�� | 1:��or��)');
end
%% ���ô��ڲ���
AssertOpenGL;
scrnNum = max(Screen('Screens'));
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
%% �򿪴����ļ�
writeinfo.type = type;
writeinfo.orientation = orientation;

% for windows
%{ 
try
    fid = fopen([pwd,'\result\sub-',num2str(id),'.txt'],'r+'); 
    if fid == -1
        fid = fopen([pwd,'\result\sub-',num2str(id),'.txt'],'w');
        fprintf(fid,'%-10s--->%-10s\n','ID',num2str(id));
        fprintf(fid,'%-10s--->%-10s\n','age',num2str(age));
        fprintf(fid,'%-10s--->%-10s\n','gender',num2str(gender));
        fprintf(fid,'%-15s%-15s%-15s%-15s%-15s%-15s%-25s\n','Run','Type','Orientation','No.','PicNum','Onset','WriteTime');
        writeinfo.run = 1;
    else
        while ~feof(fid)
            tline = fgetl(fid);
        end
        if isnan(str2double(tline(1:15)))
            writeinfo.run = 1;
        else
            writeinfo.run = str2double(tline(1:15))+1;
        end
    end
catch exception
    fclose all;
    throw(exception);
end

try
    resfid = fopen([pwd,'\result\sub-',num2str(id),'_res.txt'],'r+');
    if resfid == -1
        resfid = fopen([pwd,'\result\sub-',num2str(id),'_res.txt'],'w');
        fprintf(resfid,'%-15s%-15s%-15s\n','Run','Type','time');
        writeinfo.run = 1;
    else
        while ~feof(resfid)
            tline = fgetl(resfid);
        end
        if isnan(str2double(tline(1:15)))
            writeinfo.run = 1;
        else
            writeinfo.run = str2double(tline(1:15))+1;
        end
    end
catch exception
    fclose all;
    throw(exception);
end
%}

% for OS
try
    fid = fopen([pwd,'/result/sub-',num2str(id),'.txt'],'r+'); 
    if fid == -1
        fid = fopen([pwd,'/result/sub-',num2str(id),'.txt'],'w');
        fprintf(fid,'%-10s--->%-10s\n','ID',num2str(id));
        fprintf(fid,'%-10s--->%-10s\n','age',num2str(age));
        fprintf(fid,'%-10s--->%-10s\n','gender',num2str(gender));
        fprintf(fid,'%-15s%-15s%-15s%-15s%-15s%-15s%-25s\n','Run','Type','Orientation','No.','PicNum','Onset','WriteTime');
        writeinfo.run = 1;
    else
        while ~feof(fid) % not reach the end of file
            tline = fgetl(fid); % get the next line
        end
        if isnan(str2double(tline(1:15)))
            writeinfo.run = 1;
        else
            writeinfo.run = str2double(tline(1:15))+1;
        end
    end
catch exception
    fclose all;
    throw(exception);
end

try
    resfid = fopen([pwd,'/result/sub-',num2str(id),'_res.txt'],'r+');
    if resfid == -1
        resfid = fopen([pwd,'/result/sub-',num2str(id),'_res.txt'],'w');
        fprintf(resfid,'%-15s%-15s%-15s\n','Run','Type','time');
        writeinfo.run = 1;
    else
        while ~feof(resfid)
            tline = fgetl(resfid);
        end
        if isnan(str2double(tline(1:15)))
            writeinfo.run = 1;
        else
            writeinfo.run = str2double(tline(1:15))+1; % get the run number for present run
        end
    end
catch exception
    fclose all;
    throw(exception);
end
%% ��ȡʵ����Ϣ
switch type
    case 0
        switch orientation
            case 0
                data = predata('sector',0);
            case 1
                data = predata('sector',1);
        end
        type = 'sector';
    case 1
        switch orientation
            case 0
                data = predata('circle',0);
            case 1
                data = predata('circle',1);
        end
        type = 'circle';
    otherwise
        error('��ȡ��������ʧ��');
end
%% ʵ��
try
    % ������
    [window,data.ss] = Screen('OpenWindow',scrnNum,data.main.background);
    ifi=Screen('GetFlipInterval', window);
    Priority(1);
    % ��ȡͼƬ
    picpoi = setpic(window,type,data.checkerboard,data.program,0);
    % �������
    HideCursor;
    % ʵ��
    experiment(window,data,picpoi,ifi,fid,resfid,writeinfo);
catch exception
    fclose all;
    Screen('CloseAll');
    throw(exception);
end

%% ��ʾ���
ShowCursor;
%% �ر��ļ�
fclose all;
%% �رմ���
Screen('CloseAll');

function [result,msgstr] = check(id,age,gender,type,orientation)
result = 1;
msgstr = [];

if isnan(id) || ~isreal(id)
    msgstr = [msgstr,' id�������벢��ֻ��Ϊ����'];
    result = 0;
end

if isnan(age) || ~isreal(age)
    msgstr = [msgstr,' age�������벢��ֻ��Ϊ����'];
    result = 0;
end

if ~(gender==0 || gender==1)
    msgstr = [msgstr,' gender��������0����1'];
    result = 0;
end

if ~(type==0 || type==1)
    msgstr = [msgstr,' type��������0����1'];
    result = 0;
end

if ~(orientation==0 || orientation==1)
    msgstr = [msgstr,' orientation��������0����1'];
    result = 0;
end
