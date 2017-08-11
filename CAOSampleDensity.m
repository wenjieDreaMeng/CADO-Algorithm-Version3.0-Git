function [ rho ] = CAOSampleDensity( Data )

%   Author: wenjie
%   Data:   2017-8-1
%   功能;   实现分类型数据样本的密度计算

[row,col] = size(Data);
Frequency = [];

for j = 1:col
    Element = unique(Data(:,j));
    for k = 1:size(Element,1)
        persent = size(find(Data(:,j) == Element(k)),1) / row;
        Frequency = [Frequency;[j,Element(k),persent]];
    end
end

for i = 1:row
    sum = 0;
    for j = 1:col
        x = find(Frequency(:,1) == j);
        y = find(Frequency(x,2) == Data(i,j));
        persent = Frequency(y,3);
        sum = sum + persent;
    end
    rho(i) = sum / col;
end

end

