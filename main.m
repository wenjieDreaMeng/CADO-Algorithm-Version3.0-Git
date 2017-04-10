function main( )

%   Author: wenjie
%   Data:   2017-3-3

clc;
clear;
global weight;
global ps;
global pf;

Data = csvread('G:\5、Matlab Projects\测试数据集\分类型数据集\Zoo Data Set.csv');         %   载入总的数据集
TheoryCluster = 7;
Times = 20;                  %   迭代次数

weight = WeightBetweenAttribute(Data);
[row,col] = size(Data);
[ps,pf] = WeightInAttribute(Data(:,[1:col-1]));

for alpha = 0.1:0.1:0.9
    fprintf('alpha = %6.1f：\n', alpha);
    CADO_SC_AC = 0;
    CADO_KMode_AC = 0;
    CADOImprove_SC_AC = 0;
    CADOImprove_KMode_AC = 0;
    for i = 1:Times
%         %   除去最后一列类标签,使用相似度求样本间的距离
%         Dist = CADO(Data(:,[1:col-1]));
%         %   采用Normalized谱聚类算法进行聚类，计算正确率
%         categoryid = NormalizedSC(Dist,TheoryCluster);
%         [CADO_NormalizedSC_AC,CADO_NormalizedSC_PR,CADO_NormalizedSC_RE,CADO_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
%         CADO_SC_AC = CADO_SC_AC + CADO_NormalizedSC_AC;
%         
%         %   采用KMode聚类算法进行聚类，计算正确率
%         categoryid = CADO_K_Mode(Data,TheoryCluster);
%         [CADO_K_Mode_AC,CADO_K_Mode_PR,CADO_K_Mode_RE,CADO_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
%         CADO_KMode_AC = CADO_KMode_AC + CADO_K_Mode_AC;
        
        %   除去最后一列类标签,使用新的度量标准求样本间的距离
        Dist = CADOImprove(Data(:,[1:col-1]),alpha);
        %       采用Normalized谱聚类算法进行聚类，计算正确率
        categoryid = NormalizedSC(Dist,TheoryCluster);
        [CADOImprove_NormalizedSC_AC,CADOImprove_NormalizedSC_PR,CADOImprove_NormalizedSC_RE,CADOImprove_NormalizedSC_CV] = AC_PR_RE(categoryid,Data(:,col));
        CADOImprove_SC_AC =  CADOImprove_SC_AC + CADOImprove_NormalizedSC_AC;
        
        %   采用KMode聚类算法进行聚类，计算正确率
        categoryid = CADOImprove_K_Mode(Data,TheoryCluster,alpha);
        [CADOImprove_K_Mode_AC,CADOImprove_K_Mode_PR,CADOImprove_K_Mode_RE,CADOImprove_K_Mode_CV] = AC_PR_RE(categoryid,Data(:,col));
        CADOImprove_KMode_AC = CADOImprove_KMode_AC + CADOImprove_K_Mode_AC;
    end
%     fprintf('CADO SC_AVERAGE_AC = %8.4f,         CADO KMode_Average_AC = %8.4f\n',CADO_SC_AC/Times,CADO_KMode_AC/Times);
    fprintf('CADOImprove SC_Average_AC = %8.4f,  CADOImprove KMode_Average_AC = %8.4f\n',CADOImprove_SC_AC/Times,CADOImprove_KMode_AC/Times);
end
end

