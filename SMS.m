function [ Dist ] = SMS( Data )

%   Author: wenjie
%   Data:   2017-8-6
%   ����;   ��ƥ�䣬�����������룬���ؾ������

[row,col] = size(Data);
Dist = zeros(row,row);

for i = 1:row
    for j = i+1:row
        dist = 0;
        for k = 1:col
            if Data(i,k) ~= Data(j,k)
                dist = dist + 1;
            end
        end
        Dist(i,j) = dist/col;
        Dist(j,i) = dist/col;
    end
end


end

