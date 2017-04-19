function [ R ] = WeightBetweenAttribute(Data)

%   Function:   �ú���������м�Ļ���Ϣ������׼��
%   Input:      ���ݼ�Data
%   Output:     Ȩ�ؾ���

[row,col] = size(Data);

for i = 1:col
    for j = i:col
        I = 0;                              %   Mutual Information
        H = 0;                              %   The joint entropy
        Element_i = unique(Data(:,i));      %   ȡ��ĳһ�е�Ԫ�س��ֵļ���
        Element_j = unique(Data(:,j));      %   ȡ��ĳһ�е�Ԫ�س��ֵļ���
        
        for Element_i_index = 1:size(Element_i,1)
            for Element_j_index = 1:size(Element_j,1)
                F_i = find(Data(:,i) == Element_i(Element_i_index));
                F_j = find(Data(:,j) == Element_j(Element_j_index));
                P_i = size(F_i,1)/row;     %   ������ڶ�Ӧ����ֵ����Element_i(Element_i_index)��Ԫ�صĸ���
                P_j = size(F_j,1)/row;     %   ������ڶ�Ӧ����ֵ����Element_i(Element_i_index)��Ԫ�صĸ���
                Temp_i_j = intersect(F_i,F_j);                                       %  ��Temp_i�Ļ������ҳ�ֵΪElement_j(Element_j_index)��Ԫ��
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
        if H == 0
            R(i,j) = 1;
            R(j,i) = 1;
        else
            R(i,j) = I / H;
            R(j,i) = I / H;
        end
    end
end

[row,col] = size(R);

%   ��Ȩ�ؾ���ѡȡ�����м�Ȩ�ص�ƽ��ֵ��Ϊ��ֵ
SumWeight = 0;              %   Ȩ��ֵ�ܺ�
for i = 1:row
    for j = 1:col
        SumWeight = SumWeight + R(i,j);
    end
end
ThresholdValue = SumWeight / (row * row);

for i = 1:row
    for j = 1:col
        if R(i,j) < ThresholdValue
            R(i,j) = 0;
            R(j,i) = 0;
        end
    end
end

end