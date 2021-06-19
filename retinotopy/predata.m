function data = predata(type,orientation)
%% ��Ļ����
data.main.background = 128;
%% ���̸����
data.checkerboard.maxsize     = 1000; %�������̸�ϸ�̶�
data.checkerboard.R0          = 1; %����Ȧ�뾶
data.checkerboard.beta        = 1.25; % �Ŵ�ϵ��
data.checkerboard.nspoke      = 6; % ÿ90���������İ���
data.checkerboard.ncircle     = 12;% �⻷��������
data.checkerboard.background  = data.main.background;
%% ʵ�����
data.program.disptime  = 2; % ����ʱ��
data.program.dispfreq  = 2; % ����Ƶ��
data.program.restMintime = 4; % ��Ϣ�����Сʱ��
data.program.restNstep   = 3; % ��Ϣ����ж�����
data.program.reststep    = 2; % ��Ϣ�������
data.program.baselinetime = 0; % baseline time
switch type
    case 'sector' % ����
        data.program.nsize     = 6; % ���ΰ���
        data.program.step      = 2; % ����һ�α仯�İ�����ÿ���ԴΣ�
        data.program.start     = 22; % ������ʼ���İ꿪ʼ����ͼƬ
        data.program.ncircle   = 10.5; % ѭ������
        data.program.ntrialpercircle = data.checkerboard.nspoke*4/data.program.step; % ����תһȦ��Ҫ�����Դ�
        data.program.ntrial    = data.program.ncircle*data.program.ntrialpercircle; % �ܹ����Դ���        
        data.program.condition = num2cell(mod(repmat((0:data.program.nsize-1),data.program.ntrialpercircle,1)+...
            repmat((data.program.start:data.program.step:data.program.start+data.program.step*(data.program.ntrialpercircle-1))',1,data.program.nsize)-...
            1,4*data.checkerboard.nspoke)+1,2); % ���յõ�cell��ʽ��12�����������Ȱ����ڵ�λ��
        switch orientation
            case 1 % ��ʱ��
                data.program.first = 10; % ����һ��ͼƬ��ʼ����
                data.program.order = mod((data.program.first:data.program.ntrial+data.program.first-1)-1,data.program.ntrialpercircle)+1;
            case 0 % ˳ʱ��
                data.program.first = 9; % ����һ��ͼƬ��ʼ����
                data.program.order = mod((data.program.first:-1:-data.program.ntrial+data.program.first+1)-1,data.program.ntrialpercircle)+1;
            otherwise % orderΪ1-12��˳������ e.g. [10 11 12 0 1 2 3 ����]
        end
        resttime = mod((data.program.reststep:data.program.reststep:data.program.reststep*data.program.ntrial)-1,data.program.reststep*data.program.restNstep)+1+data.program.restMintime-data.program.reststep;
        data.program.resttime = resttime(randperm(length(resttime)));
    case 'circle'
%         data.program.step      = 1; % ���̸�ÿ�α仯�Ļ���
        data.program.ncircle   = 10.5; % ѭ������
        data.program.ntrialpercircle = 12;
        data.program.ntrial    = data.program.ncircle*data.program.ntrialpercircle; % total trial number
        switch orientation
            case 0 % ����
                data.program.first = 7; % ����һ��ͼƬ��ʼ����
                data.program.order = mod((data.program.first:data.program.ntrial+data.program.first-1)-1,data.program.ntrialpercircle)+1;
            case 1 % ��С
                data.program.first = 6; % ����һ��ͼƬ��ʼ����
                data.program.order = mod((data.program.first:-1:-data.program.ntrial+data.program.first+1)-1,data.program.ntrialpercircle)+1;
            otherwise
        end
        resttime = mod((data.program.reststep:data.program.reststep:data.program.reststep*data.program.ntrial)-1,data.program.reststep*data.program.restNstep)+1+data.program.restMintime-data.program.reststep;
        data.program.resttime = resttime(randperm(length(resttime))); % resttime seq
end
%% ����
data.key.start = KbName('s');
data.key.res   = KbName('1!');
%% ע�ӵ��С
data.fix.size = 8;
data.fix.color = {[0,0,0],[255,0,0]};
%% ��Ӧ����
data.res.num = 26;
data.res.mininterval = 8;