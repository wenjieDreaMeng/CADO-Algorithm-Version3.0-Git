function [ Dist ] = NDM_ForCD( Data )

%   Author:     wenjie
%   Data:       2017-3-6
%   Function:   ʵ��Doc:A New Distance Metrix for Unsupervised Learning of Categorical Data
%   Input:      DataΪ���ݼ�
%   Output:     ������ľ������

clc
global weight;

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
ps = ProbabilitySameValue( Data );
pf = ProbabilityDifferent( Data );

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

function [ ps ] = ProbabilitySameValue( Data )

%   Function:   �ú������ĳһ����ȡ��ֵͬ�ĸ���
%   Input:      ���ݼ�Data
%   Output:     ÿһ��ȡ��ֵͬ�ĸ��ʱ���

[row,col] = size(Data);
for i = 1:col
    probability = 0;
    mr = unique(Data(:,i));     %   ȡ��ĳһ�е�Ԫ�س��ֵļ���
    for j = 1:size(mr,1)
        EqualXiNum = size(find(Data(:,i) == mr(j)),1);     %   ������ڶ�Ӧ����ֵ����Xi��Ԫ�صĸ���
        probability = probability + (EqualXiNum / row) * ((EqualXiNum-1) / (row-1));
    end
    ps(i) = probability;
end

end

function [ pf ] = ProbabilityDifferent( Data )

%   Function:   �ú������ĳһ����ȡ��ֵͬ�ĸ���
%   Input:      ���ݼ�Data
%   Output:     ÿһ��ȡ��ֵͬ�ĸ��ʱ���

pf = 1.- ProbabilitySameValue(Data);

end

function [ R ] = Weight( Data )

%   Function:   �ú���������м�Ļ���Ϣ������׼��
%   Input:      ���ݼ�Data
%   Output:     Ȩ�ؾ���

[row,col] = size(Data);

for i = 1:col
    for j = 1:col
        I = 0;                              %   Mutual Information
        H = 0;                              %   The joint entropy
        Element_i = unique(Data(:,i));      %   ȡ��ĳһ�е�Ԫ�س��ֵļ���
        Element_j = unique(Data(:,j));      %   ȡ��ĳһ�е�Ԫ�س��ֵļ���
        
        for Element_i_index = 1:size(Element_i,1)
            for Element_j_index = 1:size(Element_j,1)
                P_i = size(find(Data(:,i) == Element_i(Element_i_index)),1)/row;     %   ������ڶ�Ӧ����ֵ����Element_i(Element_i_index)��Ԫ�صĸ���
                P_j = size(find(Data(:,j) == Element_j(Element_j_index)),1)/row;     %   ������ڶ�Ӧ����ֵ����Element_i(Element_i_index)��Ԫ�صĸ���
                [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Element_i(Element_i_index)));     %  �ҳ���i��ΪElement_i(Element_i_index)��Ԫ��
                Temp_i_j = find(Data(i_row,j) == Element_j(Element_j_index));                          %  ��Temp_i�Ļ������ҳ�ֵΪElement_j(Element_j_index)��Ԫ��
                %                 fprintf('i:%3d  j:%3d  i_num:%3d  j_num:%3d\n', i,j,Element_i(Element_i_index),Element_j(Element_j_index));
                P_i_j = size(Temp_i_j,1)/row;
                if P_i_j == 0           %   û�н���ʱ������ϢΪ��
                    I = I;
                    H = H;
                else                    %   �н���ʱ�����ݻ���Ϣ��ʾ���м���
                    I = I + P_i_j * log2(P_i_j/(P_i*P_j));
                    H = H + P_i_j * log2(P_i_j);
                end
            end
        end
        H = -H;
        R(i,j) = I / H;
    end
end


end
