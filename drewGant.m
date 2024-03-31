%生成甘特图
function drewGant(schedule,workpieceNum,machNum)
    randColor = rand(workpieceNum, 3);
    figure;   
    ylim([0 machNum+1]); 
    for i=1:size(schedule,1)
        x=schedule(i,4:5);
        y=[schedule(i,3) schedule(i,3)];
        txt=sprintf('%d,%d',schedule(i,1),schedule(i,2));        
        line(x,y,'lineWidth',30,'color',randColor(schedule(i,1),:));
        text((x(1)+x(2))/2,y(1),txt,"FontSize",15); 
    end
    randColor = rand(machNum, 3); 

    % %%%%%%%%%%%%%%%%%%%%%%%%%%GPT写出来的，不会%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % legendText = cell(workpieceNum, 1); % 创建一个单元格数组来存储工件名称 
    % for i = 1:workpieceNum                                               
    %     chatTxt = "工件" + int2str(i);
    %     legendText{i} = chatTxt; % 将工件名称添加到单元格数组中
    % end
    % legend(legendText, 'TextColor', 'k'); % 添加图例并指定文本颜色为黑色
    % %%%%%%%%%%%%%%%%%%%%%%%%%%GPT写出来的，不会%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end



% function ganttHdl=drewGant(ganttData)
% % sT | 任务开始时间
% % eT | 任务结束时间
% % machineId | 任务所属机器编号
% % taskId | 任务编号
% hold on;
% 
% % 数据预处理
% sT = ganttData{1, :};
% eT = ganttData{2, :};
% machineId = ganttData{3, :};
% taskId = ganttData{4, :};
% processId = ganttData{5, :};
% display(taskId)
% % 根据任务开始时间和结束时间计算 任务的持续时长
% for ii=1:1:size(sT,2)
%     dT(ii)=eT(ii)-sT(ii);
% end
% 
% % 获取甘特图每个方块中的数据
% rectangleData{length(machineId)}='';
% for i=1:length(machineId)
%     rectangleData(i)={[num2str(taskId(i)),'  ',num2str(processId(i))]};
% end
% 
% % 将 Y 轴刻度设置为从 1 到 max(id) 的整数
% set(gca,'YTick',1:max(machineId));
% % 将 Y 轴限制设置为从 0 到 max(id)+1
% set(gca,'YLim',[0,max(machineId)+1]);
% % 关闭X轴网格，开启需设置为 on
% set(gca,'XGrid','on');
% % 关闭Y轴网格，开启需设置为 on
% set(gca,'YGrid','on');
% % 设置网格线透明度，网格线关闭时不起作用
% set(gca,'GridAlpha',0.5);
% % 设置网格线颜色，网格线关闭时不起作用
% set(gca,'GridColor',[0.5 0.5 0.5]);
% % 设置背景色为白色
% set(gcf,'color','w');
% % 设置字体，包括大小，字体，线宽
% set(gca,'FontSize',20,'fontname','Times New Roman','Linewidth', 1.2);
% sT=sT(:);dT=dT(:);machineId=machineId(:);
% box('on');
% % 设置x和y轴 名称
% xlabel('time ');
% ylabel('mech');
% % 颜色列表
% colorList = [
%     255, 182, 193;   % 浅粉红
%     173, 216, 230;   % 淡蓝色
%     144, 238, 144;   % 淡绿色
%     255, 228, 181;   % 淡黄色
%     255, 248, 220;   % 淡紫色
%     224, 255, 255;   % 淡青色
%     255, 192, 203;   % 淡粉红
%     240, 128, 128;   % 淡珊瑚
%     152, 251, 152;   % 淡绿宝石
%     255, 160, 122;   % 淡珊瑚
%     221, 160, 221;   % 淡紫红
%     173, 216, 230;   % 淡天蓝
%     255, 165, 0;     % 淡橙色
%     255, 222, 173;   % 浅杏仁
%     192, 192, 192;   % 淡灰色
%     255, 255, 255;   % 白色
%     220, 220, 220;   % 淡灰色
%     255, 228, 181;   % 淡橙色
%     240, 230, 140;   % 淡黄绿色
%     255, 215, 0      % 金黄色
%     ] ./ 255;  % 将 RGB 值映射到 [0, 1] 范围
% 
% % 循环绘图
% for i=unique(machineId)'
%     t_sT=sT(machineId==i);
%     t_dT=dT(machineId==i);
%     [t_sT,t_ind]=sort(t_sT);
%     t_dT=t_dT(t_ind);
%     if ~isempty(rectangleData)
%         t_Str=rectangleData(machineId==i);
%         t_Str=t_Str(t_ind);
%     end
%     for j=1:length(t_sT)
%         ganttHdl.(['p',num2str(i)])(j)=rectangle('Position',[t_sT(j),i-.4,t_dT(j),.8],...
%             'LineWidth',.8,'EdgeColor',[.2,.2,.2],...
%             'FaceColor',colorList(i+2,:),'AlignVertexCenters','on');
%     end
%     for j=1:length(t_sT)
%         if ~isempty(rectangleData)
%             ganttHdl.(['t',num2str(i)])(j)=text((t_sT(j)+t_dT(j)+t_sT(j))/2,i,t_Str{j},'FontSize', 15, 'fontname','Times New Roman', 'HorizontalAlignment', 'center');
%         else
%             ganttHdl.(['t',num2str(i)])(j)=text(t_sT(j),i,'');
%         end
%     end
% end
% end
% 
% 
