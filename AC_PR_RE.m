 function [AC,PR,RE,CV] = AC_PR_RE(Label,Decision)
%---------------------------------------------------------------------
%   This function caculates the AC,PR,RE indices between two labels
%   Decision : the decision label owned by the data set
%   Label : the label created by clustering algorithm
%-----------------------------------------------------------------------
num =length(Decision);  %   the number of objects

if num ~= length(Label)
    error('the number of objects in the decision and label are different!');
end
if size(Decision,1)~=size(Label,1)  % if one of the input parameters is row-vector, while the other is column-vector; change one to the other form vector.
    Decision = Decision';
end
matrix = Label2Matrix(Decision,Label); %�нǶȱ�ʾ��ʵ�������б�ʾ����õ�����
[Decnum,Labelnum]=size(matrix);     % get orginal number of clusters Decnum; new number of clusters created by clustering algorithm Labelnum.

% ���㾫�ȣ��Ӿ���õ���ǩ�ĽǶȿ�����ÿһ�е����ֵ�ۼӳ��Զ������
AC = sum(max(matrix,[],1))/num;

% ���㴿�ȣ��Ӿ���õ���ǩ�ĽǶȿ�����ÿһ�е����ֵ���Ը��еĺͣ�Ȼ���ۼ�
colmaxvalue = max(matrix,[],1);
colsumvalue = sum(matrix,1);
PR = sum(colmaxvalue./colsumvalue)/Labelnum;%�Ƿ���Ծ����µõ���������ȽϺ���

% �����ٻ��ʣ��Ӿ���õ���ǩ�ĽǶȿ�����ÿһ�е����ֵ���Ը����ֵ�����еĺͣ�Ȼ���ۼ�
recall = 0;
for i = 1:Labelnum
    [value,index] = max(matrix(:,i));
    recall = recall+value/sum(matrix(index,:));
end
RE = recall/Labelnum;


% ����仯ϵ��CV������׼��/����ֵ��
% exception=num/2;
% biaozhuncha=(sum(matrix(1,:))-exception)^2;
% biaozhuncha=biaozhuncha+(sum(matrix(2,:))-exception)^2;
% biaozhuncha=sqrt(biaozhuncha);
% CV=biaozhuncha/exception;
% matrix=matrix';
% biaozhuncha=(sum(matrix(1,:))-exception)^2;
% biaozhuncha=biaozhuncha+(sum(matrix(2,:))-exception)^2;
% biaozhuncha=sqrt(biaozhuncha);
% CV=CV-biaozhuncha/exception;
% CV=abs(CV);
CV = 0;

%*********************************************************************
function matrix=Label2Matrix(Decision,Label)
%---------------------------------------------------------------------
%   This function caculates the overlap matrix between two labels
%   Decision : the decision label owned by the data set
%   Label : the label created by clustering algorithm
%   Notice:the input parameters must be row-vector or column-vector
%   simultaneously.
%-----------------------------------------------------------------------

Decvalue = unique(Decision); % the values of orginal decision label
Decnum = length(Decvalue);   % the number of clusters of the origianl decision

Labelvalue = unique(Label); % the values of the label created by algorithm
Labelnum = length(Labelvalue); % the number of clusters created by clustering algorithm

% row:look from origianl label;  column: look from the label created by
% clustering algorithm
matrix = zeros(Decnum,Labelnum);

for i=1:Decnum
    index = find(Decision==Decvalue(i));
    templabelvalue = unique(Label(index));
    templabelvaluenum = length(templabelvalue);
    for j=1:templabelvaluenum
        tempnum = length(find(templabelvalue(j)==Label(index)));
        for k=1:Labelnum
            if templabelvalue(j)==Labelvalue(k)
                matrix(i,k)=tempnum;
            end
        end
    end
end