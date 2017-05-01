function [ DistanceMatrix ] = CADOImprove( Data ,alpha )

%   Author: wenjie
%   Data:   2017-1-15
%   ���ܣ�������������ݼ�Data�ж����ľ���,�����CADO�㷨���������Weight���CADO�㷨�е�1/(col-1)
%   ������������������ݼ�Data
%   ����������������

global TotalWeight;

[row,col] = size(Data);

for i = 1:row
    for j = i:row
        CADO = 0;
        TotalWeight = 0;
        for attribute_index = 1:col
            IaASV = IaASV(Data,i,j,attribute_index);
            IeASV = IeASV(Data,i,j,attribute_index);
            CASV = alpha * IaASV + (1 - alpha) * IeASV;
            CADO = CADO + CASV;
        end
        CADO = CADO / TotalWeight;
        DistanceMatrix(i,j) = CADO;
        DistanceMatrix(j,i) = CADO;
    end
end
end

function IntraCoupledDissimilarityValue = IaASV(Data,Object_i,Object_j,attribute)

%   Author: wenjie
%   Data:   2017-1-15
%   ���ܣ�������������ݼ�Data����������Object_i,Object_j������attribute�ϵ������ϵ��
%   ������������ݼ�Data,������Object_i,������Object_j,������attribute
%   �����������������Object_i��Object_j��������attribute�������ϵ��

global TotalWeight;
global ps;
global pf;
[row,col] = size(Data);
a = size(find(Data(:,attribute) == Data(Object_i,attribute)),1);
b = size(find(Data(:,attribute) == Data(Object_j,attribute)),1);

if Data(Object_i,attribute) ==  Data(Object_j,attribute)
    weight = ps(attribute);
    IntraCoupledSimilarityValue = 1;
    IntraCoupledDissimilarityValue = 1/IntraCoupledSimilarityValue -1;     %   ��������
    IntraCoupledDissimilarityValue = IntraCoupledDissimilarityValue * weight;
else
    weight = pf(attribute);
    IntraCoupledSimilarityValue = 1/(1 + log2(row^2/a) * log2(row^2/b));
    IntraCoupledDissimilarityValue = 1/IntraCoupledSimilarityValue -1;     %   ��������
    IntraCoupledDissimilarityValue = IntraCoupledDissimilarityValue * weight;
end
TotalWeight = TotalWeight + weight;
end

function InterCoupledDissimilarityValue = IeASV(Data,Object_i,Object_j,attribute)

%   Author: wenjie
%   Data:   2017-1-15
%   ���ܣ�������������ݼ�Data����������Object_i,Object_j������attribute�ϵ��໥���ϵ��
%   ������������ݼ�Data,������Object_i,������Object_j,������attribute
%   �����������������Object_i��Object_j��������attribute���໥���ϵ��
global weight;
[row,col] = size(Data);

%   ����Object_i���ڵ�������
[i_row,i_col] = find(Data(:,attribute) == Data(Object_i,attribute));
%   ����Object_j���ڵ�������
[j_row,i_col] = find(Data(:,attribute) == Data(Object_j,attribute));

InterCoupledSimilarityValue = 0;
for j = 1:col
    IRSI = 0;
    if j ~= attribute
        %   �ҵ����������ڷǱ��������ϵĽ���
        inter_set = intersect(Data(i_row,j),Data(j_row,j));
        if ~isempty(inter_set)
            for k = 1:size(inter_set,1)
                Object_i_ICP = size(find(Data(i_row,j)==inter_set(k)),1)/size(i_row,1);
                Object_j_ICP = size(find(Data(j_row,j)==inter_set(k)),1)/size(j_row,1);
                IRSI = IRSI + min(Object_i_ICP,Object_j_ICP);
            end
        end
        InterCoupledSimilarityValue = InterCoupledSimilarityValue + weight(j,attribute)*IRSI;     %   �໥���������
    end
end
InterCoupledDissimilarityValue = 1 - InterCoupledSimilarityValue;                     %   �໥��ϲ�������
if abs(InterCoupledDissimilarityValue) < 1*10^(-16)
    InterCoupledDissimilarityValue = 0;
end

end


