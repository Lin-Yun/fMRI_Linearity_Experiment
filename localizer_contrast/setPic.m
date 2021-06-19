function picPoi = setPic(window)
global data
% amplify length with same factor
width = data.stimulant.width * data.stimulant.amplificationFactor;
height = data.stimulant.height * data.stimulant.amplificationFactor;
unitWidth = data.stimulant.unitWidth * data.stimulant.amplificationFactor;
matrix_X = repmat(0:width-1,height,1);
matrix_Y = matrix_X';
matrix_Checkerboard = (mod(floor(matrix_X/unitWidth),2)*2-1).*(mod(floor(matrix_Y/unitWidth),2)*2-1);
matrix_Round = double(sqrt((matrix_X-width/2).^2+(matrix_Y-height/2).^2)<=min(width,height)/2)*255;
colorMid = 255/2;

for k = 1:length(data.procedure.stimulateContrast)
    contrastList = calContrast(data.procedure.baselineContrast,data.procedure.stimulateContrast(k),data.stimulant.gradientNum);
    for i = 1:data.stimulant.gradientNum
        colorDis = 255 * contrastList(i)/2;
        matrix_Dis = colorDis * matrix_Checkerboard;
        for j = 1:2
            matrixTmp = colorMid+(-1)^j*matrix_Dis;
            matrix = matrixTmp;
            matrix(:,:,end+1) = matrix_Round;
            picPoi{k}(i,j) = Screen('MakeTexture', window, uint8(matrix));
        end
    end
end

function contrastList = calContrast(contrast1,contrast2,num)
p = (contrast2/contrast1)^(1/(num-1));
contrastList = [contrast1];
for i = 1:num-1
    contrastList(end+1) = contrastList(end)*p;
end
contrastList(1) = contrast1;
contrastList(end) = contrast2;