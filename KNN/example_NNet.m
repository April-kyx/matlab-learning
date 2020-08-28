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
%% ������
% ����������ģʽ������
hiddenLayerSize = 5;
net = patternnet(hiddenLayerSize);
% ����ѵ��������֤���Ͳ��Լ�
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
% ѵ������
net.trainParam.showWindow = false;
inputs = XtrainNum';
targets = YtrainNum';
[net,~] = train(net,inputs,targets);
% �ò��Լ����ݽ���Ԥ��
Yscore_nn = net(XtestNum')';
Y_nn = round(Yscore_nn);
% �����������
disp('�����緽����������')
C_nn = confusionmat(YtestNum,Y_nn)