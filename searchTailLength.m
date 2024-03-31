% 寻找最大弧数函数 函数接受一个矩阵参数schedule 返回一个矩阵newSchedule 定义如下：
% 接受schedule=[1工件号 2工件工序号 3机器号 4开工时间 5完工时间 6关键工序标志位]
% ！！条件1：接受的schedule应当在每台机器上由时间升序安排！
% 返回newSchedule=[1工件号 2工件工序号 3机器号 4开工时间 5完工时间 6关键工序标志位 7尾长]
% 中间schedule=[7标记位 8索引位 9尾长]
% ！！注意：返回的newSchedule是强制转换之后的！没有标准化！！！！
function newSchedule = searchTailLength(schedule)
    % 初始化schedule 使其强制能满足条件1
    schedule=sortrows(schedule,[3,4]);
    schedule(:,7)=-1; %是否已经调度的标志位 -1为没调度 0为待调度，1为已调度 初始化为-1
    schedule(:,8)=1:size(schedule,1); %索引位
    schedule(:,9)=0; %尾长位 初始化为0
    jobLastProcessSchedule=schedule(schedule(:,2)==max(schedule(:,2)),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 对于每个工件的对于每个工件的尾工序𝑂𝑖𝑛𝑖 (1 ≤ 𝑖 ≤ 𝑛),若𝑀𝑆[𝑂𝑖𝑛𝑖 ] = # , 则𝑆𝑁 = 𝑆𝑁 ∪ {𝑂𝑖𝑛𝑖 } ;  
    % 即是机器的最后一道工序，加入待调度队列
    for i=1:size(jobLastProcessSchedule,1)
        thisProcessSchedule=jobLastProcessSchedule(i,:);
        % 找到每一个的MS
        thisProcessSameMachineSchedule=schedule(schedule(:,3)==thisProcessSchedule(1,3),:);
        thisProcessInSMSIndex=ismember(thisProcessSameMachineSchedule(:,1:2),[thisProcessSchedule(1,1),thisProcessSchedule(1,2)],'rows');
        thisProcessInSMSrow=find(thisProcessInSMSIndex);
        if thisProcessInSMSrow==size(thisProcessSameMachineSchedule,1)
            schedule(thisProcessSchedule(1,8),7)=0;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while(size(schedule(schedule(:,7)==0,7),1)~=0) %如果待调度序列还有时：
        nowSNSchedule=schedule(schedule(:,7)==0,:);
        point=randperm(size(nowSNSchedule,1),1);
        thisProcessSchedule=nowSNSchedule(point,:);
        % 𝑡𝑥 = max{𝑡𝐽𝑆[𝑥] + 𝑝𝐽𝑆[𝑥] ,𝑡𝑀𝑆[𝑥] + 𝑝𝑀𝑆[𝑥]}.  
        % 需要求得 thisPointJSSchedule 和 thisPointMSSchedule

        % 寻找JS
        thisPointJSScheduleIndex=ismember(schedule(:,1:2),[nowSNSchedule(point,1),nowSNSchedule(point,2)+1],'rows');
        thisPointJSScheduleRow=find(thisPointJSScheduleIndex); %如果找到了前道工序，返回其在schedule中的行数，否则，返回【】
        if ~isempty(thisPointJSScheduleRow) %如果找到了JS
            thisPointJSSchedule=schedule(thisPointJSScheduleRow,:);
            JSTailLength=thisPointJSSchedule(1,9);
            JSSpeedTime=thisPointJSSchedule(1,5)-thisPointJSSchedule(1,4);
        else %没找到JS 即point是工件的最后一道工序
            JSTailLength=0;
            JSSpeedTime=0;
        end

        % 现在开始寻找MS
        sameMachineSchedule=schedule(schedule(:,3)==thisProcessSchedule(1,3),:);
        findThisProcessInSMSRowIndex=ismember(sameMachineSchedule(:,8),thisProcessSchedule(1,8),'rows');
        thisProcessInSMSRow=find(findThisProcessInSMSRowIndex); %找到当前工序在同机器排产表中的行数
        if thisProcessInSMSRow==size(sameMachineSchedule,1) %如果是最后一行，则MS不存在
            MSTailLength=0;
            MSSpeedTime=0;
        else
            thisPointMSSchedule=schedule(sameMachineSchedule(thisProcessInSMSRow+1,8),:);
            MSTailLength=thisPointMSSchedule(1,9);
            MSSpeedTime=thisPointMSSchedule(1,5)-thisPointMSSchedule(1,4);
        end

        %更新最大弧数、标记位
        % schedule(nowSNSchedule(point,8),9)=max(JSTailLength+JSSpeedTime,MSTailLength+MSSpeedTime);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
        % 2024年3月27日20:21:51 在这里更改了最大胃肠的求法
        schedule(nowSNSchedule(point,8),9)=max(JSTailLength+JSSpeedTime,MSTailLength+MSSpeedTime)+schedule(nowSNSchedule(point,8),5)-schedule(nowSNSchedule(point,8),4);
        schedule(nowSNSchedule(point,8),7)=1;

        % 现在开始加入新的SN  
        % 先找JP的MS的
        % 首先找到JP 这里需不需要检查JP是否存在的？ --先整一个判断存在的吧        
        thisProcessJPIndex=ismember(schedule(:,1:2),[thisProcessSchedule(1,1),thisProcessSchedule(1,2)-1],'rows');
        thisProcessJPRow=find(thisProcessJPIndex); %返回 在schedule 中的行数，否则返回 0
        if ~isempty(thisProcessJPRow) %如果JS存在
            %现在寻找JP的MS
            thisProcessJPSchedule=schedule(thisProcessJPRow,:);
            thisProcessJPSameMachineSchedule=schedule(schedule(:,3)==thisProcessJPSchedule(1,3),:);
            % 找到JP所在SMS中的行索引
            thisProcessJPinSMSIndex=ismember(thisProcessJPSameMachineSchedule(:,8),thisProcessJPSchedule(1,8),'rows');
            thisProcessJPinSMSRow=find(thisProcessJPinSMSIndex); %存在返回 在 SMS 中的行数，否则返回 0
            if thisProcessJPinSMSRow==size(thisProcessJPSameMachineSchedule,1) %如果在最后一行，则JP的MS不存在，则将JP加入待调度序列
                schedule(thisProcessJPRow,7)=0;
            else
                % 找到JP的MS的调度表
                thisProcessJPMSSchedule=thisProcessJPSameMachineSchedule(thisProcessJPinSMSRow+1,:); 
                % thisProcessJSMSSchedule=schedule(thisProcessJSRow-1,:);
                if thisProcessJPMSSchedule(1,7)==1 % 如果JS的MP也已经标记了，则也将JS加入待调度序列  
                    schedule(thisProcessJPRow,7)=0;
                end
            end
        end

        % 再找MP的JS的
        % 首先找到MP 还是先判断MP的存在吧
        if thisProcessInSMSRow~=1 %如果x 不是 机器的第一道工序 即MP存在
            thisProcessMPSchedule=sameMachineSchedule(thisProcessInSMSRow-1,:);
            % 然后找到MP的JS
            thisProcessMPJSIndex=ismember(schedule(:,1:2),[thisProcessMPSchedule(1,1),thisProcessMPSchedule(1,2)+1],'rows');
            thisProcessMPJSRow=find(thisProcessMPJSIndex); %如果MS的JP存在，返回其在 schedule 中的行数，否则，返回 0
            if isempty(thisProcessMPJSRow) %如MP的JS不存在 将MP加入待排序序列 如MP的JS已经调度 则将MP加入待调度序列
                schedule(thisProcessMPSchedule(1,8),7)=0;
            else
                if schedule(thisProcessMPJSRow,7)==1  %
                    schedule(thisProcessMPSchedule(1,8),7)=0;
                end
            end
        end

    end
    newSchedule=[schedule(:,1:6),schedule(:,9)];
end































    
