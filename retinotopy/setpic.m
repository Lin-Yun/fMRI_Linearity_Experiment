function picpoi = setpic(window,type,checkerboard,program,inv)
global R0 beta
%% 设置基本变量
R0 = checkerboard.R0;
beta = checkerboard.beta;
nspoke = checkerboard.nspoke;
condition = num2cell(reshape(1:4*checkerboard.nspoke,checkerboard.nspoke,4)');
%% 计算合适大小
test_x = 1:checkerboard.maxsize;
test_y = ceil(fun(test_x));
R = find(test_y(2:end)-test_y(1:end-1)>0,program.ntrialpercircle,'last');
R_num_max = test_y(R(end));
width =  2*R(end);
height =  2*R(end);
%% 画图
x_poi = repmat(0:width,height+1,1)-width/2;
y_poi = repmat((height:-1:0)',1,width+1)-height/2;

angle_block = ceil(atan(y_poi./x_poi)/(pi/2/nspoke));
R_dis = sqrt(x_poi.^2+y_poi.^2);
R_block = ceil(fun(R_dis));

anglematrix = mod(angle_block,2)*2-1; % spokes
Rmatrix = mod(R_block,2)*2-1; % sigma
result = anglematrix.*Rmatrix;
%% 制作mask图
for i = 1:program.ntrialpercircle
    mask = zeros(size(result));
    switch type
        case 'sector'
            for j = 1:length(program.condition{i})
                switch program.condition{i}(j)
                    case condition(1,:)
                        tmp = angle_block == program.condition{i}(j) & x_poi>=0 & y_poi>=0;
                        mask = tmp | mask;
                    case condition(2,:)
                        tmp = angle_block == (program.condition{i}(j)-2*nspoke) & x_poi<=0 & y_poi>=0;
                        mask = tmp | mask;
                    case condition(3,:)
                        tmp = angle_block == (program.condition{i}(j)-2*nspoke) & x_poi<=0 & y_poi<=0;
                        mask = tmp | mask;
                    case condition(4,:)
                        tmp = angle_block == (program.condition{i}(j)-4*nspoke) & x_poi>=0 & y_poi<=0;
                        mask = tmp | mask;
                    otherwise
                end
            end
            tmp = (R_block<=R_num_max)&(R_block>R_num_max-checkerboard.ncircle); % 外环mask+内环mask
            mask = tmp & mask;
        case 'circle'
            if i == 12
                mask = (R_block == R_num_max) | (R_block == R_num_max-program.ntrialpercircle+1);
            else
                mask = (R_block>=R_num_max-program.ntrialpercircle+i) & (R_block <= R_num_max-program.ntrialpercircle+i+1);
            end
    end
    % 制作图片1
    picmat = uint8(result.*mask+1)*128;
    picmat(picmat==128) = checkerboard.background;
    if inv==1
        picpoi(i,1) = Screen('MakeTexture', window, picmat(end:-1:1,:));
    elseif inv==0
        picpoi(i,1) = Screen('MakeTexture', window, picmat);
    end
    % 制作图片2
    picmat = uint8(1-result.*mask)*128;
    picmat(picmat==128) = checkerboard.background;
    if inv==1
        picpoi(i,2) = Screen('MakeTexture', window, picmat(end:-1:1,:));
    elseif inv==0
        picpoi(i,2) = Screen('MakeTexture', window, picmat);
    end
end
function A = fun(B)
global R0 beta
a = 1/(beta-1)*R0;
A = log((B+a)/a)/log(beta)+1;