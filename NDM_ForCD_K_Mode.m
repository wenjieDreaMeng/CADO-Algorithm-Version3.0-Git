function [ categoryid ] = NDM_ForCD_K_Mode(Data,K)

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
%   Make this different to get the loop started.
ClusterCenters_i = Data(InitialCenters,[1:d-1]);

while 1 == 1
    %   ����ÿ�����ݵ��������ĵľ���
    for i = 1:n
        Dist = Distance_of_Categorical(Data(:,[1:d-1]),i,InitialCenters);   %  ������������֮��ľ��뺯��
        [m,ind] = min(Dist(:,2));                                           %   ����ǰ����������categoryid��
        categoryid(i) = ind;
    end
    
    ClusterCenters_j = ClusterCenters_i;
    for i = 1:K
        %   �ҵ�ÿһ����������ݣ��������ǵ�Mode����Ϊ�´μ���ľ�������K-mode�㷨
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

[row,col] = size(Data);
[a,n] = size(InitialCenters);
dataset = [];
global weight;
global ps;
global pf;

for k = 1:n
    Dist = 0;
    d = 0;
    w = 0;
    for i = 1:col
        if Data(Object_i,i) ~= Data(InitialCenters(k),i)
            for j = 1 : col
                [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Object_i,i)));      %  �ҳ���i��ΪData(Xi,i)��Ԫ��
                Temp_i_j = find(Data(i_row,j) == Data(Object_i,j));                           %  �ҳ�ͬʱ��j��ΪData(Xi,j)��Ԫ��
                P_i = size(Temp_i_j,1)/row;
                P_i_No = (size(Temp_i_j,1) - 1)/(row - 1);
                
                [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(InitialCenters(k),i)));      %  �ҳ���i��ΪData(Xi,i)��Ԫ��
                Temp_i_j = find(Data(i_row,j) == Data(InitialCenters(k),j));                           %  �ҳ�ͬʱ��j��ΪData(Xi,j)��Ԫ��
                P_j = size(Temp_i_j,1)/row;
                P_j_No = (size(Temp_i_j,1) - 1)/(row - 1);
                d = d + weight(i,j) * (P_i * P_i_No + P_j * P_j_No);
            end
            wr = pf(i);
        else
            for j = 1 : col
                [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Object_i,i)));      %  �ҳ���i��ΪData(Xi,i)��Ԫ��
                Temp_i_j = find(Data(i_row,j) == Data(Object_i,j));                           %  �ҳ�ͬʱ��j��ΪData(Xi,j)��Ԫ��
                P_i = size(Temp_i_j,1)/row;
                P_i_No = (size(Temp_i_j,1) - 1)/(row - 1);
                
                [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(InitialCenters(k),i)));      %  �ҳ���i��ΪData(Xi,i)��Ԫ��
                Temp_i_j = find(Data(i_row,j) == Data(InitialCenters(k),j));                           %  �ҳ�ͬʱ��j��ΪData(Xi,j)��Ԫ��
                P_j = size(Temp_i_j,1)/row;
                P_j_No = (size(Temp_i_j,1) - 1)/(row - 1);
                d = d + weight(i,j) * delta(Data(Object_i,j),Data(InitialCenters(k),j)) * (P_i * P_i_No + P_j * P_j_No);
            end
            wr = ps(i);
        end
        w = w + wr;
        Dist = Dist + wr*d;
    end
    Dist = Dist / w;
    dataset = cat(1,dataset, [k,Dist]);
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
    ColumnValue = unique(Data(:,i));        % �õ�ÿһ���в�ͬ������ֵ
    [Colrow, ColCol] = size(ColumnValue) ;  % �õ���ǰ����ֵ��ά��
    ColumnValueSum = 0;                     % ��ʾ��j������ֵ�ڵ�i�г��ֵĴ���
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

function [ delta ] = delta( Xi , Xj )

%   Function:   �ú������ͬһ������������ֵ���Ȩ��ֵ
%   Input:      �������Xi,Xj
%   Output:     ��������֮���deltaֵ

if Xi ~= Xj
    delta = 1;
else
    delta = 0;
end

end
