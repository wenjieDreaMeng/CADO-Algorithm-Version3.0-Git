function [ Dist ] = NDM_ForCD( Data )

%   Author:     wenjie
%   Data:       2017-3-6
%   Function:   ʵ��Doc:A New Distance Metrix for Unsupervised Learning of Categorical Data
%   Input:      DataΪ���ݼ�
%   Output:     ������ľ������

[row,col] = size(Data);
for i = 1:row
    for j = 1:row
        Dist(i,j) = DistCompute(Data,i,j);
        Dist(j,i) = Dist(i,j);
    end
end
end


function [ delta ] = delta( Xi , Xj )

%   Function:   �ú������ͬһ������������ֵ���Ȩ��ֵ
%   Input:      �������Xi,Xj
%   Output:     ��������֮���deltaֵ

if Xi ~= Xj
    delta = 1;
else
    delta = 0;
end

end


function [dist] = DistCompute(Data, Xi, Xj)

%   Function:   �ú������������е��㷨�������������ľ���
%   Input:      ���ݼ�Data,�������Xi,Xj
%   Output:     ����Xi������Xj֮��ľ���

[row,col] = size(Data);
global ps;
global pf;
global weight;

dist = 0;
w = 0;
d = 0;

for i = 1:col
    if Data(Xi,i) ~= Data(Xj,i)
        for j = 1 : col
            [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Xi,i)));      %  �ҳ���i��ΪData(Xi,i)��Ԫ��
            Temp_i_j = find(Data(i_row,j) == Data(Xi,j));                           %  �ҳ�ͬʱ��j��ΪData(Xi,j)��Ԫ��
            P_i = size(Temp_i_j,1)/row;
            P_i_No = (size(Temp_i_j,1) - 1)/(row - 1);
            
            [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Xj,i)));      %  �ҳ���i��ΪData(Xi,i)��Ԫ��
            Temp_i_j = find(Data(i_row,j) == Data(Xj,j));                           %  �ҳ�ͬʱ��j��ΪData(Xi,j)��Ԫ��
            P_j = size(Temp_i_j,1)/row;
            P_j_No = (size(Temp_i_j,1) - 1)/(row - 1);
            d = d + weight(i,j) * (P_i * P_i_No + P_j * P_j_No);
        end
        wr = ps(i);
    else
        for j = 1 : col
            [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Xi,i)));      %  �ҳ���i��ΪData(Xi,i)��Ԫ��
            Temp_i_j = find(Data(i_row,j) == Data(Xi,j));                           %  �ҳ�ͬʱ��j��ΪData(Xi,j)��Ԫ��
            P_i = size(Temp_i_j,1)/row;
            P_i_No = (size(Temp_i_j,1) - 1)/(row - 1);
            
            [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Xj,i)));      %  �ҳ���i��ΪData(Xi,i)��Ԫ��
            Temp_i_j = find(Data(i_row,j) == Data(Xj,j));                           %  �ҳ�ͬʱ��j��ΪData(Xi,j)��Ԫ��
            P_j = size(Temp_i_j,1)/row;
            P_j_No = (size(Temp_i_j,1) - 1)/(row - 1);
            d = d + weight(i,j) * delta(Data(Xi,j),Data(Xj,j)) * (P_i * P_i_No + P_j * P_j_No);
        end
        wr = pf(i);
    end
    w = w + wr;
    dist = dist + wr*d;
end
dist = dist / w;
end
