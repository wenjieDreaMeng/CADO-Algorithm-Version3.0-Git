function C = NormalizedSC(W, k)

%   Author WenJie
%   Modify Date 2016-09-29
%   �ú���ʵ�ֶԾ���ļ��ɣ��׾����㷨
%   �������DataΪ��֮�����ľ���k��ʾ������ĸ���,a�����˹�˺����Ĳ���

[n,m] = size(W);
s = sum(W);
D = full(sparse(1:n, 1:n, s));
E = D^(-1/2)*W*D^(-1/2);
[Q, V] = eigs(E, k);
C = kmeans(Q, k);

end