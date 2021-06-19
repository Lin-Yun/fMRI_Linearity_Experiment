function [id age gender type baseline] = personalInformation()
msgstr = NaN;
while 1
    if ~isnan(msgstr)
        h = msgbox(msgstr);
        uiwait(h);
    end
    prompt  = {'id:','age:','gender(0:female | 1:male):','type(0:location | 1:test):','baseline(1:12.5% | 2:25%):'};
    dlgTitle= 'Please input personal information';
    lineNo  = 1;
    info    = inputdlg(prompt,dlgTitle,lineNo);
    id      = str2double(info{1});
    age     = str2double(info{2});
    gender  = str2double(info{3});
    type  = str2double(info{4});
    baseline = str2double(info{5});
    
    if isnan(id) || ~isreal(id)
        msgstr = 'id必须输入并且只能为数字';
        continue;
    end
    
    if isnan(age) || ~isreal(age)
        msgstr = 'age必须输入并且只能为数字';
        continue;
    end
    
    if ~(gender==0 || gender==1)
        msgstr = 'gender必须输入0或者1';
        continue
    end
    
    if ~(type==0 || type==1)
        msgstr = 'type必须输入0或者1';
        continue
    end
    
    if ~(baseline==1 || baseline==2)
        msgstr = 'baseline必须输入1或者2';
        continue
    end
    break
end