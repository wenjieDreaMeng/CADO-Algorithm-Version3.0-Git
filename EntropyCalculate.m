function [ Entropy ] = EntropyCalculate( Data, i)

%   Function:   �ú������ÿһ������Ϊ�����Ȩ��ֵ
%   Input:      ���ݼ�Data
%   Output:     Ȩ�ؾ���
[row,col] = size(Data);

sum = 0;
Element = unique(Data(:,i));
for k = 1:size(Element,1)
    P = size(find(Data(:,i) == Element(k)),1)/row;
    sum = sum + P * log2(P);
end
Entropy = -sum;

end

