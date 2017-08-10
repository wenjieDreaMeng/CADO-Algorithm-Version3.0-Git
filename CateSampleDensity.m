function [ rho ] = CateSampleDensity( Data , bindwidth)


%   Author: wenjie
%   Data:   2017-8-8
%   ����;   ʵ�ַ����������������ܶȼ���

[row,col] = size(Data);
rho = zeros(1,row);

for i = 1:row
    sum = 0;
    for j = 1:col
        Element = unique(Data(:,j));
        for k = 1:row
            if i ~= k
                if Data(i,j) == Data(k,j)
                    rho_1 = 1 - bindwidth;
                else
                    rho_1 = bindwidth / (size(Element,1) - 1);
                end
                sum = sum + rho_1;
            end
        end
    end
    rho(i) = sum / col;
end


end

