function DistanceMatrix = CADOImprove( Data ,alpha )

%   Author: wenjie
%   Data:   2017-1-15
%   功能：计算分类型数据集Data中对象间的距离,相比于CADO算法，这里采用Weight替代CADO算法中的1/(col-1)
%   输入参数：分类型数据集Data
%   输出参数：距离矩阵

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
% fclose(fid);
end

function IntraCoupledDissimilarityValue = IaASV(Data,Object_i,Object_j,attribute)

%   Author: wenjie
%   Data:   2017-1-15
%   功能：计算分类型数据集Data中两个对象Object_i,Object_j在属性attribute上的内耦合系数
%   输入参数：数据集Data,对象编号Object_i,对象编号Object_j,属性列attribute
%   输出参数：两个对象Object_i和Object_j在属性列attribute的内耦合系数

global TotalWeight;
global ps;
global pf;
[row,col] = size(Data);
a = size(find(Data(:,attribute) == Data(Object_i,attribute)),1);
b = size(find(Data(:,attribute) == Data(Object_j,attribute)),1);

if Data(Object_i,attribute) ==  Data(Object_j,attribute)
    weight = ps(attribute);
    IntraCoupledSimilarityValue = 1;
    IntraCoupledSimilarityValue = IntraCoupledSimilarityValue * weight;
    IntraCoupledDissimilarityValue = 1/IntraCoupledSimilarityValue -1;     %   不相似性
else
    weight = pf(attribute);
    IntraCoupledSimilarityValue = 1/(1 + log2(row^2/a) + log2(row^2/b));
    IntraCoupledSimilarityValue = IntraCoupledSimilarityValue * weight;
    IntraCoupledDissimilarityValue = 1/IntraCoupledSimilarityValue -1;     %   不相似性
end
TotalWeight = TotalWeight + weight;
end

function InterCoupledDissimilarityValue = IeASV(Data,Object_i,Object_j,attribute)

%   Author: wenjie
%   Data:   2017-1-15
%   功能：计算分类型数据集Data中两个对象Object_i,Object_j在属性attribute上的相互耦合系数
%   输入参数：数据集Data,对象编号Object_i,对象编号Object_j,属性列attribute
%   输出参数：两个对象Object_i和Object_j在属性列attribute的相互耦合系数
global weight;
% global fid;
[row,col] = size(Data);

%   对象Object_i所在的行与列
[i_row,i_col] = ind2sub(size(Data),find(Data(:,attribute) == Data(Object_i,attribute)));
%   对象Object_j所在的行与列
[j_row,i_col] = ind2sub(size(Data),find(Data(:,attribute) == Data(Object_j,attribute)));

InterCoupledSimilarityValue = 0;
for j = 1:col
    IRSI = 0;
    if j ~= attribute
        %   找到两个对象在非本属性列上的交集
        inter_set = intersect(Data(i_row,j),Data(j_row,j));
        if ~isempty(inter_set)
            for k = 1:size(inter_set,1)
                Object_i_ICP = size(find(Data(i_row,j)==inter_set(k)),1)/size(i_row,1);
                Object_j_ICP = size(find(Data(j_row,j)==inter_set(k)),1)/size(j_row,1);
                IRSI = IRSI + min(Object_i_ICP,Object_j_ICP);
            end
        end
        InterCoupledSimilarityValue = InterCoupledSimilarityValue + weight(j,attribute)*IRSI;     %   相互耦合相似性
    end
end
InterCoupledDissimilarityValue = 1 - InterCoupledSimilarityValue;                     %   相互耦合不相似性
if abs(InterCoupledDissimilarityValue) < 1*10^(-16)
    InterCoupledDissimilarityValue = 0;
end

end


