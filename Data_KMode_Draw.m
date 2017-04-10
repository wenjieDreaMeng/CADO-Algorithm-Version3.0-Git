function Data_KMode_Draw(Data,K)

%   Author WenJie
%   Modify Date 2016-09-29
%   该函数通过K-Mode算法聚类分析并画图，Data为数据集，K表示分类个数，InitialCenters表示初始聚类中心

[row,column]=size(Data);
number = row;                       % 向量个数
DistanceMatrix = zeros(row+K,row+K);
% InitialCenters为随机产生的起始中心
InitialCenters = randperm(row);
InitialCenters = InitialCenters(1:K);
ni = Data(InitialCenters,[1:column-1]);        % ni表示中心
categoryid = zeros(1,row);

while 1 == 1
    %计算每个数据到聚类中心的距离
    for i = 1:row
        dist = Distance_of_Categorical(repmat(Data(i,[1:column-1]),K,1),ni);% 调用两个对象之间的距离函数
        [m,ind] = min(dist(:,2)); % 将当前聚类结果存入categoryid中
        categoryid(i) = ind;
    end

    nj=ni; 
    for i = 1:K
        %找到每一类的所有数据，计算他们的Mode，作为下次计算的聚类中心 K-mode算法
        ind = find(categoryid == i);
        if ~isempty(ind)
            ni(i,:) = Find_Mode(Data(ind,[1:column-1]));
        end
    end

    if ni == nj
        break 
    end
end

% 计算任意对象间的距离
Data = Data(:,[1:column-1]);
Data = [Data;ni];
[row,column]=size(Data);
for i = 1:row                % i指向第一组数据的行
    for m = i+1:row          % j指向第二组数据的行
        Distance=0;
      	for j= 1:column
            if Data(i,j)~=Data(m,j)
                Distance=Distance+1;  
                end;
            end;
        DistanceMatrix(i,m) = Distance;
        DistanceMatrix(m,i) = Distance;
    end
end;
  
% 显示距离矩阵
% DistanceMatrix
% 画图
[y2,stress]= mdscale(DistanceMatrix,2,'criterion','metricsstress');
hold off;       %先清楚点原先figure中的图像
plot(1,1);

for i=1:size(DistanceMatrix)
    if i <= number
        switch categoryid(i)
            case 1
                plot(y2(i,1),y2(i,2),'.b','MarkerSize',15); 
            case 2
                plot(y2(i,1),y2(i,2),'.g','MarkerSize',15); 
            case 3
                plot(y2(i,1),y2(i,2),'.k','MarkerSize',15);
            case 4
                plot(y2(i,1),y2(i,2),'.y','MarkerSize',15);
            case 5
                plot(y2(i,1),y2(i,2),'.m','MarkerSize',15);
            case 6
                plot(y2(i,1),y2(i,2),'.r','MarkerSize',15);
            otherwise
                plot(y2(i,1),y2(i,2),'.c','MarkerSize',15);
        end
    else
        plot(y2(i,1),y2(i,2),'*r','MarkerSize',10); 
    end
    title('K-Mode聚类结果图');
    hold on;
end;

end
