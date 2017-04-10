function [ R ] = WeightBetweenAttribute(Data,ColSumPercent)

%   Function:   �ú���������м�Ļ���Ϣ������׼��
%   Input:      ���ݼ�Data
%   Output:     Ȩ�ؾ���

[row,col] = size(Data);
% fid = fopen('RelationshipBetweenAttribute', 'w');

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
%         fprintf(fid,'%6.5f ', R(i,j));
    end
%     fprintf(fid,'\n');
end

end