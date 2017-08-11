function main( )

%   Author: wenjie
%   Data:   2017-3-3

clc;
clear;
global weight;
global ps;
global pf;
global fid;

<<<<<<< HEAD
FileName = 'Chess Data Set';
TheoryCluster = 2;
=======
FileName = 'Soybean-small Data Set';
TheoryCluster = 4;
>>>>>>> becc9ad7ceb734978f36b23d7f5f2224a314818f

%   ��־λ���Ƿ���Ҫ�������µ��㷨���ԣ�1��ʾ��Ҫ���ԣ�0��ʾ����Ҫ����
KM_Test = 0;
SC_Test = 0;
DP_Test = 1;

Data = csvread(strcat(strcat('D:\��������\Matlab Projects\�������ݼ�\���������ݼ�\',FileName),'.csv'));         %   �����ܵ����ݼ�
Times = 5;                  %   ��������
fid = fopen(strcat('D:\��������\Matlab Projects\CADO�㷨�Ľ� Version5.0\ʵ���������\',strcat(FileName,'.txt')), 'w');

[row,col] = size(Data);

SC_AC = 0;
SC_NMI = 0;
SC_ARI = 0;
SC_PR = 0;
SC_RE = 0;

KMode_AC = 0;
KMode_NMI = 0;
KMode_ARI = 0;
KMode_PR = 0;
KMode_RE = 0;

if KM_Test == 1
    %   ��ȥ���һ�����ǩ,ʹ���µĶ�����׼��������ľ���
    fprintf('KMode Algorithm Caculate Process......\n');
    fprintf(fid,'KMode Algorithm Results:\n');
    for i = 1:Times
        fprintf('%2d Times KMode Algorithm Caculate Process......\n',i);
        %   ����KMode�����㷨���о��࣬������ȷ��
        categoryid = WeightAPercentOfMCADO_KMode(Data,TheoryCluster);
        [K_Mode_AC,K_Mode_PR,K_Mode_RE,K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
        KMode_AC = KMode_AC + K_Mode_AC;
        KMode_PR = KMode_PR + K_Mode_PR;
        KMode_RE = KMode_RE + K_Mode_RE;
        
        [K_Mode_NMI] = NMI(categoryid,Data(:,col));
        KMode_NMI = KMode_NMI + K_Mode_NMI;
        
        [K_Mode_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
        KMode_ARI = KMode_ARI + K_Mode_ARI;
    end
    fprintf(fid,'Kmode_Average_AC  = %8.4f	  	Kmode_Average_NMI = %8.4f      Kmode_Average_ARI = %8.4f	  	',KMode_AC/Times,KMode_NMI/Times,KMode_ARI/Times);
    fprintf(fid,'Kmode_Average_PR = %8.4f       Kmode_Average_RE = %8.4f\n',KMode_PR/Times,KMode_RE/Times);
end


if SC_Test == 1 || DP_Test == 1
    fprintf('Dist Matrix Caculate Process......\n');
    Dist = SMS(Data(:,[1:col-1]));
    if SC_Test == 1
        weight = WeightBetweenAttribute(Data(:,[1:col-1]));
        [ps,pf] = WeightInAttribute(Data(:,[1:col-1]));
        fprintf(fid,'\nSpectralClustering Algorithm Results:\n');
        for i = 1:Times
            fprintf('%2d Times SpectralClustering Algorithm Caculate Process......\n',i);
            %       ����Normalized�׾����㷨���о��࣬������ȷ��
            categoryid = NormalizedSC(Dist,TheoryCluster);
            [NormalizedSC_AC,NormalizedSC_PR,NormalizedSC_RE,NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
            SC_AC =  SC_AC + NormalizedSC_AC;
            SC_PR = SC_PR + NormalizedSC_PR;
            SC_RE = SC_RE + NormalizedSC_RE;
            
            [NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
            SC_NMI = SC_NMI + NormalizedSC_NMI;
            
            [NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
            SC_ARI = SC_ARI + NormalizedSC_ARI;
        end
        fprintf(fid,'SC_Average_AC  = %8.4f		SC_Average_NMI = %8.4f      SC_Average_ARI = %8.4f	  	',SC_AC/Times,SC_NMI/Times,SC_ARI/Times);
        fprintf(fid,'SC_Average_PR = %8.4f      SC_Average_RE = %8.4f\n',SC_PR/Times,SC_RE/Times);
    end
    
    
    if DP_Test == 1
        fprintf(fid,'\nCluster_DP Algorithm Results:\n');
        fprintf('Cluster_DP Algorithm Caculate Process......\n');
        %       ����Normalized�׾����㷨���о��࣬������ȷ��
        categoryid = Cluster_DP(Data(:,[1:col-1]),Dist,TheoryCluster);
        [Cluster_DP_AC,Cluster_DP_PR,Cluster_DP_RE,Cluster_DP_CV] = AC_PR_RE(categoryid,Data(:,col));
        [Cluster_DP_NMI] = NMI(categoryid,Data(:,col));
        [Cluster_DP_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
        fprintf(fid,'DP_Average_AC  = %8.4f		DP_Average_NMI = %8.4f      DP_Average_ARI = %8.4f	  	',Cluster_DP_AC,Cluster_DP_NMI,Cluster_DP_ARI);
        fprintf(fid,'DP_Average_PR = %8.4f      DP_Average_RE = %8.4f\n',Cluster_DP_PR,Cluster_DP_RE);
    end
end

fclose(fid);
fprintf('Job Has Finished!\n');
end

