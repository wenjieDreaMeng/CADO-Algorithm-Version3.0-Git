function C = SpectralClustering(Data, k, a)  

%   Author WenJie
%   Modify Date 2016-09-29
%   �ú���ʵ�ֶԾ���ļ��ɣ��׾����㷨 
%   �������DataΪ��֮�����ľ���k��ʾ������ĸ���,a�����˹�˺����Ĳ���

d = pdist(Data); 
d2 = squareform(d);
d3 = d2.^2;
W(:,:) = exp(-d3(:,:)/(2*a^2));   % �ø�˹�˺�����Ҳ�ƾ���������ˣ��������ƶȣ�����Խ�󣬴��������ƶ�ԽС
[n,m] = size(W);  
s = sum(W);
D = full(sparse(1:n,1:n,s));
E = D^(-1/2)*W*D^(-1/2);           % ��һ��������˹���� 
[X,B] = eig(E);                    % �����һ��֮�������ֵ����������
[Q,V] = eigs(E,k);                 % ѡ����ǰK���������ֵ��Ӧ����������
C = kmeans(Q,k);                   % ������������K-Means������


end 

