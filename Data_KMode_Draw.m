function Data_KMode_Draw(Data,K)

%   Author WenJie
%   Modify Date 2016-09-29
%   �ú���ͨ��K-Mode�㷨�����������ͼ��DataΪ���ݼ���K��ʾ���������InitialCenters��ʾ��ʼ��������

[row,column]=size(Data);
number = row;                       % ��������
DistanceMatrix = zeros(row+K,row+K);
% InitialCentersΪ�����������ʼ����
InitialCenters = randperm(row);
InitialCenters = InitialCenters(1:K);
ni = Data(InitialCenters,[1:column-1]);        % ni��ʾ����
categoryid = zeros(1,row);

while 1 == 1
    %����ÿ�����ݵ��������ĵľ���
    for i = 1:row
        dist = Distance_of_Categorical(repmat(Data(i,[1:column-1]),K,1),ni);% ������������֮��ľ��뺯��
        [m,ind] = min(dist(:,2)); % ����ǰ����������categoryid��
        categoryid(i) = ind;
    end

    nj=ni; 
    for i = 1:K
        %�ҵ�ÿһ����������ݣ��������ǵ�Mode����Ϊ�´μ���ľ������� K-mode�㷨
        ind = find(categoryid == i);
        if ~isempty(ind)
            ni(i,:) = Find_Mode(Data(ind,[1:column-1]));
        end
    end

    if ni == nj
        break 
    end
end

% ������������ľ���
Data = Data(:,[1:column-1]);
Data = [Data;ni];
[row,column]=size(Data);
for i = 1:row                % iָ���һ�����ݵ���
    for m = i+1:row          % jָ��ڶ������ݵ���
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
  
% ��ʾ�������
% DistanceMatrix
% ��ͼ
[y2,stress]= mdscale(DistanceMatrix,2,'criterion','metricsstress');
hold off;       %�������ԭ��figure�е�ͼ��
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
    title('K-Mode������ͼ');
    hold on;
end;

end
