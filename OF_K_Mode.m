function [ categoryid ] = OF_K_Mode(Data,K)

% Author WenJie
% Modify Date 2017-04-11
% 参数说明 ：Data 为输入的数据集，K为要求聚类的个数
% Function :实现子文件的K-mode算法，模仿K-means算法,返回样本标签

[n,d] = size(Data);
% 设置categoryid为分类结果的记录，表示向量所属的类
categoryid = zeros(1,n);

% InitialCenters为随机产生的起始中心
InitialCenters = randperm(n);
InitialCenters = InitialCenters(1:K);
% Make this different to get the loop started.
ClusterCenters_i = Data(InitialCenters,[1:d-1]);

while 1 == 1
    %计算每个数据到聚类中心的距离
    for i = 1:n
        dist = Distance_of_Categorical(Data(:,[1:d-1]),i,InitialCenters);% 调用两个对象之间的距离函数
        [m,ind] = min(dist(:,2));                   % 将当前聚类结果存入categoryid中
        categoryid(i) = ind;
    end
    
    ClusterCenters_j = ClusterCenters_i;
    for i = 1:K
        %   找到每一类的所有数据，计算他们的Mode，作为下次计算的聚类中心 K-mode算法
        ind = find(categoryid == i);
        if ~isempty(ind)
            ClusterCenters_i(i,:) = Find_Mode(Data(ind,[1:d-1]));
        end
    end
    
    if ClusterCenters_i == ClusterCenters_j
        %     % 统计每一类的数据个数
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
% 计算两个具有相同的行列的矩阵中，相同行的距离

[row,column] = size(Data);
[a,n] = size(InitialCenters);
dataset = [];

for j = 1:n
    TotaldisSimilarity = 0;
    for attribute_index = 1:column
        a = size(find(Data(:,attribute_index) == Data(Object_i,attribute_index)),1);
        b = size(find(Data(:,attribute_index) == Data(InitialCenters(j),attribute_index)),1);
        %   相同值时相似度为1,不同值为 1/(1 + log2(row^2/a) + log2(row^2/b));
        if Data(Object_i,attribute_index) ==  Data(InitialCenters(j),attribute_index)
            disSimilarity = 0;
        else
            disSimilarity = 1 - 1/[1 + log2(row/a)*log2(row/b)];
        end
        TotaldisSimilarity = TotaldisSimilarity + disSimilarity;
    end
    dataset = cat(1,dataset, [j,TotaldisSimilarity]);
end
end


function [Mode] = Find_Mode(Data)

% Author Cfy
% Data 2008-02-13
% 参数说明 ：Data 为输入的数据集
% Function : 得到一个数据集合的mode

[row,column] = size(Data);
Mode = [];
for i=1:column
    ColumnValue = unique(Data(:,i));      % 得到每一列中不同的属性值
    [Colrow, ColCol] = size(ColumnValue) ;% 得到当前属性值得维数
    ColumnValueSum = 0;
    dataset = [];
    for j = 1:Colrow
        [Rowresult,Colresult] = size(find(Data(:,i)==ColumnValue(j,1)));
        %   ColumnValueSum = Rowresult;           % 表示第j个属性值在第i列出现的次数
        %   ColumnValue(j,2) = ColumnValueSum     % 得到每一个属性值出现的次数
        dataset = cat(1,dataset,[ColumnValue(j,1),Rowresult]);
    end
    [Maxrow,MaxValue] = max(dataset(:,2));
    Mode(1,i) = ColumnValue(MaxValue,1);
end
end
