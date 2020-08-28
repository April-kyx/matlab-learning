clc,clear,close all;
%% 导入数据及数据预处理 
load bank.mat
% 将分类变量转换成分类数组
names = bank.Properties.VariableNames;
category = varfun(@iscellstr, bank, 'Output', 'uniform');
for i = find(category)
    bank.(names{i}) = categorical(bank.(names{i}));
end
% 跟踪分类变量
catPred = category(1:end-1);
% 设置默认随机数生成方式确保该脚本中的结果是可以重现的
rng('default');
% 数据探索----数据可视化
figure(1)
gscatter(bank.balance,bank.duration,bank.y,'kk','xo')
xlabel('年平均余额/万元', 'fontsize',12)
ylabel('上次接触时间/秒', 'fontsize',12)
title('数据可视化效果图', 'fontsize',12)
set(gca,'linewidth',2);

% 设置响应变量和预测变量
X = table2array(varfun(@double, bank(:,1:end-1)));  % 预测变量
Y = bank.y;   % 响应变量
disp('数据中Yes & No的统计结果：')
tabulate(Y)
%将分类数组进一步转换成二进制数组以便于某些算法对分类变量的处理
XNum = [X(:,~catPred) dummyvar(X(:,catPred))];
YNum = double(Y)-1;

%% 设置交叉验证方式
% 随机选择40%的样本作为测试样本
cv = cvpartition(height(bank),'holdout',0.40);
% 训练集
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);
XtrainNum = XNum(training(cv),:);
YtrainNum = YNum(training(cv),:);
% 测试集
Xtest = X(test(cv),:);
Ytest = Y(test(cv),:);
XtestNum = XNum(test(cv),:);
YtestNum = YNum(test(cv),:);
disp('训练集：')
tabulate(Ytrain)
disp('测试集：')
tabulate(Ytest)
%% 神经网络
% 设置神经网络模式及参数
hiddenLayerSize = 5;
net = patternnet(hiddenLayerSize);
% 设置训练集、验证机和测试集
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
% 训练网络
net.trainParam.showWindow = false;
inputs = XtrainNum';
targets = YtrainNum';
[net,~] = train(net,inputs,targets);
% 用测试集数据进行预测
Yscore_nn = net(XtestNum')';
Y_nn = round(Yscore_nn);
% 计算混淆矩阵
disp('神经网络方法分类结果：')
C_nn = confusionmat(YtestNum,Y_nn)