function [standardizationChromo,schedule1,schedule2]= createRightScheduleV2(schedule1,Cmax,workpieceNum,machNum)
    % schedule2 应该与 standardizationChromo 是一一对应关系
    %主动解码染色体标准化
    % standardizationChromo=schedule1(:,1)';
    schedule1=sortrows(schedule1,4);
    standardizationChromo=schedule1(:,1)';
    schedule2=nan(size(schedule1,1),5);

    % 右移部分V1相同
    for i=size(schedule1,1):-1:1
        thisWorkpieceId=schedule1(i,1);
        thisWorkpieceProcessId=schedule1(i,2);
        thisWorkpieceMachId=schedule1(i,3);
        thisWorkpieceSpeedTime=schedule1(i,5)-schedule1(i,4);
        findmachIsEmpty=schedule2(schedule2(:,3)==thisWorkpieceMachId,:);
        if isempty(findmachIsEmpty) %If 他是这个机器的最后一道工序
            if thisWorkpieceProcessId==machNum %If 他是这个工件的最后一个工序
                schedule2(i,:)=[schedule1(i,1:3),Cmax-thisWorkpieceSpeedTime,Cmax]; %直接右移到Cmax
            else %不是最后一道工序 右移到工件下一道工序的开始时间
                findNST=schedule2(schedule2(:,1)==thisWorkpieceId,:);
                nextWorkpieceStartTime=min(findNST(:,4));
                schedule2(i,:)=[schedule1(i,1:3),nextWorkpieceStartTime-thisWorkpieceSpeedTime,nextWorkpieceStartTime];
            end
        else %不是机器的最后一道工序
            findMOkT=schedule2(schedule2(:,3)==thisWorkpieceMachId,:);
            machIsOkTime=min(findMOkT(:,4));
            if thisWorkpieceProcessId==machNum %是工件的最后一道工序
               schedule2(i,:)=[schedule1(i,1:3),machIsOkTime-thisWorkpieceSpeedTime,machIsOkTime]; %右移到从这道工序开始的机器空闲的结束时间
            else 
                findNST=schedule2(schedule2(:,1)==thisWorkpieceId,:);
                nextWorkpieceStartTime=min(findNST(:,4));
                %右移到min(下一道工序的开始时间，从这道工序开始的机器空闲的结束时间)
                right=min(nextWorkpieceStartTime,machIsOkTime);
                schedule2(i,:)=[schedule1(i,1:3),right-thisWorkpieceSpeedTime,right];
            end
        end
    end

    % schedule2=[schedule2,index];
    % schedule2=sortrows(schedule2,6);
    % schedule2=schedule2(:,1:5);
end



        % findNST=scheduleNew(scheduleNew(:,1)==thisWorkpieceId,:);
        % nextWorkpieceStartTime=min(findNst(:,4));
        % findMOkT=scheduleNew(scheduleNew(:,3)==thisWorkpieceMachId,:);
        % machIsOkTime=min(findMOkT(:,4));