function DistanceMatrix = CADOAddBiology( Data )

%   Author: wenjie
%   Data:   2017-1-15
%   ���ܣ�������������ݼ�Data�ж����ľ���,�����CADO�㷨���ڼ��������ʱ��������ֵ��ȣ�����ø�����Ϊ�����ԣ���ʹ��Ȩ��Weight
%   ������������������ݼ�Data
%   ����������������

[row,col] = size(Data);

for i = 1:row
    for j = i:row
        CADO = 0;
        for attribute_index = 1:col
            IaASV = IaASV(Data,i,j,attribute_index);
            IeASV = IeASV(Data,i,j,attribute_index);
            CASV = IaASV * IeASV;
            %             fprintf('i:%d  j:%d  col:%d  IaASV:%5.6f  IeASV:%5.6f  CASV:%5.6f\n', i,j,attribute_index,IaASV,IeASV,CASV);
            CADO = CADO + CASV;
        end
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

if Data(Object_i,attribute)~= Data(Object_j,attribute)
    a = size(find(Data(:,attribute) == Data(Object_i,attribute)),1);
    b = size(find(Data(:,attribute) == Data(Object_j,attribute)),1);
    
    IntraCoupledSimilarityValue = (a*b)/(a+b+a*b);                          %   �����������
else
    a = size(find(Data(:,attribute) == Data(Object_i,attribute)),1);
    IntraCoupledSimilarityValue = 1/a;
end
IntraCoupledDissimilarityValue = 1/IntraCoupledSimilarityValue - 1;     %   ��������
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
[i_row,i_col] = ind2sub(size(Data),find(Data(:,attribute) == Data(Object_i,attribute)));
%   ����Object_j���ڵ�������
[j_row,i_col] = ind2sub(size(Data),find(Data(:,attribute) == Data(Object_j,attribute)));

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
    end
    %     InterCoupledSimilarityValue = InterCoupledSimilarityValue + 1/(col-1)*IRSI;     %   �໥���������
    InterCoupledSimilarityValue = InterCoupledSimilarityValue + weight(j,attribute)*IRSI;     %   �໥���������
end

InterCoupledDissimilarityValue = 1-InterCoupledSimilarityValue;                     %   �໥��ϲ�������
if abs(InterCoupledDissimilarityValue) < 1*10^(-16)
    InterCoupledDissimilarityValue = 0;
end

end


