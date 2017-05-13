function [ categoryid ] = CADOImprove_K_Mode(Data,K)

% Author Cfy
% Date 2008-02-13
% Modify Date 2008-12-21
% Author WenJie
% Modify Date 2016-09-29
% ����˵�� ��Data Ϊ��������ݼ���InitialCenter�ǳ�ʼ��������,KΪҪ�����ĸ���
% Function :ʵ�����ļ���K-mode�㷨��ģ��K-means�㷨,����������ǩ

[n,d] = size(Data);
% ����categoryidΪ�������ļ�¼����ʾ������������
categoryid = zeros(1,n);

% InitialCentersΪ�����������ʼ����
InitialCenters = randperm(n);
InitialCenters = InitialCenters(1:K);
% Make this different to get the loop started.
ClusterCenters_i = Data(InitialCenters,[1:d-1]);

while 1 == 1
    %����ÿ�����ݵ��������ĵľ���
    for i = 1:n
        dist = Distance_of_Categorical(Data(:,[1:d-1]),i,InitialCenters);% ������������֮��ľ��뺯��
        [m,ind] = min(dist(:,2));                   % ����ǰ����������categoryid��
        categoryid(i) = ind;
    end
    
    ClusterCenters_j = ClusterCenters_i;
    for i = 1:K
        %�ҵ�ÿһ����������ݣ��������ǵ�Mode����Ϊ�´μ���ľ������� K-mode�㷨
        ind = find(categoryid == i);
        if ~isempty(ind)
            ClusterCenters_i(i,:) = Find_Mode(Data(ind,[1:d-1]));
        end
    end
    
    if ClusterCenters_i == ClusterCenters_j
        %     % ͳ��ÿһ������ݸ���
        %     for i = 1:K
        %         ind = find(categoryid == i+VectorIndex);
        %         CategoryLength = [CategoryLength,length(ind)];
        %     end
        break
    end
end

end

function [dataset]=Distance_of_Categorical(Data,Object_i,InitialCenters)

% Author Fuyuan Cao
% Data : 2008-02-13
% Function :
% ��������������ͬ�����еľ����У���ͬ�еľ���


[row,column] = size(Data);
[a,n] = size(InitialCenters);
dataset = [];
for j = 1:n
    CADO = 0;
    for attribute_index = 1:column
        IaASV = IaASV(Data,Object_i,InitialCenters(j),attribute_index);
        IeASV = IeASV(Data,Object_i,InitialCenters(j),attribute_index);
        CASV = IaASV * IeASV;
        CADO = CADO + CASV;
    end
    dataset = cat(1,dataset, [j,CADO]);
end
end


function [Mode] = Find_Mode(Data)

% Author Cfy
% Data 2008-02-13
% ����˵�� ��Data Ϊ��������ݼ�
% Function : �õ�һ�����ݼ��ϵ�mode

[row,column] = size(Data);
Mode = [];
for i=1:column
    ColumnValue = unique(Data(:,i));      % �õ�ÿһ���в�ͬ������ֵ
    [Colrow, ColCol] = size(ColumnValue) ;% �õ���ǰ����ֵ��ά��
    ColumnValueSum = 0;
    dataset = [];
    for j = 1:Colrow
        [Rowresult,Colresult] = size(find(Data(:,i)==ColumnValue(j,1)));
        %   ColumnValueSum = Rowresult;           % ��ʾ��j������ֵ�ڵ�i�г��ֵĴ���
        %   ColumnValue(j,2) = ColumnValueSum     % �õ�ÿһ������ֵ���ֵĴ���
        dataset = cat(1,dataset,[ColumnValue(j,1),Rowresult]);
    end
    [Maxrow,MaxValue] = max(dataset(:,2));
    Mode(1,i) = ColumnValue(MaxValue,1);
end
end

function IntraCoupledDissimilarityValue = IaASV(Data,Object_i,Object_j,attribute)

%   Author: wenjie
%   Data:   2017-1-15
%   ���ܣ�������������ݼ�Data����������Object_i,Object_j������attribute�ϵ������ϵ��
%   ������������ݼ�Data,������Object_i,������Object_j,������attribute
%   �����������������Object_i��Object_j��������attribute�������ϵ��

global Entropy;

[row,col] = size(Data);

a = size(find(Data(:,attribute) == Data(Object_i,attribute)),1);
b = size(find(Data(:,attribute) == Data(Object_j,attribute)),1);

% IntraCoupledSimilarityValue = (a*b)/(a+b+a*b);

if Data(Object_i,attribute) ==  Data(Object_j,attribute)
    IntraCoupledSimilarityValue = 1;
else
    IntraCoupledSimilarityValue = 1/(1 + log2(row^2/a) * log2(row^2/b));
end

% weight = Entropy(attribute);
IntraCoupledDissimilarityValue = 1/IntraCoupledSimilarityValue -1;          %   ��������
% IntraCoupledDissimilarityValue = IntraCoupledDissimilarityValue * weight;
end


function InterCoupledDissimilarityValue = IeASV(Data,Object_i,Object_j,attribute)

%   Author: wenjie
%   Data:   2017-1-15
%   ���ܣ�������������ݼ�Data����������Object_i,Object_j������attribute�ϵ��໥���ϵ��
%   ������������ݼ�Data,������Object_i,������Object_j,������attribute
%   �����������������Object_i��Object_j��������attribute���໥���ϵ��
global weight;
global fid;
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

if InterCoupledSimilarityValue == 0
    InterCoupledDissimilarityValue = 1;
else
    InterCoupledDissimilarityValue = 1/InterCoupledSimilarityValue - 1;
end

% InterCoupledDissimilarityValue = 1 - InterCoupledSimilarityValue;                     %   �໥��ϲ�������

end
