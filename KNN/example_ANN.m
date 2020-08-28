clc,clear,close all;
%% �������ݼ�����Ԥ���� 
load bank.mat
% ���������ת���ɷ�������
names = bank.Properties.VariableNames;
category = varfun(@iscellstr, bank, 'Output', 'uniform');
for i = find(category)
    bank.(names{i}) = categorical(bank.(names{i}));
end
% ���ٷ������
catPred = category(1:end-1);
% ����Ĭ����������ɷ�ʽȷ���ýű��еĽ���ǿ������ֵ�
rng('default');
% ����̽��----���ݿ��ӻ�
figure(1)
gscatter(bank.balance,bank.duration,bank.y,'kk','xo')
xlabel('��ƽ�����/��Ԫ', 'fontsize',12)
ylabel('�ϴνӴ�ʱ��/��', 'fontsize',12)
title('���ݿ��ӻ�Ч��ͼ', 'fontsize',12)
set(gca,'linewidth',2);

% ������Ӧ������Ԥ�����
X = table2array(varfun(@double, bank(:,1:end-1)));  % Ԥ�����
Y = bank.y;   % ��Ӧ����
disp('������Yes & No��ͳ�ƽ����')
tabulate(Y)
%�����������һ��ת���ɶ����������Ա���ĳЩ�㷨�Է�������Ĵ���
XNum = [X(:,~catPred) dummyvar(X(:,catPred))];
YNum = double(Y)-1;

%% ���ý�����֤��ʽ
% ���ѡ��40%��������Ϊ��������
cv = cvpartition(height(bank),'holdout',0.40);
% ѵ����
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);
XtrainNum = XNum(training(cv),:);
YtrainNum = YNum(training(cv),:);
% ���Լ�
Xtest = X(test(cv),:);
Ytest = Y(test(cv),:);
XtestNum = XNum(test(cv),:);
YtestNum = YNum(test(cv),:);
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