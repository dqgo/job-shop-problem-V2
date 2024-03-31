% %逆解码，生成一个反向序列
% %以Cmax为基准生成
% % 工件ID 工件工序ID 机器ID 开始时间 结束时间
 function schedule2=createFlipSchedule(changeData,chromo,workpieceNum,machNum,Cmax)
 %    flippedChangeDataStep1 = flip(changeData, 2);
 %    numCols = size(flippedChangeDataStep1, 2);
 %    flippedChangeData(:, 1:2:numCols) = flippedChangeDataStep1(:, 2:2:numCols);
 %    flippedChangeData(:, 2:2:numCols) = flippedChangeDataStep1(:, 1:2:numCols);
 %    flipChromo=flip(chromo);
 %    schedule2=createSchedule(changeData,chromo,workpieceNum,machNum);
 % end
    lengthChromo=size(chromo,2);
    schedule2=zeros(lengthChromo,5);
    workpieceProcessId(1,1:workpieceNum)=machNum;
    workpieceCanEndTime(1,1:workpieceNum)=Cmax;%工件工序可结束时间，也就是下道工序的开始时间
    for i=lengthChromo:-1:1
        workpieceId=chromo(i);
        %workpieceProcessId(workpieceId)=workpieceProcessId(workpieceId)-1;
        machId=changeData(workpieceId,2*workpieceProcessId(workpieceId)-1);
        workpieceSpeedTime=changeData(workpieceId,2*workpieceProcessId(workpieceId));
        newSchedule=schedule2(schedule2(:,3)==machId,:);
        isInsert=0;
        if size(newSchedule,1)==0 %空的 直接从Cmax基准安排
            % workpieceEndTime=Cmax;
            % workpieceStartTime=Cmax-workpieceSpeedTime;
            % isInsert=1;
            if workpieceProcessId(1,workpieceId)==machNum %这是改工件的最后一道工序，直接从Cmax开始安排
                workpieceEndTime=Cmax;
                workpieceStartTime=Cmax-workpieceSpeedTime;
                isInsert=1;
            else %如果不是的话，从工件的下道工序开始时间安排
                workpieceEndTime=workpieceCanEndTime(1,workpieceId);
                workpieceStartTime=workpieceEndTime-workpieceSpeedTime;  %%%%%%%workpieceStartTime=Cmax-workpieceSpeedTime   15点23分
                isInsert=1;
            end
        else
            newSchedule=sortrows(newSchedule,4);
            % if workpieceCanEndTime(1,workpieceId)>=newSchedule(1,5)+workpieceSpeedTime %下道工序的开始时间>=机器的空闲的开始时间+这道工序耗费的时间
            %     workpieceEndTime=workpieceCanEndTime(1,workpieceId);
            %     workpieceStartTime=workpieceEndTime-workpieceSpeedTime;
            %     isInsert=1;                
            % end
            if newSchedule(end,5)+workpieceSpeedTime<workpieceCanEndTime(workpieceId) %机器的空闲开始时间+工序的耗费时间小于工件的下道工序开始时间，可以插入
                workpieceEndTime=workpieceCanEndTime(workpieceId);
                workpieceStartTime=workpieceEndTime-workpieceSpeedTime;
                isInsert=1;
            end
            if isInsert==0 %没插进去，开始遍历
                % if newSchedule(j,5)+workpieceSpeedTime>=min(newSchedule(j-1,4),workpieceCanEndTime(workpieceId)) %机器的空闲开始时间+花费的时间<=min(机器空闲的结束时间，机器下一道工序的开始时间)
                %     %这道工序的结束时间= min(机器空闲的结束时间，机器下一道工序的开始时间)。插进去，就设置bool表示已经插了，然后break这个循环。
                %     workpieceEndTime=min(newSchedule(j-1,4),workpieceCanEndTime(workpieceId));
                %     workpieceStartTime=workpieceEndTime-workpieceSpeedTime;
                %     isInsert=1;
                %     break;
                % end
                for j=size(newSchedule):-1:2
                    if newSchedule(j-1,5)+workpieceSpeedTime<=min(newSchedule(j,4),workpieceCanEndTime(workpieceId))
                        workpieceEndTime=min(newSchedule(j,4),workpieceCanEndTime(workpieceId));
                        workpieceStartTime=workpieceEndTime-workpieceSpeedTime;
                        isInsert=1;
                        break;
                    end
                end
            end
            % if isInsert==0 %遍历完了还没有插进去 插到最后一行
            %     workpieceEndTime=min(newSchedule(end,4),workpieceCanEndTime(workpieceId)); %工件的结束时间=min（空闲的结束时间，工件下道工序的开工时间）
            %     workpieceStartTime=workpieceEndTime-workpieceSpeedTime;
            % end
            if isInsert==0 %遍历完了还没插进去，就查到第一行
                workpieceEndTime=min(newSchedule(1,4),workpieceCanEndTime(workpieceId));
                workpieceStartTime=workpieceEndTime-workpieceSpeedTime;
            end
        end
        %在此已经完成插入了，要更新各个表单
        workpieceCanEndTime(workpieceId)=workpieceStartTime;%更新开始时间表
        schedule2(i,:)=[workpieceId,workpieceProcessId(workpieceId),machId,workpieceStartTime,workpieceEndTime];
        workpieceProcessId(workpieceId)=workpieceProcessId(workpieceId)-1;

    end



    % workpieceProcessId=zeros(1,workpieceNum);
    % workpieceCanStartTime=zeros(1,workpieceNum);
    % for i=1:lengthChromo
    %     workpieceId=chromo(i);
    %     workpieceProcessId(workpieceId)=workpieceProcessId(workpieceId)+1;
    %     machId=changeData(workpieceId,2*workpieceProcessId(workpieceId)-1);
    %     workpieceSpeedTime=changeData(workpieceId,2*workpieceProcessId(workpieceId));
    %     newSchedule=schedule2(schedule2(:,3)==machId,:);
    %     isInsert=0;
    %     if size(newSchedule,1)==0 %空的 直接从Cmax基准安排
    %         workpieceEndTime=Cmax;
    %         workpieceStartTime=Cmax-workpieceSpeedTime;
    %         isInsert=1;
    %     else
    %         newSchedule=sortrows(newSchedule,5,'descend'); %排序一下,这里要降序排序，并且要以结束时间排序
    %         %首先看第一行
    %         if Cmax-max(workpieceCanStartTime,newSchedule(1,5))>=workpieceSpeedTime
    %             workpieceEndTime=newSchedule(1,4);%紧挨着空闲结束时间，也就是第一行的加工的开始时间
    %             workpieceStartTime=workpieceEndTime-workpieceSpeedTime;
    %             isInsert=1;
    %         end    
    %         if isInsert==0 %开始从第二行遍历
    %             for j=2:size(newSchedule,1)
    %                 if newSchedule(i,4)-max(workpieceCanStartTime,newSchedule(i-1,5))>=workpieceSpeedTime
    % 
    %                 end
    %             end
    % 
    %         end
    %     end
    % end

% end
% 