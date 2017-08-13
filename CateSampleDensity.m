function [ rho ] = CateSampleDensity( Data , bindwidth)


%   Author: wenjie
%   Data:   2017-8-8
%   功能;   实现分类型数据样本的密度计算

[row,col] = size(Data);
rho = zeros(1,row);

for i = 1:row
    sum = 0;
    TotalEntropy = 0;
    
    for j = 1:col
        Element = unique(Data(:,j));
        TotalEntropy = TotalEntropy + EntropyCalculate(Data,j);
        for k = 1:row
            if i ~= k
                if Data(i,j) == Data(k,j)
                    rho_1 = 1 - bindwidth;
                else
                    rho_1 = bindwidth / (size(Element,1) - 1);
                end
                sum = sum + rho_1 * EntropyCalculate(Data,j);
            end
        end
    end
    rho(i) = sum / (col * TotalEntropy);
end

end

