% position=[1工件号 3工序号 5机器号 6工序用时 7开工时间 8完工时间]
clc;
clear;
close;
data=xlsread('gantt.xlsx','Sheet2');
operation_cumsum = size(data,1);  % 工序的累加，例如4、9、14
Cmax=max(data(:,8));

color1=[1 0.57 0;1 0.93 0; 0.83 1 0;0.5 1 0;0 1 0.97;0 0.70 0;0.3 0.5 0.81;0.5 0 1;0.7 0.5 0.63;0.77 0 1;1 0 0.63;0.8 0.27 0;0.7 0.4 0.3; 0.63 0.8 0.2;0.1 0.8 0.6;0.1 0.4 0.77;0.5 0.2 0;0 0.7 0.3;0.4 0.5 0.3;0.1 0.7 0.7];

% yanse=color(randperm(100),:);     %随机产生初始解编码
for position=1:operation_cumsum                                   %遍历每一个工序
     rec(1) = data(position,7);                     %矩形的横坐标,即工序的开始时间
     rec(2) = data(position,5)-0.2;                 %矩形左下角的纵坐标，即机器号
     rec(3) = data(position,8)-data(position,7);    %矩形的长度，即加工时间
     rec(4) = 0.6;                                  %矩形的高度
     J=data(position,1);
     O=data(position,3);
     txt=sprintf('%d,%d',J,O);                      %第x个任务，第y道工序
     %画矩形
     rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color1(J,:));
     % 确定文本位置
     text(rec(1)+0.2,rec(2)+0.3,txt,'FontSize',8);
end
M=15.5;
axis([0,(max(data(:,8))+90),0.01,15.9]);                    %x、y轴的范围
line([Cmax,Cmax],[0,15],'linestyle','-','color','r');
%%%%写Cmax
txtCmax=sprintf('%d',Cmax);
text(Cmax+8,1,txtCmax,'FontSize',11,'color','r');
%%%%%%%%%%%%%%%%%%%%%
set(gca,'xtick',0:100:(max(data(:,8))+100),'ytick',0:M);  %x、y轴的增长幅度
xlabel('Time','FontSize',12),ylabel('Machine','FontSize',12); %x、y轴的名称
set(gca,'Fontsize',10,'LooseInset',get(gca,'TightInset'));% 去除图片白边
set(gcf,'unit','centimeters','position',[10 10 20 15]);   %调整图片大小

% 保存图片
% currPath = fileparts(mfilename('fullpath'));
% print(gcf,'-djpeg','-r300',[currPath,'\甘特图']);