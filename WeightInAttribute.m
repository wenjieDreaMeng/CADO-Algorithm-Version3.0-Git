function [ps,pf] = WeightInAttribute(Data)

%   Function:   �ú������ÿһ��ȡֵ��Ȼ���ȡֵ���ȵĸ�����Ϊ���е�Ȩ��
%   Input:      ���ݼ�Data
%   Output:     Ȩ�ؾ���

ps = ProbabilitySameValue( Data );
pf = ProbabilityDifferent( Data );

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