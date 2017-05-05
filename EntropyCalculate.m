function [ Entropy ] = EntropyCalculate( Data )

%   Function:   该函数求出每一列熵作为内耦合权重值
%   Input:      数据集Data
%   Output:     权重矩阵
[row,col] = size(Data);

Entropy = zeros(1,col);
for i = 1:col
    sum = 0;
    Element = unique(Data(:,i));
    for k = 1:size(Element,1)
        P = size(find(Data(:,i) == Element(k)),1)/row;
        sum = sum + P * log2(P);
    end
    Entropy(i) = -sum / log2(size(Element,1));
end

end

