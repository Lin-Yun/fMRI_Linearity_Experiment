function [id age gender type orientation] = personalInformation()
msgstr = NaN;
while 1
    if ~isnan(msgstr)
        h = msgbox(msgstr);
        uiwait(h);
    end
    prompt  = {'id:','age:','gender(0:female | 1:male):','type(0:sector | 1:circle):','orientation(0:˳or�� | 1:��or��):'};
    dlgTitle= 'Please input personal information';
    lineNo  = 1;
    info    = inputdlg(prompt,dlgTitle,lineNo);
    id      = str2double(info{1});
    age     = str2double(info{2});
    gender  = str2double(info{3});
    type    = str2double(info{4});
    orientation = str2double(info{5});
    if isnan(id) || ~isreal(id)
        msgstr = 'id�������벢��ֻ��Ϊ����';
        continue;
    end
    
    if isnan(age) || ~isreal(age)
        msgstr = 'age�������벢��ֻ��Ϊ����';
        continue;
    end
    
    if ~(gender==0 || gender==1)
        msgstr = 'gender��������0����1';
        continue
    end
    
    if ~(type==0 || type==1)
        msgstr = 'type��������0����1';
        continue
    end
    
    if ~(orientation==0 || orientation==1)
        msgstr = 'orientation��������0����1';
        continue
    end
    
    break
end