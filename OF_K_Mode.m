function [ categoryid ] = OF_K_Mode(Data,K)

% Author WenJie
% Modify Date 2017-04-11
% ����˵�� ��Data Ϊ��������ݼ���KΪҪ�����ĸ���
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
        %   �ҵ�ÿһ����������ݣ��������ǵ�Mode����Ϊ�´μ���ľ������� K-mode�㷨
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
    TotaldisSimilarity = 0;
    for attribute_index = 1:column
        a = size(find(Data(:,attribute_index) == Data(Object_i,attribute_index)),1);
        b = size(find(Data(:,attribute_index) == Data(InitialCenters(j),attribute_index)),1);
        %   ��ֵͬʱ���ƶ�Ϊ1,��ֵͬΪ 1/(1 + log2(row^2/a) + log2(row^2/b));
        if Data(Object_i,attribute_index) ==  Data(InitialCenters(j),attribute_index)
            disSimilarity = 0;
        else
            disSimilarity = 1 - 1/[1 + log2(row^2/a)*log2(row^2/b)];
        end
        TotaldisSimilarity = TotaldisSimilarity + disSimilarity;
    end
    dataset = cat(1,dataset, [j,TotaldisSimilarity]);
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
