%% ��������
clc,clear,close all;
load('bank.mat');
%% ���������ת���ɷ������飻
names=bank.Properties.VariableNames;    %����ͨ�����Է��ʱ��еı������ƣ�
category=varfun(@iscellstr,bank,'OutputFormat','uniform'); 
%@()���Ǹ������������������������outputformat��func��ÿ�ε��õķ���ֵ�������ͣ���������ǰ���������������͵ı�����
%Ĭ����table��
for i=find(category)
    bank.(names{i})=categorical(bank.(names{i}));   %�����������飬ע����ǰ�����Ǵ������ķ��������
end
%% ���ٷ������
catPred=category(1:end-1);  %ȥ�����ĵ�����y��ʣ�µ�ֵ��
%% ����Ĭ����������ɷ�ʽ��ȷ���ýű��еĽ���ǿ������ֵģ�
rng('default'); %����Ĭ�ϲ������������
%% ����̽���������ݿ��ӻ�
figure(1)
gscatter(bank.balance,bank.duration,bank.y,'kk','xo')
xlabel('��ƽ�����/��Ԫ','fontsize',12);
ylabel('�ϴνӴ�ʱ��/��','fontsize',12);
title('���ݿ��ӻ�Ч��ͼ','fontsize',12);
set(gca,'linewidth',2);
%% ������Ӧ������Ԥ�����
X=table2array(varfun(@double,bank(:,1:end-1))); 
%Ԥ�����,�����ַ������ص�double��ͨ���Ƚ�������������ţ�table�ǰѱ�ת����ͬ�����飻
Y=bank.y;   %��Ӧ�����������ֵ��
disp('������Yes&No��ͳ�ƽ����')
tabulate(Y) %Ƶ�ʱ���ʾʸ��Y�е�����Ƶ�ʱ�
%% ���������һ��ת���ɶ��������飬�Ա�ĳЩ�㷨�Է�������Ĵ���
XNum=[X(:,~catPred) dummyvar(X(:,catPred))];
%catPredΪ�߼����ͣ�~��ʾȡ����dummyvar��ʾ��������������������䣬����������������������ɼ��У�Ȼ���ڶ�Ӧ��������д��1������Ϊ0��
YNum=double(Y)-1;
%% ���ѡ��40%��������Ϊ��������
cv=cvpartition(height(bank),'holdout',0.40);
%c = cvpartition��n��"HoldOut"�� p������һ������ķǷֲ���������ڶԹ۲�ֵ���б�����֤��
%�˷������۲�ֵ����Ϊѵ�����Ͳ��Լ����򱣳��飩������p�����Ǳ�����
%�� 0< p< 1ʱ�����ѡ��۲�ֵ��p*n��Ϊ����ֵ����p������ʱ�����ѡ��pΪ����ֵ��p��Ĭ��ֵΪ 1/10��
%% ѵ����
Xtrain=X(training(cv),:);   %������ʽ�ҳ�ѵ������
Ytrain=Y(training(cv),:);   %��Ӧѵ��������������
XtrainNum=XNum(training(cv),:);
YtrainNum=YNum(training(cv),:);
%% ���Լ�
Xtest=X(test(cv),:);
Ytest=Y(test(cv),:);
XtestNum=XNum(test(cv),:);
YtestNum=YNum(test(cv),:);
disp('ѵ������')
tabulate(Ytrain)
disp('���Լ���')
tabulate(Ytest)
%% ѵ��K-NN������
knn=fitcknn(Xtrain,Ytrain,'Distance','seuclidean',...
    'NumNeighbors',5);
%����Ԥ�⣻
[Y_knn,Yscore_knn]=knn.predict(Xtest);
%Yscore_knn�������У���1����no�Ŀ����ԣ���2����yes�Ŀ����ԣ�
Yscore_knn=Yscore_knn(:,2);
%�����������
disp('����ڷ�����������')
C_knn=confusionmat(Ytest,Y_knn)
%confusionmatΪ��������
%����Ytest��Y_knn���Ƿ������飬���Խ��л����жϣ����Եõ�2*2�еľ���
%�ж�Ӧ�ŵ��ǲ��Լ��е�no��yes;�ж�Ӧ�ŵ�����KNN���෨Ԥ���no,yes;
%���Ϊ���Լ�no����352����ȷ��Ϊno����8�������Ϊyes��