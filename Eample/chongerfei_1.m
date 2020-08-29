%% ׼���׶�
clear;clc;
fs=44100;
%����Ƶ�ʣ�MP3�ı�׼Ƶ�ʣ���˵������fs�����ã��˶��ܹ�������������Χ��20~20000Hz�����ݲ�������fsֻ��Ҫ����40000���ɡ��˴������ʵ����ò�����MP3�ı�׼����fs=44.1k.
%���ð��磬���߰��磨˥������ȥ������
%% ÿ��������Ƶ��
% part1=[mi_4 mi_8 mi_8 fa_4 sol_4];
part1=[fre(55) fre(55) fre(55) fre(56) fre(58)];
% part2=[mi_3 re_8 re_2];
part2=[fre(55) fre(53) fre(53)];
% part3=[do_4 do_8 do_8 re_4 mi_4];
part3=[fre(51) fre(51) fre(51) fre(53) fre(55)];
% part4=[mi_3 xi_8l xi_2l];
part4=[fre(55) fre(50) fre(50)];
% part5=[la_4l mi_4 re_2];
part5=[fre(48) fre(55) fre(53)];
% part6=[la_4l mi_4 re_2];
part6=[fre(48) fre(55) fre(53)];
% part7=[la_4l mi_4 re_3 do_8];
part7=[fre(48) fre(55) fre(53) fre(51)];
% part8=[do];
part8=[fre(51)];
% part9=[o o o o];
part9=[0 0 0 0];
% part10=[o o o mi_8 re_8];
part10=[0 0 0 fre(55) fre(53)];
% part11=[sol_5 fa_8 mi_4];
part11=[fre(58) fre(56) fre(55)];
% part12=[re_3 re_4 sol_8 fa_8];
part12=[fre(53) fre(53) fre(58) fre(56)];
% part13=[mi_4 fa_8 sol_3 mi_4];
part13=[fre(55) fre(56) fre(58) fre(55)];
% part14=[re_5 0.5*o do_8];
part14=[fre(53) 0 fre(51)];
% part15=[la_4l mi_4 re_3 do_8];
part15=[fre(48) fre(55) fre(53) fre(51)];
% part16=[sol_4l re_8 do_8 do_2];
part16=[fre(46) fre(53) fre(51) fre(51)];
% part17=[fa_8 mi_8 fa_8 mi_8 do_2];
part17=[fre(56) fre(55) fre(56) fre(55) fre(51)];
% part18=[fa_8 mi_8 fa_8 mi_8 do_3 re_8];
part18=[fre(56) fre(55) fre(56) fre(55) fre(51) fre(53)];
% part19=[do];
part19=[fre(51)];
% part20=[o o o o];
part20=[0 0 0 0];

para=[part1,part2,part3,part4,part5,part6,part7,...
    part8,part9,part10,part11,part12,part13,part14,...
    part15,part16,part17,part18,part19,part20];
fr=para;
%% ÿ��ÿ��������ʱ��
% part1=[mi_4 mi_8 mi_8 fa_4 sol_4];
part1time=[1 0.5 0.5 1 1];
% part2=[mi_3 re_8 re_2];
part2time=[1.5 0.5 2];
% part3=[do_4 do_8 do_8 re_4 mi_4];
part3time=[1 0.5 0.5 1 1];
% part4=[mi_3 xi_8l xi_2l];
part4time=[1.5 0.5 2];
% part5=[la_4l mi_4 re_2];
part5time=[1 1 2];
% part6=[la_4l mi_4 re_2];
part6time=[1 1 2];
% part7=[la_4l mi_4 re_3 do_8];
part7time=[1 1 1.5 0.5];
% part8=[do];
part8time=[4];
% part9=[o o o o];
part9time=[0 0 0 0];
% part10=[o o o mi_8 re_8];
part10time=[0 0 0 0.5 0.5];
% part11=[sol_5 fa_8 mi_4];
part11time=[3 0.5 1];
% part12=[re_3 re_4 sol_8 fa_8];
part12time=[1.5 1 0.5 0.5];
% part13=[mi_4 fa_8 sol_3 mi_4];
part13time=[1 0.5 1.5 1];
% part14=[re_5 0.5*o do_8];
part14time=[3 0.5 0.5];
% part15=[la_4l mi_4 re_3 do_8];
part15time=[1 1 1.5 0.5];
% part16=[sol_4l re_8 do_8 do_2];
part16time=[1 0.5 0.5 2];
% part17=[fa_8 mi_8 fa_8 mi_8 do_2];
part17time=[0.5 0.5 0.5 0.5 2];
% part18=[fa_8 mi_8 fa_8 mi_8 do_3 re_8];
part18time=[0.5 0.5 0.5 0.5 1.5 0.5];
% part19=[do];
part19time=[4];
% part20=[o o o o];
part20time=[0 0 0 0];

paratime=[part1time,part2time,part3time,part4time,part5time,part6time,part7time,...
    part8time,part9time,part10time,part11time,part12time,part13time,part14time,...
    part15time,part16time,part17time,part18time,part19time,part20time];
%%
time=fs*paratime; %���������ĳ���������
N=length(time);%����������ܳ���������
east=zeros(1,N);%��east�������洢�����㣻
n=1;
for num=1:N  %����ѭ�������������ݣ�num��ʾ�������
   t=1/fs:1/fs:time(num)/fs;%������num�������ĳ����㣻
   baoluo=zeros(1,time(num));%baoluoΪ�洢�������ݵ�������
   for j=1:time(num)
       if(j<0.2*time(num))
           y=7.5*j/time(num);
       else
           if(j<0.333*time(num))
               y=-15/4*j/time(num)+9/4;
           else
               if(j<0.666*time(num))
                   y=1;
               else
                   y=-3*j/time(num)+3;
               end
           end
       end
       baoluo(j)=y;
   end
   east(n:n+time(num)-1)=sin(2*pi*fr(num)*t).*baoluo(1:time(num));%����num���������ϰ��磻
   n=n+time(num);
end
sound(east,fs);
% plot(east);
%% ����
% y=east;  %���������źŵķ�ֵ������1�����д���źű��ü���
% audiowrite('�����_1.wav',y,fs);
function f=fre(p)
f=440*2^((p-49)/12);
end