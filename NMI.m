function v = NMI(label, result)

%   Function:   �ú���������м�Ļ���Ϣ������׼��
%   Input:      ���ǩ��������
%   Output:     NMIֵ

assert(length(label) == length(result));
row = length(label);

I = 0;                              %   Mutual Information
H = 0;                              %   The joint entropy
HLabel = 0;                         %   Label����
HResult = 0;                        %   Result����
Element_i = unique(label);          %   ȡ��ĳһ�е�Ԫ�س��ֵļ���
Element_j = unique(result);         %   ȡ��ĳһ�е�Ԫ�س��ֵļ���

%   ��Label����
for Element_i_index = 1:size(Element_i,1)
    P_i = size(find(label == Element_i(Element_i_index)),1)/row;
    HLabel = HLabel + P_i * log2(P_i + eps);
end
HLabel = -HLabel;
%   ��Result����
for Element_j_index = 1:size(Element_j,1)
    P_j = size(find(result == Element_j(Element_j_index)),1)/row;
    HResult = HResult + P_j * log2(P_j + eps);
end
HResult = -HResult;

for Element_i_index = 1:size(Element_i,1)
    for Element_j_index = 1:size(Element_j,1)
        F_i = find(label == Element_i(Element_i_index));
        F_j = find(result == Element_j(Element_j_index));
        P_i = size(find(label == Element_i(Element_i_index)),1)/row;        %   ������ڶ�Ӧ����ֵ����Element_i(Element_i_index)��Ԫ�صĸ���
        P_j = size(find(result == Element_j(Element_j_index)),1)/row;       %   ������ڶ�Ӧ����ֵ����Element_i(Element_i_index)��Ԫ�صĸ���
        Temp_i_j = intersect(F_i,F_j);                                       %  ��Temp_i�Ļ������ҳ�ֵΪElement_j(Element_j_index)��Ԫ��
        P_i_j = size(Temp_i_j,1)/row;
        if P_i_j == 0           %   û�н���ʱ������ϢΪ��
            I = I;
        else                    %   �н���ʱ�����ݻ���Ϣ��ʾ���м���
            I = I + P_i_j * log2(P_i_j/(P_i*P_j));
        end
    end
end

v = 2 * I / (HLabel + HResult);
end