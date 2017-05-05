function main( )

%   Author: wenjie
%   Data:   2017-3-3

clc;
global weight;
global Entropy;
global ps;
global pf;

FileName = 'Hayes-Roth Data Set';
TheoryCluster = 3;

Data = csvread(strcat(strcat('E:\Matlab_Projects\�������ݼ�\���������ݼ�\',FileName),'.csv'));         %   �����ܵ����ݼ�
Times = 100;                  %   ��������
fid = fopen(strcat('E:\Matlab_Projects\CADO�㷨�Ľ� Version3.0\ʵ���������\',strcat(FileName,'.txt')), 'w');

[row,col] = size(Data);
weight = WeightBetweenAttribute(Data(:,[1:col-1]));
[ps,pf] = WeightInAttribute(Data(:,[1:col-1]));
Entropy = EntropyCalculate(Data(:,[1:col-1]));

CADO_SC_AC = 0;
CADO_KMode_AC = 0;
CADO_SC_NMI = 0;
CADO_KMode_NMI = 0;
CADO_SC_ARI = 0;
CADO_KMode_ARI = 0;

OF_SC_AC = 0;
OF_KMode_AC = 0;
OF_SC_NMI = 0;
OF_KMode_NMI = 0;
OF_SC_ARI = 0;
OF_KMode_ARI = 0;

NDM_ForCD_SC_AC = 0;
NDM_ForCD_KMode_AC = 0;
NDM_ForCD_SC_NMI = 0;
NDM_ForCD_KMode_NMI = 0;
NDM_ForCD_SC_ARI = 0;
NDM_ForCD_KMode_ARI = 0;

% for i = 1:Times
%     %    ��ȥ���һ�����ǩ,ʹ�����ƶ���������ľ���
%     Dist = CADO(Data(:,[1:col-1]));
%     %   ����Normalized�׾����㷨���о��࣬������ȷ��
%     categoryid = NormalizedSC(Dist,TheoryCluster);
%     [CADO_NormalizedSC_AC,CADO_NormalizedSC_PR,CADO_NormalizedSC_RE,CADO_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
%     CADO_SC_AC = CADO_SC_AC + CADO_NormalizedSC_AC;
%     [CADO_NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
%     CADO_SC_NMI = CADO_SC_NMI + CADO_NormalizedSC_NMI;
%     [CADO_NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
%     CADO_SC_ARI = CADO_SC_ARI + CADO_NormalizedSC_ARI;
%     
%     %   ����KMode�����㷨���о��࣬������ȷ��
%     categoryid = CADO_K_Mode(Data,TheoryCluster);
%     [CADO_K_Mode_AC,CADO_K_Mode_PR,CADO_K_Mode_RE,CADO_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
%     CADO_KMode_AC = CADO_KMode_AC + CADO_K_Mode_AC;
%     [CADO_K_Mode_NMI] = NMI(categoryid,Data(:,col));
%     CADO_KMode_NMI = CADO_KMode_NMI + CADO_K_Mode_NMI;
%     [CADO_K_Mode_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
%     CADO_KMode_ARI = CADO_KMode_ARI + CADO_K_Mode_ARI;
%     
%     %    ��ȥ���һ�����ǩ,ʹ�����ƶ���������ľ���
%     Dist = OF(Data(:,[1:col-1]));
%     %   ����Normalized�׾����㷨���о��࣬������ȷ��
%     categoryid = NormalizedSC(Dist,TheoryCluster);
%     [OF_NormalizedSC_AC,OF_NormalizedSC_PR,OF_NormalizedSC_RE,OF_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
%     OF_SC_AC = OF_SC_AC + OF_NormalizedSC_AC;
%     [OF_NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
%     OF_SC_NMI = OF_SC_NMI + OF_NormalizedSC_NMI;
%     [OF_NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
%     OF_SC_ARI = OF_SC_ARI + OF_NormalizedSC_ARI;
%     
%     %   ����KMode�����㷨���о��࣬������ȷ��
%     categoryid = OF_K_Mode(Data,TheoryCluster);
%     [OF_K_Mode_AC,OF_K_Mode_PR,OF_K_Mode_RE,OF_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
%     OF_KMode_AC = OF_KMode_AC + OF_K_Mode_AC;
%     [OF_K_Mode_NMI] = NMI(categoryid,Data(:,col));
%     OF_KMode_NMI = OF_KMode_NMI + OF_K_Mode_NMI;
%     [OF_K_Mode_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
%     OF_KMode_ARI = OF_KMode_ARI + OF_K_Mode_ARI;
%     
%     %    ��ȥ���һ�����ǩ,ʹ�����ƶ���������ľ���
%     Dist = NDM_ForCD(Data(:,[1:col-1]));
%     %   ����Normalized�׾����㷨���о��࣬������ȷ��
%     categoryid = NormalizedSC(Dist,TheoryCluster);
%     [NDM_ForCD_NormalizedSC_AC,NDM_ForCD_NormalizedSC_PR,NDM_ForCD_NormalizedSC_RE,NDM_ForCD_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
%     NDM_ForCD_SC_AC = NDM_ForCD_SC_AC + NDM_ForCD_NormalizedSC_AC;
%     [NDM_ForCD_NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
%     NDM_ForCD_SC_NMI = NDM_ForCD_SC_NMI + NDM_ForCD_NormalizedSC_NMI;
%     [NDM_ForCD_NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
%     NDM_ForCD_SC_ARI = NDM_ForCD_SC_ARI + NDM_ForCD_NormalizedSC_ARI;
%     
%     %   ����KMode�����㷨���о��࣬������ȷ��
%     categoryid = NDM_ForCD_K_Mode(Data,TheoryCluster);
%     [NDM_ForCD_K_Mode_AC,NDM_ForCD_K_Mode_PR,NDM_ForCD_K_Mode_RE,NDM_ForCD_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
%     NDM_ForCD_KMode_AC = NDM_ForCD_KMode_AC + NDM_ForCD_K_Mode_AC;
%     [NDM_ForCD_K_Mode_NMI] = NMI(categoryid,Data(:,col));
%     NDM_ForCD_KMode_NMI = NDM_ForCD_KMode_NMI + NDM_ForCD_K_Mode_NMI;
%     [NDM_ForCD_K_Mode_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
%     NDM_ForCD_KMode_ARI = NDM_ForCD_KMode_ARI + NDM_ForCD_K_Mode_ARI;
% end
% fprintf(fid,'CADO SC_Average_AC =     %8.4f,        NDM_ForCD SC_Average_AC = %8.4f         OF SC_Average_AC = %8.4f\n',CADO_SC_AC/Times,NDM_ForCD_SC_AC/Times,OF_SC_AC/Times);
% fprintf(fid,'CADO KMode_Average_AC =  %8.4f,     NDM_ForCD KMode_Average_AC = %8.4f      OF KMode_Average_AC = %8.4f\n',CADO_KMode_AC/Times,NDM_ForCD_KMode_AC/Times,OF_KMode_AC/Times);
% fprintf(fid,'CADO SC_Average_NMI =    %8.4f,       NDM_ForCD SC_Average_NMI = %8.4f        OF SC_Average_NMI = %8.4f\n',CADO_SC_NMI/Times,NDM_ForCD_SC_NMI/Times,OF_SC_NMI/Times);
% fprintf(fid,'CADO KMode_Average_NMI = %8.4f,    NDM_ForCD KMode_Average_NMI = %8.4f     OF KMode_Average_NMI = %8.4f\n',CADO_KMode_NMI/Times,NDM_ForCD_KMode_NMI/Times,OF_KMode_NMI/Times);
% fprintf(fid,'CADO SC_Average_ARI =    %8.4f,       NDM_ForCD SC_Average_ARI = %8.4f        OF SC_Average_ARI = %8.4f\n',CADO_SC_ARI/Times,NDM_ForCD_SC_ARI/Times,OF_SC_ARI/Times);
% fprintf(fid,'CADO KMode_Average_ARI = %8.4f,    NDM_ForCD KMode_Average_ARI = %8.4f     OF KMode_Average_ARI = %8.4f\n',CADO_KMode_ARI/Times,NDM_ForCD_KMode_ARI/Times,OF_KMode_ARI/Times);

for alpha = 0.1:0.1:0.9
    fprintf(fid,'alpha = %3.1f\n', alpha);
    CADOImprove_SC_AC = 0;
    CADOImprove_KMode_AC = 0;
    CADOImprove_SC_NMI = 0;
    CADOImprove_KMode_NMI = 0;
    CADOImprove_SC_ARI = 0;
    CADOImprove_KMode_ARI = 0;
    for i = 1:Times
        %   ��ȥ���һ�����ǩ,ʹ���µĶ�����׼��������ľ���
        Dist = CADOImprove(Data(:,[1:col-1]),alpha);
        %       ����Normalized�׾����㷨���о��࣬������ȷ��
        categoryid = NormalizedSC(Dist,TheoryCluster);
        [CADOImprove_NormalizedSC_AC,CADOImprove_NormalizedSC_PR,CADOImprove_NormalizedSC_RE,CADOImprove_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
        CADOImprove_SC_AC =  CADOImprove_SC_AC + CADOImprove_NormalizedSC_AC;
        [CADOImprove_NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
        CADOImprove_SC_NMI = CADOImprove_SC_NMI + CADOImprove_NormalizedSC_NMI;
        [CADOImprove_NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
        CADOImprove_SC_ARI = CADOImprove_SC_ARI + CADOImprove_NormalizedSC_ARI;
        
        %   ����KMode�����㷨���о��࣬������ȷ��
        categoryid = CADOImprove_K_Mode(Data,TheoryCluster,alpha);
        [CADOImprove_K_Mode_AC,CADOImprove_K_Mode_PR,CADOImprove_K_Mode_RE,CADOImprove_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
        CADOImprove_KMode_AC = CADOImprove_KMode_AC + CADOImprove_K_Mode_AC;
        [CADOImprove_K_Mode_NMI] = NMI(categoryid,Data(:,col));
        CADOImprove_KMode_NMI = CADOImprove_KMode_NMI + CADOImprove_K_Mode_NMI;
        [CADOImprove_K_Mode_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
        CADOImprove_KMode_ARI = CADOImprove_KMode_ARI + CADOImprove_K_Mode_ARI;
    end
    fprintf(fid,'CADOImprove SC_AC =  %8.4f,  CADOImprove KMode_AC =  %8.4f\n',CADOImprove_SC_AC/Times,CADOImprove_KMode_AC/Times);
    fprintf(fid,'CADOImprove SC_NMI = %8.4f,  CADOImprove KMode_NMI = %8.4f\n',CADOImprove_SC_NMI/Times,CADOImprove_KMode_NMI/Times);
    fprintf(fid,'CADOImprove SC_ARI = %8.4f,  CADOImprove KMode_ARI = %8.4f\n',CADOImprove_SC_ARI/Times,CADOImprove_KMode_ARI/Times);
end
fclose(fid);
fprintf('Job Has Finished!\n');
end

