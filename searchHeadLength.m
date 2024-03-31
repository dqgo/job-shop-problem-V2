% 寻找最大弧数函数 函数接受一个矩阵参数schedule 返回一个矩阵newSchedule 定义如下：
% 接受schedule=[1工件号 2工件工序号 3机器号 4开工时间 5完工时间 6关键工序标志位]
% ！！条件1：接受的schedule应当在每台机器上由时间升序安排！
% 返回newSchedule=[1工件号 2工件工序号 3机器号 4开工时间 5完工时间 6关键工序标志位 7头长]
% 中间schedule=[7标记位 8索引位 9头长]
% ！！注意：返回的newSchedule是强制转换之后的！没有标准化！！！！
function newSchedule = searchHeadLength(schedule)
    % 初始化schedule 使其强制能满足条件1
    schedule=sortrows(schedule,[3,4]);
    schedule(:,7)=-1; %是否已经调度的标志位 -1为没调度 0为待调度，1为已调度 初始化为-1
    schedule(:,8)=1:size(schedule,1); %索引位
    schedule(:,9)=0; %头长位 初始化为0
    jobFirstProcessSchedule=schedule(schedule(:,2)==1,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 对于每个工件的首工序𝑂𝑖1(1 ≤ 𝑖 ≤ 𝑛), 若 M𝑃[𝑂𝑖1] = 0, 则𝑆𝑁 = 𝑆𝑁 ∪ {𝑂𝑖1} 
    % 即是机器的第一道工序，加入待调度队列
    for i=1:size(jobFirstProcessSchedule,1)
        thisProcessSchedule=jobFirstProcessSchedule(i,:);
        % 找到每一个的MP
        thisProcessSameMachineSchedule=schedule(schedule(:,3)==thisProcessSchedule(1,3),:);
        thisProcessInSMSIndex=ismember(thisProcessSameMachineSchedule(:,1:2),[thisProcessSchedule(1,1),thisProcessSchedule(1,2)],'rows');
        thisProcessInSMSrow=find(thisProcessInSMSIndex);
        if thisProcessInSMSrow==1
            schedule(thisProcessSchedule(1,8),7)=0;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while(size(schedule(schedule(:,7)==0,7),1)~=0) %如果待调度序列还有时：
        nowSNSchedule=schedule(schedule(:,7)==0,:);
        point=randperm(size(nowSNSchedule,1),1);
        thisProcessSchedule=nowSNSchedule(point,:);
        % 𝑟𝑥 = max{𝑟𝐽𝑃[𝑥] + 𝑝𝐽𝑃[𝑥] , 𝑟𝑀𝑃[𝑥] + 𝑝𝑀𝑃[𝑥]}; 
        % 需要求得 thisPointJPSchedule 和 thisPointMPSchedule

        % 寻找JP
        thisPointJPScheduleIndex=ismember(schedule(:,1:2),[nowSNSchedule(point,1),nowSNSchedule(point,2)-1],'rows');
        thisPointJPScheduleRow=find(thisPointJPScheduleIndex); %如果找到了前道工序，返回其在schedule中的行数，否则，返回0
        if ~isempty(thisPointJPScheduleRow) %如果找到了JP
            thisPointJPSchedule=schedule(thisPointJPScheduleRow,:);
            JPHeadLength=thisPointJPSchedule(1,9);
            JPSpeedTime=thisPointJPSchedule(1,5)-thisPointJPSchedule(1,4);
        else %没找到JP 即point是工件的第一道工序
            JPHeadLength=0;
            JPSpeedTime=0;
        end

        % 现在开始寻找MP
        sameMachineSchedule=schedule(schedule(:,3)==thisProcessSchedule(1,3),:);
        findThisProcessInSMSRowIndex=ismember(sameMachineSchedule(:,8),thisProcessSchedule(1,8),'rows');
        thisProcessInSMSRow=find(findThisProcessInSMSRowIndex); %找到当前工序在同机器排产表中的行数
        if thisProcessInSMSRow==1 %如果是第一行，则MP不存在
            MPHeadLength=0;
            MPSpeedTime=0;
        else
            % MPHeadLength=schedule(sameMachineSchedule(thisProcessInSMSRow-1,8),9);
            thisPointMPSchedule=schedule(sameMachineSchedule(thisProcessInSMSRow-1,8),:);
            MPHeadLength=thisPointMPSchedule(1,9);
            MPSpeedTime=thisPointMPSchedule(1,5)-thisPointMPSchedule(1,4);
        end

        %更新最大弧数、标记位
        schedule(nowSNSchedule(point,8),9)=max(JPHeadLength+JPSpeedTime,MPHeadLength+MPSpeedTime);
        schedule(nowSNSchedule(point,8),7)=1;

        % 现在开始加入新的SN  
        % 先找JS的MP的
        % 首先找到JS 这里需不需要检查JS是否存在的？ --先整一个判断存在的吧        
        thisProcessJSIndex=ismember(schedule(:,1:2),[thisProcessSchedule(1,1),thisProcessSchedule(1,2)+1],'rows');
        thisProcessJSRow=find(thisProcessJSIndex); %返回 在schedule 中的行数，否则返回 0
        if ~isempty(thisProcessJSRow) %如果JS存在
            %现在寻找JS的MP
            thisProcessJSSchedule=schedule(thisProcessJSRow,:);
            thisProcessJSSameMachineSchedule=schedule(schedule(:,3)==thisProcessJSSchedule(1,3),:);
            % 找到JS所在SMS中的行索引
            thisProcessJSinSMSIndex=ismember(thisProcessJSSameMachineSchedule(:,8),thisProcessJSSchedule(1,8),'rows');
            thisProcessJSinSMSRow=find(thisProcessJSinSMSIndex); %存在返回 在 SMS 中的行数，否则返回 0
            if thisProcessJSinSMSRow==1 %如果在第一行，则JS的MP不存在，则将JS加入待调度序列
                schedule(thisProcessJSRow,7)=0;
            else
                % 找到JS的MP的调度表
                thisProcessJSMPSchedule=thisProcessJSSameMachineSchedule(thisProcessJSinSMSRow-1,:); 
                % thisProcessJSMPSchedule=schedule(thisProcessJSRow-1,:);
                if thisProcessJSMPSchedule(1,7)==1 % 如果JS的MP也已经标记了，则也将JS加入待调度序列  
                    schedule(thisProcessJSRow,7)=0;
                end
            end
        end

        % 再找MS的JP的
        % 首先找到MS 还是先判断MS的存在吧
        if thisProcessInSMSRow~=size(sameMachineSchedule,1) %如果x 不是 机器的最后一道工序 即MS存在
            thisProcessMSSchedule=sameMachineSchedule(thisProcessInSMSRow+1,:);
            % 然后找到MS的JP
            thisProcessMSJPIndex=ismember(schedule(:,1:2),[thisProcessMSSchedule(1,1),thisProcessMSSchedule(1,2)-1],'rows');
            thisProcessMSJPRow=find(thisProcessMSJPIndex); %如果MS的JP存在，返回其在 schedule 中的行数，否则，返回 0
            if isempty(thisProcessMSJPRow) %如MS的JP不存在 将MS加入待排序序列 如MS的JP已经调度 则将MS加入待调度序列
                schedule(thisProcessMSSchedule(1,8),7)=0;
            else
                if schedule(thisProcessMSJPRow,7)==1  %
                    schedule(thisProcessMSSchedule(1,8),7)=0;
                end
            end
        end

    end
    newSchedule=[schedule(:,1:6),schedule(:,9)];
end












% 用时测试
% tic
% thisProcessInSMSIndex=ismember(thisProcessSameMachineSchedule(:,1:2),[thisProcessSchedule(1,1),thisProcessSchedule(1,2)],'rows');
% toc
% all(thisProcessSameMachineSchedule(:,1:2) == [thisProcessSchedule(1,1),thisProcessSchedule(1,2)], 2);
% toc
% a=thisProcessSameMachineSchedule([thisProcessSameMachineSchedule(:,1)==thisProcessSchedule(1,1)&thisProcessSameMachineSchedule(:,2)==thisProcessSchedule(1,2)],:);
% toc

















    
