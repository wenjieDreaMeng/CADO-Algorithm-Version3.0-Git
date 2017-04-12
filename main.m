function main( )

%   Author: wenjie
%   Data:   2017-3-3

clc;
global weight;
global ps;
global pf;

Data = csvread('E:\Matlab_Projects\测试数据集\分类型数据集\Shuttle Landing Control Data Set.csv');         %   载入总的数据集
TheoryCluster = 2;
Times = 20;                  %   迭代次数
fid = fopen('Result.txt', 'w');


weight = WeightBetweenAttribute(Data);
[row,col] = size(Data);
[ps,pf] = WeightInAttribute(Data(:,[1:col-1]));

for i = 1:Times
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
    
    %    除去最后一列类标签,使用相似度求样本间的距离
    Dist = CADO(Data(:,[1:col-1]));
    %   采用Normalized谱聚类算法进行聚类，计算正确率
    categoryid = NormalizedSC(Dist,TheoryCluster);
    [CADO_NormalizedSC_AC,CADO_NormalizedSC_PR,CADO_NormalizedSC_RE,CADO_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
    CADO_SC_AC = CADO_SC_AC + CADO_NormalizedSC_AC;
    [CADO_NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
    CADO_SC_NMI = CADO_SC_NMI + CADO_NormalizedSC_NMI;
    [CADO_NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
    CADO_SC_ARI = CADO_SC_ARI + CADO_NormalizedSC_ARI;
    
    %   采用KMode聚类算法进行聚类，计算正确率
    categoryid = CADO_K_Mode(Data,TheoryCluster);
    [CADO_K_Mode_AC,CADO_K_Mode_PR,CADO_K_Mode_RE,CADO_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
    CADO_KMode_AC = CADO_KMode_AC + CADO_K_Mode_AC;
    [CADO_K_Mode_NMI] = NMI(categoryid,Data(:,col));
    CADO_KMode_NMI = CADO_KMode_NMI + CADO_K_Mode_NMI;
    [CADO_K_Mode_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
    CADO_KMode_ARI = CADO_KMode_ARI + CADO_K_Mode_ARI;
    
    %    除去最后一列类标签,使用相似度求样本间的距离
    Dist = OF(Data(:,[1:col-1]));
    %   采用Normalized谱聚类算法进行聚类，计算正确率
    categoryid = NormalizedSC(Dist,TheoryCluster);
    [OF_NormalizedSC_AC,OF_NormalizedSC_PR,OF_NormalizedSC_RE,OF_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
    OF_SC_AC = OF_SC_AC + OF_NormalizedSC_AC;
    [OF_NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
    OF_SC_NMI = OF_SC_NMI + OF_NormalizedSC_NMI;
    [OF_NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
    OF_SC_ARI = OF_SC_ARI + OF_NormalizedSC_ARI;
    
    %   采用KMode聚类算法进行聚类，计算正确率
    categoryid = OF_K_Mode(Data,TheoryCluster);
    [OF_K_Mode_AC,OF_K_Mode_PR,OF_K_Mode_RE,OF_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
    OF_KMode_AC = OF_KMode_AC + OF_K_Mode_AC;
    [OF_K_Mode_NMI] = NMI(categoryid,Data(:,col));
    OF_KMode_NMI = OF_KMode_NMI + OF_K_Mode_NMI;
    [OF_K_Mode_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
    OF_KMode_ARI = OF_KMode_ARI + OF_K_Mode_ARI;
    
    %    除去最后一列类标签,使用相似度求样本间的距离
    Dist = NDM_ForCD(Data(:,[1:col-1]));
    %   采用Normalized谱聚类算法进行聚类，计算正确率
    categoryid = NormalizedSC(Dist,TheoryCluster);
    [NDM_ForCD_NormalizedSC_AC,NDM_ForCD_NormalizedSC_PR,NDM_ForCD_NormalizedSC_RE,NDM_ForCD_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
    NDM_ForCD_SC_AC = NDM_ForCD_SC_AC + NDM_ForCD_NormalizedSC_AC;
    [NDM_ForCD_NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
    NDM_ForCD_SC_NMI = NDM_ForCD_SC_NMI + NDM_ForCD_NormalizedSC_NMI;
    [NDM_ForCD_NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
    NDM_ForCD_SC_ARI = NDM_ForCD_SC_ARI + NDM_ForCD_NormalizedSC_ARI;
    
    %   采用KMode聚类算法进行聚类，计算正确率
    categoryid = NDM_ForCD_K_Mode(Data,TheoryCluster);
    [NDM_ForCD_K_Mode_AC,NDM_ForCD_K_Mode_PR,NDM_ForCD_K_Mode_RE,NDM_ForCD_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
    NDM_ForCD_KMode_AC = NDM_ForCD_KMode_AC + NDM_ForCD_K_Mode_AC;
    [NDM_ForCD_K_Mode_NMI] = NMI(categoryid,Data(:,col));
    NDM_ForCD_KMode_NMI = NDM_ForCD_KMode_NMI + NDM_ForCD_K_Mode_NMI;
    [NDM_ForCD_K_Mode_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
    NDM_ForCD_KMode_ARI = NDM_ForCD_KMode_ARI + NDM_ForCD_K_Mode_ARI;
end
fprintf(fid,'CADO SC_Average_AC =     %8.4f,        NDM_ForCD SC_Average_AC = %8.4f         OF SC_Average_AC = %8.4f\n',CADO_SC_AC/Times,NDM_ForCD_SC_AC/Times,OF_SC_AC/Times);
fprintf(fid,'CADO KMode_Average_AC =  %8.4f,     NDM_ForCD KMode_Average_AC = %8.4f      OF KMode_Average_AC = %8.4f\n',CADO_KMode_AC/Times,NDM_ForCD_KMode_AC/Times,OF_KMode_AC/Times);
fprintf(fid,'CADO SC_Average_NMI =    %8.4f,       NDM_ForCD SC_Average_NMI = %8.4f        OF SC_Average_NMI = %8.4f\n',CADO_SC_NMI/Times,NDM_ForCD_SC_NMI/Times,OF_SC_NMI/Times);
fprintf(fid,'CADO KMode_Average_NMI = %8.4f,    NDM_ForCD KMode_Average_NMI = %8.4f     OF KMode_Average_NMI = %8.4f\n',CADO_KMode_NMI/Times,NDM_ForCD_KMode_NMI/Times,OF_KMode_NMI/Times);
fprintf(fid,'CADO SC_Average_RI =     %8.4f,        NDM_ForCD SC_Average_RI = %8.4f         OF SC_Average_RI = %8.4f\n',CADO_SC_ARI/Times,NDM_ForCD_SC_ARI/Times,OF_SC_ARI/Times);
fprintf(fid,'CADO KMode_Average_RI =  %8.4f,     NDM_ForCD KMode_Average_RI = %8.4f      OF KMode_Average_RI = %8.4f\n',CADO_KMode_ARI/Times,NDM_ForCD_KMode_ARI/Times,OF_KMode_ARI/Times);

for alpha = 0.1:0.1:0.9
    fprintf(fid,'alpha = %3.1f\n', alpha);
    CADOImprove_SC_AC = 0;
    CADOImprove_KMode_AC = 0;
    CADOImprove_SC_NMI = 0;
    CADOImprove_KMode_NMI = 0;
    CADOImprove_SC_ARI = 0;
    CADOImprove_KMode_ARI = 0;
    for i = 1:Times
        %   除去最后一列类标签,使用新的度量标准求样本间的距离
        Dist = CADOImprove(Data(:,[1:col-1]),alpha);
        %       采用Normalized谱聚类算法进行聚类，计算正确率
        categoryid = NormalizedSC(Dist,TheoryCluster);
        [CADOImprove_NormalizedSC_AC,CADOImprove_NormalizedSC_PR,CADOImprove_NormalizedSC_RE,CADOImprove_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
        CADOImprove_SC_AC =  CADOImprove_SC_AC + CADOImprove_NormalizedSC_AC;
        [CADOImprove_NormalizedSC_NMI] = NMI(categoryid,Data(:,col));
        CADOImprove_SC_NMI = CADOImprove_SC_NMI + CADOImprove_NormalizedSC_NMI;
        [CADOImprove_NormalizedSC_ARI] = AdjustedRandIndex(categoryid,Data(:,col));
        CADOImprove_SC_ARI = CADOImprove_SC_ARI + CADOImprove_NormalizedSC_ARI;
        
        %   采用KMode聚类算法进行聚类，计算正确率
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

