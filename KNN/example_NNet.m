%% 导入数据
clc,clear,close all;
load('bank.mat');
%% 将分类变量转换成分类数组；
names=bank.Properties.VariableNames;    %必须通过属性访问表中的变量名称；
category=varfun(@iscellstr,bank,'OutputFormat','uniform'); 
%@()这是各匿名函数（句柄函数），‘outputformat’func在每次调用的返回值数据类型，这里是与前面句柄函数数据类型的标量；
%默认是table表；
for i=find(category)
    bank.(names{i})=categorical(bank.(names{i}));   %创建分类数组，注意以前里面是带‘’的分类变量；
end
%% 跟踪分类变量
catPred=category(1:end-1);  %去掉最后的调查结果y，剩下的值；
%% 设置默认随机数生成方式，确保该脚本中的结果是可以重现的；
rng('default'); %设置默认产生的随机数；
%% 数据探索——数据可视化
figure(1)
gscatter(bank.balance,bank.duration,bank.y,'kk','xo')
xlabel('年平均余额/万元','fontsize',12);
ylabel('上次接触时间/秒','fontsize',12);
title('数据可视化效果图','fontsize',12);
set(gca,'linewidth',2);
%% 设置响应变量和预测变量
X=table2array(varfun(@double,bank(:,1:end-1))); 
%预测变量,其中字符串返回的double是通过先将种类排序后的序号；table是把表转化成同构数组；
Y=bank.y;   %响应变量；（输出值）
disp('数据中Yes&No的统计结果：')
tabulate(Y) %频率表；显示矢量Y中的数据频率表；
%% 将分数组进一步转换成二进制数组，以便某些算法对分类变量的处理；
XNum=[X(:,~catPred) dummyvar(X(:,catPred))];
%catPred为逻辑类型，~表示取反；dummyvar表示创建虚拟变量，行数不变，列数看该列最大的数就扩大成几列，然后在对应的列数上写上1，其余为0；
YNum=double(Y)-1;
%% 随机选择40%的样本作为测试样本
cv=cvpartition(height(bank),'holdout',0.40);
%c = cvpartition（n，"HoldOut"， p）创建一个随机的非分层分区，用于对观测值进行保留验证。
%此分区将观测值划分为训练集和测试集（或保持组）。参数p必须是标量。
%当 0< p< 1时，随机选择观测值的p*n作为测试值。当p是整数时，随机选择p为测试值。p的默认值为 1/10。
%% 训练集
Xtrain=X(training(cv),:);   %根据上式找出训练集；
Ytrain=Y(training(cv),:);   %对应训练集的输出结果；
XtrainNum=XNum(training(cv),:);
YtrainNum=YNum(training(cv),:);
%% 测试集
Xtest=X(test(cv),:);
Ytest=Y(test(cv),:);
XtestNum=XNum(test(cv),:);
YtestNum=YNum(test(cv),:);
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