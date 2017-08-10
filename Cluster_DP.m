function [cl] = Cluster_DP(Data,dist,ClusterNum)

%   doc��       Clustering by fast search and find of density peaks
%   Modify:     2017.2.21
%   Author:     wenjie

global fid;
isShowPicture = 0;          %   �Ƿ���Ҫ��ʾ����ͼ��0��ʾ����ʾ��1��ʾ��ʾ����ͼ
isChange = 0;               %   �Ƿ�����µ��ܶȶ��庯��

%   ������ĶԳƵ�������ת��Ϊ��һ��Ϊi,�ڶ���Ϊj��������Ϊd��ij������ʽ
xx = [];
[row,col] = size(dist);
for i = 1:row
    for j = i+1:col;
        xx = [xx;[i,j,dist(i,j)]];
    end
end

ND = max(xx(:,2));                      %   ��������
NL = max(xx(:,1));
if NL > ND
    ND = NL;
end
N = size(xx,1);                         %   ��¼������
percent = 2.0;                          %   dc��ѡ��,�����е�����ռ�����ܵ������ı���Ϊ1%~2%
position = round( N * percent / 100);   %   round����Ϊ�ͽ�ȡ������
sda = sort(xx(:,3));                    %   sort�������жԾ�������
if position == 0
    clc;
    fprintf('The Variable percent is not legal\n');
end
dc = sda(position);                     %   ����ռ�Ƚ��ж�dcȡֵ

%   ѡ�ú˺���ʱ�����������ļ�¼������ѡ��С��20����¼ʱ�����ø�˹�˺�����������ýضϺ˺���
if isChange == 0
    for i = 1:ND
        rho(i) = 0.;
    end
    %   �ضϺ˺�������������Ŀ�Ƚ϶��ʱ�򣬲��ýضϺ�����
    %   "Cut off" kernel
    for i = 1:ND-1
        for j = i+1:ND
            if (dist(i,j) > dc)
                rho(i) = rho(i) + 1.;
                rho(j) = rho(j) + 1.;
            end
        end
    end
else
    rho = CAOSampleDensity(Data);
end 

maxd = max(max(dist));              %   �ܶ����ĵ㣬����max(dij)��Ϊ��õ��deltaֵ
nneigh = zeros(1,row);

[rho_sorted,ordrho] = sort(rho,'descend');
delta(ordrho(1)) = -1.;             %   �ܶ����ĵ㣬deltaֵ��Ϊ-1
nneigh(ordrho(1)) = 0;

%   ���ÿ�����ݽڵ��deltaֵ����������ܶȵ����С����
for i = 2:ND
    delta(ordrho(i)) = maxd;
    for j = 1:i-1
        if(dist(ordrho(i),ordrho(j)) < delta(ordrho(i)))
            delta(ordrho(i)) = dist(ordrho(i),ordrho(j));
            %   nneigh�������ÿ�����ݽڵ�ľ�������ܶȵ�ı��
            nneigh(ordrho(i)) = ordrho(j);
        end
    end
end
delta(ordrho(1)) = max(delta(:));

if isShowPicture == 1
    scrsz = get(0,'ScreenSize');
    figure('Position',[0 0 scrsz(3) scrsz(4)]);
end

for i=1:ND
    gamma(i) = rho(i) * delta(i);             %   ���ÿһ�����rho��delta�ĳ˻�,���մӴ�С���ɵõ��������ĵ�
end

if isShowPicture == 1
    %   ��ͼ����Decision Graphͼ
    subplot(2,1,1);
    plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
    title ('Decision Graph','FontSize',15.0)
    xlabel ('\rho')
    ylabel ('\delta')
end

%   ordrho��¼��rho_sorted�ڶ�Ӧ��gamma�е�����
[rho_sorted,ordrho] = sort(gamma,'descend');
%   ClusterCenterInd��¼��gamma��ǰClusterNum����Ϊ�������ĵ�����
ClusterCenterInd = ordrho([1:ClusterNum]);

%   cl��ע����������Ϊ�ڼ����������ĵ�,-1Ϊ�Ǿ������ĵ�
for i = 1:ND
    if ismember(i,ClusterCenterInd) == 0        %   ��i����ClusterCenterInd�е�Ԫ��ʱ
        cl(i) = -1;
    else
        cl(i) = find(i == ClusterCenterInd);    %   ��i��ClusterCenterInd�е�Ԫ��ʱ,��¼���ǵڼ�����������
    end
end

%   ���¾������ĵ���������,��i���������ĵ�ΪԴ�����еĵڼ�������
for i = 1:ClusterNum
    icl(i) = ClusterCenterInd(i);
end

%   ���ݴ��ݹ����ҵ�ÿһ���Ǿ������ĵ��������ڵľ�������
while ismember(-1,cl) == 1
    for i = 1:ND
        if cl(ordrho(i)) == -1
            cl(ordrho(i))=cl(nneigh(ordrho(i)));
        end
    end
end

for i = 1:ClusterNum
    nc = 0;
    nh = 0;
    for j = 1:ND
        %   nc��ʾ��i�����������������������Cluster Core������������Clister Hole�е�����������
        if (cl(j)==i)
            nc = nc + 1;
        end
    end
end

if isShowPicture == 1
    %   ��Decision Graph�л����������ĵ㣬��ɫ����
    cmap = colormap;
    for i = 1:ClusterNum
        ic = int8((i*64.)/(ClusterNum*1.));
        subplot(2,1,1)
        hold on
        plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',5,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    end
end

if isShowPicture == 1
    subplot(2,1,2)
end
Y1 = mdscale(dist, 2, 'criterion','metricsstress');
if isShowPicture == 1
    plot(Y1(:,1),Y1(:,2),'o','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k');
    title ('2D Nonclassical multidimensional scaling','FontSize',15.0)
    xlabel ('X')
    ylabel ('Y')
end

for i = 1:ND
    A(i,1) = 0.;
    A(i,2) = 0.;
end
for i = 1:ClusterNum
    nn = 0;
    ic = int8((i*64.)/(ClusterNum*1.));
    for j = 1:ND
    end
    if isShowPicture == 1
        hold on
        plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    end
end


end

