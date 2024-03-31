%% 函数输入对应的染色体和他的关键块 输出他的所有N7邻域操作之后的邻域染色体、排产表
% keyBlock是元胞keyBlock{}=[在染色体上的位置]
% keyPath=[机器号 在染色体上的位置]
% 全局不能变动schedule的顺序！！
% 接受schedule=[1工件号 2工序号 3机器号 4开工时间 5完工时间 6关键工序标志位]
% 返回neighborhoodSchedule=[1工件号 2工序号 3机器号 4开工时间 5完工时间 6关键工序标志位 7被其他函数占用 8变动工序标志位]
% 返回neighborhoodSign 0是v移动到u之前 1是u移动到v之后  -1是没有移动，即原始解
% 这是N7基于机器的移动 可行解判断v2 弱类型
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [neighborhoodChromos,neighborhoodSchedule,neighborhoodSign]=creatneighborhoodChromosN7v_Schedule(chromo,keyBlock,schedule,keyPath)
    schedule(keyPath(:,2),6)=1; % 从这里schedule变为六列，第六列为逻辑值，表示其是否是关键工序
    neighborhoodChromos=chromo;
    schedule=sortrows(schedule,4);
    blockNum=size(keyBlock,2);
    schedule(:,8)=-1;
    neighborhoodSchedule=schedule;
    neighborhoodSign=-1;
    for i=1:blockNum
        thisBlock=keyBlock{i};
        sizeBlock=size(thisBlock,2);
        if sizeBlock==2  % 2互换即可
            thisBlockScheule=schedule(thisBlock,:);
            newSchedule=schedule;
            swap1=[thisBlockScheule(2,1:3),thisBlockScheule(1,4),thisBlockScheule(1,4)+(thisBlockScheule(2,5)-thisBlockScheule(2,4)),1,2,2];%这是v
            swap2=[thisBlockScheule(1,1:3),swap1(1,5),swap1(1,5)+(thisBlockScheule(1,5)-thisBlockScheule(1,4)),1,0,0];%这是u
            newScheduleBlock=[swap1;swap2];
            newSchedule(thisBlock,:)=newScheduleBlock;
            % 这里互换用的判断方法是： u在v前，如果L（0.u）+pu》=L（0，jp【v】） 则v移动到u之前为可行解
            % u这里是 thisblockschedule1 v是2 首先找到 jsv
            blockVJPIndex=ismember(schedule(:,1:2),[thisBlockScheule(2,1),thisBlockScheule(2,2)-1],'rows');
            blockVJPRow=find(blockVJPIndex);%如果有前序工序，则返回JP的所在行数，否则，返回0
            if blockVJPRow %如果jpv存在
                if thisBlockScheule(1,5)>=schedule(blockVJPRow,4) %是可行解  %最后处理这个，是否需要可行解判断
                    newSchedule=sortrows(newSchedule,4);
                    chromoTemp=newSchedule(:,1)';
                    neighborhoodChromos=[neighborhoodChromos;chromoTemp];
                    neighborhoodSchedule=cat(3,neighborhoodSchedule,newSchedule);
                    neighborhoodSign=[neighborhoodSign;0];
                end
            end
        else

            % 从这里开始都是关键块大小大于等于3的情况
            thisBlockScheule=schedule(thisBlock,:);     
           
            
            % 一、if块首工序的工件前任工序在关键路径上(只需要判断一次) 
            blockStart=schedule(thisBlock(1),:); %块首工序
            % 找到块首工序的JP
            % blcokStartJP=schedule(all([schedule(:,1)==blockStart(1,1) schedule(:,2)==blockStart(1,2)-1]),:);
            blockStartJPIndex=ismember(schedule(:,1:2),[blockStart(1,1),blockStart(1,2)-1],'rows');
            blockStartJPRow=find(blockStartJPIndex);%如果有前序工序，则返回JP的所在行数，否则，返回0
            if blockStartJPRow %有前序工序
                % 现在鉴定前序工序是否也是关键工序
                if schedule(blockStartJPRow,6) %非0则是关键工序
                    % 独立的将每个块内工序移到块首之前，移动工序生成邻域解 ---内移首  v移动到u之前
                    for point=2:sizeBlock-1
                        % %内移首
                        startFlipThisBlockScheduleId=[point,1:point-1,point+1:sizeBlock];
                        newscheduleStart=schedule;
                        thisBlockStartFlip=thisBlockScheule(startFlipThisBlockScheduleId,:);
                        thisBlockStartNew=[];
                        thisBlockStartNew(point+1:sizeBlock,:)=thisBlockStartFlip(point+1:sizeBlock,:);%先把没动的复制过来，再考虑动的
                        for st=point:-1:1
                            stTime=thisBlockStartNew(st+1,4);%安排完块的开始时间
                            thisBlockStartNew(st,1:3)=thisBlockStartFlip(st,1:3);
                            thisBlockStartNew(st,4:5)=[stTime-(thisBlockStartFlip(st,5)-thisBlockStartFlip(st,4)),stTime];
                        end
                        thisBlockStartNew(3:point,8)=1; %这是中间的
                        thisBlockStartNew(1,8)=2; %这是v
                        thisBlockStartNew(2,8)=0; %这是u
                        newscheduleStart(thisBlock,:)=thisBlockStartNew;
                        % isOk=isOkTest(newscheduleStart,thisBlockStartNew,sizeBlock);
                        % if isOk
                        newscheduleStart=sortrows(newscheduleStart,4);
                        chromoTempStart=newscheduleStart(:,1)';
                        neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
                        neighborhoodSchedule=cat(3,neighborhoodSchedule,newscheduleStart);
                        neighborhoodSign=[neighborhoodSign;0];
                    end
                end
            end


                    %     % %内移首
                    %     startFlipThisBlockScheduleId=[point,1:point-1,point+1:sizeBlock];
                    %     newscheduleStart=schedule;
                    %     thisBlockStartFlip=thisBlockScheule(startFlipThisBlockScheduleId,:);
                    %     thisBlockStartNew=[];
                    %     thisBlockStartNew(point+1:sizeBlock,:)=thisBlockStartFlip(point+1:sizeBlock,:);%先把没动的复制过来，再考虑动的
                    %     for st=point:-1:1
                    %         stTime=thisBlockStartNew(st+1,4);%安排完块的开始时间
                    %         thisBlockStartNew(st,1:3)=thisBlockStartFlip(st,1:3);
                    %         thisBlockStartNew(st,4:5)=[stTime-(thisBlockStartFlip(st,5)-thisBlockStartFlip(st,4)),stTime];
                    %     end 
                    %     newscheduleStart(thisBlock,:)=thisBlockStartNew;
                    %     % isOk=isOkTest(newscheduleStart,thisBlockStartNew,sizeBlock);
                    %     % if isOk
                    %     newscheduleStart=sortrows(newscheduleStart,4);
                    %     chromoTempStart=newscheduleStart(:,1)';
                    %     neighborhoodChromos=[neighborhoodChromos;chromoTempStart];

               
            % 二、块尾工序的工件后续工序在关键路径上(判断一次)
            % 对块尾工序，检查其JS是否存在，如存在，检查其是否在关键路径上
            blockEnd=schedule(thisBlock(sizeBlock),:);
            % 找到JS
            blockEndJSIndex=ismember(schedule(:,1:2),[blockEnd(1,1),blockEnd(1,2)+1],'rows');
            blockEndJSRows=find(blockEndJSIndex);
            if blockEndJSRows
                if schedule(blockEndJSRows,6)
                    % --内移尾 u移动到了v之后
                    for point=2:sizeBlock-1
                        endFlipThisBlockScheduleId=[1:point-1,point+1:sizeBlock,point];
                        newscheduleEnd=schedule;
                        thisBlockEndFlip=thisBlockScheule(endFlipThisBlockScheduleId,:);
                        thisBlockEndNew=thisBlockEndFlip(1:point-1,:);%先把没动的复制过来，再考虑动的
                        for re=point:sizeBlock
                            reTime=thisBlockEndNew(end,5);%剩余块的开始时间
                            thisBlockEndNew(re,1:3)=thisBlockEndFlip(re,1:3);
                            thisBlockEndNew(re,4:5)=[reTime,reTime+(thisBlockEndFlip(re,5)-thisBlockEndFlip(re,4))];
                        end
                        thisBlockEndNew(sizeBlock-1,8)=2;
                        thisBlockEndNew(point:sizeBlock-2,8)=1;
                        thisBlockEndNew(sizeBlock,8)=0;
                        newscheduleEnd(thisBlock,:)=thisBlockEndNew;
                        % isOk=isOkTest(newscheduleEnd,thisBlockEndNew,sizeBlock);
                        % if isOk
                        newscheduleEnd=sortrows(newscheduleEnd,4);
                        chromoTempEnd=newscheduleEnd(:,1)';
                        neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
                        neighborhoodSchedule=cat(3,neighborhoodSchedule,newscheduleEnd);
                        neighborhoodSign=[neighborhoodSign;1];
                        % end
                    end
                end
            end

            % 三、块内工序的工件后续工序在关键路径 --首移内 块后
            % 对每一个块内工序，找到其是否有后续工序，若有，检查其是否在关键路径上
            for point=2:sizeBlock-1
                thisPiece=schedule(thisBlock(point),:);
                % 找到该工序的下一道工序
                thisPieceJSIndex=ismember(schedule(:,1:2),[thisPiece(1,1),thisPiece(1,2)+1],'rows');
                thisPieceJSRow=find(thisPieceJSIndex);%如果有hou 序工序，则返回JS的所在行数，否则，返回0
                if thisPieceJSRow %如果有后续工序
                    % 现在检查JS是否也是关键工序
                    if schedule(thisPieceJSRow,6)
                        % 首移内 块后
                        % %首移内 u移动到了v之后
                        startFlipThisBlockScheduleId=[2:point,1,point+1:sizeBlock];
                        newscheduleStart=schedule;
                        thisBlockStartFlip=thisBlockScheule(startFlipThisBlockScheduleId,:);
                        thisBlockStartNew=[];
                        thisBlockStartNew(point+1:sizeBlock,:)=thisBlockStartFlip(point+1:sizeBlock,:);%先把没动的复制过来，再考虑动的
                        for st=point:-1:1
                            stTime=thisBlockStartNew(st+1,4);%安排完块的开始时间
                            thisBlockStartNew(st,1:3)=thisBlockStartFlip(st,1:3);
                            thisBlockStartNew(st,4:5)=[stTime-(thisBlockStartFlip(st,5)-thisBlockStartFlip(st,4)),stTime];
                        end
                        thisBlockStartNew(1:point-2,8)=1;
                        thisBlockStartNew(point-1,8)=2;
                        thisBlockStartNew(point,8)=0;
                        newscheduleStart(thisBlock,:)=thisBlockStartNew;
                        newscheduleStart=sortrows(newscheduleStart,4);
                        chromoTempStart=newscheduleStart(:,1)';
                        neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
                        neighborhoodSchedule=cat(3,neighborhoodSchedule,newscheduleStart);
                        neighborhoodSign=[neighborhoodSign;1];
                        % end
                    end
                end
            end


            % 四、块内工序的工件前序工序在关键路径上
            % 对每一个块内工序，找到其是否有前续工序，若有，检查其是否在关键路径上
            for point=2:sizeBlock-1
                thisPiece=schedule(thisBlock(point),:);
                % 找到该工序的下一道工序
                thisPieceJPIndex=ismember(schedule(:,1:2),[thisPiece(1,1),thisPiece(1,2)-1],'rows');
                thisPieceJPRow=find(thisPieceJPIndex);%如果有前序工序，则返回JP的所在行数，否则，返回0
                if thisPieceJPRow %如果有后续工序
                    % 现在检查JP是否也是关键工序
                    if schedule(thisPieceJPRow,6)
                        % 尾移内 块前 v移动到了u之前
                        endFlipThisBlockScheduleId=[1:point-1,sizeBlock,point:sizeBlock-1];
                        newscheduleEnd=schedule;
                        thisBlockEndFlip=thisBlockScheule(endFlipThisBlockScheduleId,:);
                        thisBlockEndNew=thisBlockEndFlip(1:point-1,:);%先把没动的复制过来，再考虑动的
                        for re=point:sizeBlock
                            reTime=thisBlockEndNew(end,5);%剩余块的开始时间
                            thisBlockEndNew(re,1:3)=thisBlockEndFlip(re,1:3);
                            thisBlockEndNew(re,4:5)=[reTime,reTime+(thisBlockEndFlip(re,5)-thisBlockEndFlip(re,4))];
                        end
                        thisBlockEndNew(point,8)=2;
                        thisBlockEndNew(point+1,8)=0;
                        thisBlockEndNew(point+2:sizeBlock,8)=1;
                        newscheduleEnd(thisBlock,:)=thisBlockEndNew;
                        newscheduleEnd=sortrows(newscheduleEnd,4);
                        chromoTempEnd=newscheduleEnd(:,1)';
                        neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
                        neighborhoodSchedule=cat(3,neighborhoodSchedule,newscheduleEnd);
                        neighborhoodSign=[neighborhoodSign;0];
                    end
                end
            end

        end
    end
end
function moveKeyBlock = moveFirst(keyBlock,point)
    % 将第一个元素移动到数组的第point个位置
    point = point+1;
    % 保存第一个元素的值
    elementToMove = keyBlock(1);
    % 移动其他元素以腾出空间
    keyBlock = [keyBlock(2:point-1), elementToMove, keyBlock(point:end)];
    moveKeyBlock=keyBlock;
end

function moveKeyBlock = moveEnd(keyBlock,point)
    % 保存最后一个元素的值
    elementToMove = keyBlock(end);
    % 移动其他元素以腾出空间
    keyBlock = [keyBlock(1:point-1), elementToMove, keyBlock(point:end-1)];
    moveKeyBlock=keyBlock;
end

function chromo = swapX(id1,id2,chromo)
    temp=chromo(1,id1);
    chromo(1,id1)=chromo(1,id2);
    chromo(1,id2)=temp;
end

function isOk = isOkTest(schedule,blockSchedule,sizeBlock)
    isOk=true;
    for i=1:sizeBlock
        thisPossece=blockSchedule(i,:);
        thisPossecePoire=schedule(schedule(:,1)==thisPossece(1)&schedule(:,2)==thisPossece(2)-1,:);
        thisPosseceNext=schedule(schedule(:,1)==thisPossece(1)&schedule(:,2)==thisPossece(2)+1,:);
        if ~isempty(thisPosseceNext)
            if thisPosseceNext(4)<thisPossece(5)
                isOk=false;
                break;
            end
        end

        if ~isempty(thisPossecePoire)
            if thisPossecePoire(5)>thisPossece(4)
                isOk=false;
                break;
            end
        end
        % if thisPosseceNext(5)>thisPossece(4)||thisPosseceNext(4)<thisPossece(5)
        %     isOk=false;
        %     break;
        % end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









% 内移首

                    % for point=2:sizeBlock-1
                    %     % %内移首
                    %     startFlipThisBlockScheduleId=[point,1:point-1,point+1:sizeBlock];
                    %     newscheduleStart=schedule;
                    %     thisBlockStartFlip=thisBlockScheule(startFlipThisBlockScheduleId,:);
                    %     thisBlockStartNew=[];
                    %     thisBlockStartNew(point+1:sizeBlock,:)=thisBlockStartFlip(point+1:sizeBlock,:);%先把没动的复制过来，再考虑动的
                    %     for st=point:-1:1
                    %         stTime=thisBlockStartNew(st+1,4);%安排完块的开始时间
                    %         thisBlockStartNew(st,1:3)=thisBlockStartFlip(st,1:3);
                    %         thisBlockStartNew(st,4:5)=[stTime-(thisBlockStartFlip(st,5)-thisBlockStartFlip(st,4)),stTime];
                    %     end 
                    %     newscheduleStart(thisBlock,:)=thisBlockStartNew;
                    %     % isOk=isOkTest(newscheduleStart,thisBlockStartNew,sizeBlock);
                    %     % if isOk
                    %     newscheduleStart=sortrows(newscheduleStart,4);
                    %     chromoTempStart=newscheduleStart(:,1)';
                    %     neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
                    %     % end
                    % end
























% % 这是N7基于机器的移动?，且有了可行解判断
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function neighborhoodChromos=creatneighborhoodChromosN7(chromo,keyBlock,schedule)
%     neighborhoodChromos=chromo;
%     schedule=sortrows(schedule,4);
%     blockNum=size(keyBlock,2); 
%     if blockNum==0
%         neighborhoodChromos=chromo;
%     end
%     for i=1:blockNum
%         chromosTemp=zeros(0);
%         thisBlock=keyBlock{i};
%         sizeBlock=size(thisBlock,2);
%         if sizeBlock==2
%             if all([i~=1,i~=blockNum])
%                 thisBlockScheule=schedule(thisBlock,:);
%                 newSchedule=schedule;
%                 swap1=[thisBlockScheule(2,1:3),thisBlockScheule(1,4),thisBlockScheule(1,4)+(thisBlockScheule(2,5)-thisBlockScheule(2,4))];
%                 swap2=[thisBlockScheule(1,1:3),swap1(1,5),swap1(1,5)+(thisBlockScheule(1,5)-thisBlockScheule(1,4))];
%                 newScheduleBlock=[swap1;swap2];
%                 newschedule(thisBlock,:)=newScheduleBlock;
%                 isOk = isOkTest(schedule,thisBlockScheule,sizeBlock);
%                 if isOk %是可行解
%                     newSchedule=sortrows(newSchedule,4);
%                     chromoTemp=newSchedule(:,1)';
%                     neighborhoodChromos=[neighborhoodChromos;chromoTemp];
%                 end
%             end
%         else
%             thisBlockScheule=schedule(thisBlock,:);     
%             if i==1&&i~=blockNum  
%                 for point=2:sizeBlock-1                    
%                     % 尾移内
%                     endFlipThisBlockScheduleId=[1:point-1,sizeBlock,point:sizeBlock-1];
%                     newscheduleEnd=schedule;
%                     thisBlockEndFlip=thisBlockScheule(endFlipThisBlockScheduleId,:);
%                     thisBlockEndNew=thisBlockEndFlip(1:point-1,:);%先把没动的复制过来，再考虑动的
%                     for re=point:sizeBlock
%                         reTime=thisBlockEndNew(end,5);%剩余块的开始时间
%                         thisBlockEndNew(re,1:3)=thisBlockEndFlip(re,1:3);
%                         thisBlockEndNew(re,4:5)=[reTime,reTime+(thisBlockEndFlip(re,5)-thisBlockEndFlip(re,4))];
%                     end
%                     newscheduleEnd(thisBlock,:)=thisBlockEndNew;
%                     isOk=isOkTest(newscheduleEnd,thisBlockEndNew,sizeBlock);
%                     if isOk
%                         newscheduleEnd=sortrows(newscheduleEnd,4);
%                         chromoTempEnd=newscheduleEnd(:,1)';
%                         neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
%                     end
% 
%                     % %内移尾
%                     endFlipThisBlockScheduleId=[1:point-1,point+1:sizeBlock,point];
%                     newscheduleEnd=schedule;
%                     thisBlockEndFlip=thisBlockScheule(endFlipThisBlockScheduleId,:);
%                     thisBlockEndNew=thisBlockEndFlip(1:point-1,:);%先把没动的复制过来，再考虑动的
%                     for re=point:sizeBlock
%                         reTime=thisBlockEndNew(end,5);%剩余块的开始时间
%                         thisBlockEndNew(re,1:3)=thisBlockEndFlip(re,1:3);
%                         thisBlockEndNew(re,4:5)=[reTime,reTime+(thisBlockEndFlip(re,5)-thisBlockEndFlip(re,4))];
%                     end
%                     newscheduleEnd(thisBlock,:)=thisBlockEndNew;
%                     isOk=isOkTest(newscheduleEnd,thisBlockEndNew,sizeBlock);
%                     if isOk
%                         newscheduleEnd=sortrows(newscheduleEnd,4);
%                         chromoTempEnd=newscheduleEnd(:,1)';
%                         neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
%                     end
%                 end
%             end
% 
%             if i==blockNum&&i~=1
%                 for point =2:sizeBlock-1
%                     % %首移内
%                     startFlipThisBlockScheduleId=[2:point,1,point+1:sizeBlock];
%                     newscheduleStart=schedule;
%                     thisBlockStartFlip=thisBlockScheule(startFlipThisBlockScheduleId,:);
%                     thisBlockStartNew=[];
%                     thisBlockStartNew(point+1:sizeBlock,:)=thisBlockStartFlip(point+1:sizeBlock,:);%先把没动的复制过来，再考虑动的
%                     for st=point:-1:1
%                         stTime=thisBlockStartNew(st+1,4);%安排完块的开始时间
%                         thisBlockStartNew(st,1:3)=thisBlockStartFlip(st,1:3);
%                         thisBlockStartNew(st,4:5)=[stTime-(thisBlockStartFlip(st,5)-thisBlockStartFlip(st,4)),stTime];
%                     end
%                     newscheduleStart(thisBlock,:)=thisBlockStartNew;
%                     isOk=isOkTest(newscheduleStart,thisBlockStartNew,sizeBlock);
%                     if isOk
%                         newscheduleStart=sortrows(newscheduleStart,4);
%                         chromoTempStart=newscheduleStart(:,1)';
%                         neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
%                     end
%                     % %内移首
%                     startFlipThisBlockScheduleId=[point,1:point-1,point+1:sizeBlock];
%                     newscheduleStart=schedule;
%                     thisBlockStartFlip=thisBlockScheule(startFlipThisBlockScheduleId,:);
%                     thisBlockStartNew=[];
%                     thisBlockStartNew(point+1:sizeBlock,:)=thisBlockStartFlip(point+1:sizeBlock,:);%先把没动的复制过来，再考虑动的
%                     for st=point:-1:1
%                         stTime=thisBlockStartNew(st+1,4);%安排完块的开始时间
%                         thisBlockStartNew(st,1:3)=thisBlockStartFlip(st,1:3);
%                         thisBlockStartNew(st,4:5)=[stTime-(thisBlockStartFlip(st,5)-thisBlockStartFlip(st,4)),stTime];
%                     end
%                     newscheduleStart(thisBlock,:)=thisBlockStartNew;
%                     isOk=isOkTest(newscheduleStart,thisBlockStartNew,sizeBlock);
%                     if isOk
%                         newscheduleStart=sortrows(newscheduleStart,4);
%                         chromoTempStart=newscheduleStart(:,1)';
%                         neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
%                     end
%                 end
%             end
% 
%             if i~=1&&i~=blockNum
%                 for point =2:sizeBlock-1
%                     % %首移内
%                     startFlipThisBlockScheduleId=[2:point,1,point+1:sizeBlock];
%                     newscheduleStart=schedule;
%                     thisBlockStartFlip=thisBlockScheule(startFlipThisBlockScheduleId,:);
%                     thisBlockStartNew=[];
%                     thisBlockStartNew(point+1:sizeBlock,:)=thisBlockStartFlip(point+1:sizeBlock,:);%先把没动的复制过来，再考虑动的
%                     for st=point:-1:1
%                         stTime=thisBlockStartNew(st+1,4);%安排完块的开始时间
%                         thisBlockStartNew(st,1:3)=thisBlockStartFlip(st,1:3);
%                         thisBlockStartNew(st,4:5)=[stTime-(thisBlockStartFlip(st,5)-thisBlockStartFlip(st,4)),stTime];
%                     end
%                     newscheduleStart(thisBlock,:)=thisBlockStartNew;
%                     isOk=isOkTest(newscheduleStart,thisBlockStartNew,sizeBlock);
%                     if isOk
%                         newscheduleStart=sortrows(newscheduleStart,4);
%                         chromoTempStart=newscheduleStart(:,1)';
%                         neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
%                     end
% 
%                     % %内移首
%                     startFlipThisBlockScheduleId=[point,1:point-1,point+1:sizeBlock];
%                     newscheduleStart=schedule;
%                     thisBlockStartFlip=thisBlockScheule(startFlipThisBlockScheduleId,:);
%                     thisBlockStartNew=[];
%                     thisBlockStartNew(point+1:sizeBlock,:)=thisBlockStartFlip(point+1:sizeBlock,:);%先把没动的复制过来，再考虑动的
%                     for st=point:-1:1
%                         stTime=thisBlockStartNew(st+1,4);%安排完块的开始时间
%                         thisBlockStartNew(st,1:3)=thisBlockStartFlip(st,1:3);
%                         thisBlockStartNew(st,4:5)=[stTime-(thisBlockStartFlip(st,5)-thisBlockStartFlip(st,4)),stTime];
%                     end
%                     newscheduleStart(thisBlock,:)=thisBlockStartNew;
%                     isOk=isOkTest(newscheduleStart,thisBlockStartNew,sizeBlock);
%                     if isOk
%                         newscheduleStart=sortrows(newscheduleStart,4);
%                         chromoTempStart=newscheduleStart(:,1)';
%                         neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
%                     end
% 
%                 end
%                 for point=2:sizeBlock-1                    
%                     % 尾移内
%                     endFlipThisBlockScheduleId=[1:point-1,sizeBlock,point:sizeBlock-1];
%                     newscheduleEnd=schedule;
%                     thisBlockEndFlip=thisBlockScheule(endFlipThisBlockScheduleId,:);
%                     thisBlockEndNew=thisBlockEndFlip(1:point-1,:);%先把没动的复制过来，再考虑动的
%                     for re=point:sizeBlock
%                         reTime=thisBlockEndNew(end,5);%剩余块的开始时间
%                         thisBlockEndNew(re,1:3)=thisBlockEndFlip(re,1:3);
%                         thisBlockEndNew(re,4:5)=[reTime,reTime+(thisBlockEndFlip(re,5)-thisBlockEndFlip(re,4))];
%                     end
%                     newscheduleEnd(thisBlock,:)=thisBlockEndNew;
%                     isOk=isOkTest(newscheduleEnd,thisBlockEndNew,sizeBlock);
%                     if isOk
%                         newscheduleEnd=sortrows(newscheduleEnd,4);
%                         chromoTempEnd=newscheduleEnd(:,1)';
%                         neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
%                     end
% 
%                     % %内移尾
%                     endFlipThisBlockScheduleId=[1:point-1,point+1:sizeBlock,point];
%                     newscheduleEnd=schedule;
%                     thisBlockEndFlip=thisBlockScheule(endFlipThisBlockScheduleId,:);
%                     thisBlockEndNew=thisBlockEndFlip(1:point-1,:);%先把没动的复制过来，再考虑动的
%                     for re=point:sizeBlock
%                         reTime=thisBlockEndNew(end,5);%剩余块的开始时间
%                         thisBlockEndNew(re,1:3)=thisBlockEndFlip(re,1:3);
%                         thisBlockEndNew(re,4:5)=[reTime,reTime+(thisBlockEndFlip(re,5)-thisBlockEndFlip(re,4))];
%                     end
%                     newscheduleEnd(thisBlock,:)=thisBlockEndNew;
%                     isOk=isOkTest(newscheduleEnd,thisBlockEndNew,sizeBlock);
%                     if isOk
%                         newscheduleEnd=sortrows(newscheduleEnd,4);
%                         chromoTempEnd=newscheduleEnd(:,1)';
%                         neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% function moveKeyBlock = moveFirst(keyBlock,point)
%     % 将第一个元素移动到数组的第point个位置
%     point = point+1;
%     % 保存第一个元素的值
%     elementToMove = keyBlock(1);
%     % 移动其他元素以腾出空间
%     keyBlock = [keyBlock(2:point-1), elementToMove, keyBlock(point:end)];
%     moveKeyBlock=keyBlock;
% end
% 
% function moveKeyBlock = moveEnd(keyBlock,point)
%     % 保存最后一个元素的值
%     elementToMove = keyBlock(end);
%     % 移动其他元素以腾出空间
%     keyBlock = [keyBlock(1:point-1), elementToMove, keyBlock(point:end-1)];
%     moveKeyBlock=keyBlock;
% end
% 
% function chromo = swapX(id1,id2,chromo)
%     temp=chromo(1,id1);
%     chromo(1,id1)=chromo(1,id2);
%     chromo(1,id2)=temp;
% end
% 
% function isOk = isOkTest(schedule,blockSchedule,sizeBlock)
%     isOk=true;
%     for i=1:sizeBlock
%         thisPossece=blockSchedule(i,:);
%         thisPossecePoire=schedule(schedule(:,1)==thisPossece(1)&schedule(:,2)==thisPossece(2)-1,:);
%         thisPosseceNext=schedule(schedule(:,1)==thisPossece(1)&schedule(:,2)==thisPossece(2)+1,:);
%         if ~isempty(thisPosseceNext)
%             if thisPosseceNext(4)<thisPossece(5)
%                 isOk=false;
%                 break;
%             end
%         end
% 
%         if ~isempty(thisPossecePoire)
%             if thisPossecePoire(5)>thisPossece(4)
%                 isOk=false;
%                 break;
%             end
%         end
%         % if thisPosseceNext(5)>thisPossece(4)||thisPosseceNext(4)<thisPossece(5)
%         %     isOk=false;
%         %     break;
%         % end
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                % %尾移内
                % endFlipThisBlockScheduleId=[1:point-1,sizeBlock,point:sizeBlock-1];
                % newscheduleEnd=schedule;
                % thisBlockscheuleEnd=thisBlockScheule(endFlipThisBlockScheduleId,:);
                % newscheduleEnd(thisBlock,:)=thisBlockscheuleEnd;
                % chromoTempEnd=newscheduleEnd(:,1)';
                % %此时应该判断是否是可行解
                % neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];

                % %内移尾
                % endFlipThisBlockScheduleId=[1:point-1,point+1:sizeBlock,point];
                % newscheduleEnd=schedule;
                % thisBlockscheuleEnd=thisBlockScheule(endFlipThisBlockScheduleId,:);
                % newscheduleEnd(thisBlock,:)=thisBlockscheuleEnd;
                % chromoTempEnd=newscheduleEnd(:,1)';
                % %此时应该判断是否是可行解
                % neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];

                % %首移内
                % startFlipThisBlockScheduleId=[2:point,1,point+1:sizeBlock];
                % newscheduleStart=schedule;
                % thisBlockscheuleStart=thisBlockScheule(startFlipThisBlockScheduleId,:);
                % newscheduleStart(thisBlock,:)=thisBlockscheuleStart;
                % chromoTempStart=newscheduleStart(:,1)';
                % %此时应该判断是否是可行解
                % neighborhoodChromos=[neighborhoodChromos;chromoTempStart];

                % %内移首
                % startFlipThisBlockScheduleId=[point,1:point-1,point+1:sizeBlock];
                % thisBlockscheuleStart=thisBlockScheule(startFlipThisBlockScheduleId,:);
                % newscheduleStart(thisBlock,:)=thisBlockscheuleStart;
                % chromoTempStart=newscheduleStart(:,1)';
                % %此时应该判断是否是可行解
                % neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
             





%这是N7基于机器的编码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function neighborhoodChromos=creatneighborhoodChromosN7(chromo,keyBlock,schedule)
%     neighborhoodChromos=chromo;
%     schedule=sortrows(schedule,4);
%     blockNum=size(keyBlock,2); 
%     if blockNum==0
%         neighborhoodChromos=chromo;
%     end
%     for i=1:blockNum
%         chromosTemp=zeros(0);
%         thisBlock=keyBlock{i};
%         sizeBlock=size(thisBlock,2);
%         if sizeBlock==2
%             % chromosTemp=[chromosTemp;swap(thisBlock(1),thisBlock(2),chromo)];
%             if all([i~=1,i~=blockNum])
%                 thisBlockscheule=schedule(thisBlock,:);
%                 newschedule=schedule;
%                 newschedule(thisBlock,:)=[thisBlockscheule(end,:);thisBlockscheule(1,:)];
%                 chromoTemp=newschedule(:,1)';
%                 neighborhoodChromos=[neighborhoodChromos;chromoTemp];
%             end
%         else
%             thisBlockscheule=schedule(thisBlock,:);
%             point=randperm(sizeBlock-2,1)+1;
%             % %%%%%%%%%%%%%%%%%%%%%首尾移动到内部中%%%%%%%%%%%%%%%%%%%%
%             % if i~=1
%             %     thisBlockScheuleId=1:sizeBlock;
%             %     startFlipThisBlockScheduleId=[2:point,1,point+1:sizeBlock];
%             %     newscheduleStart=schedule;
%             %     thisBlockscheuleStart=thisBlockscheule(startFlipThisBlockScheduleId,:);
%             %     newscheduleStart(thisBlock,:)=thisBlockscheuleStart;
%             %     chromoTempStart=newscheduleStart(:,1)';
%             %     neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
%             % end
%             % if i~=blockNum
%             %     endFlipThisBlockScheduleId=[1:point-1,sizeBlock,point:sizeBlock-1];
%             %     newscheduleEnd=schedule;
%             %     thisBlockscheuleEnd=thisBlockscheule(endFlipThisBlockScheduleId,:);
%             %     newscheduleEnd(thisBlock,:)=thisBlockscheuleEnd;
%             %     chromoTempEnd=newscheduleEnd(:,1)';
%             %     neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
%             %     % neighborhoodChromos=[neighborhoodChromos;chromoTempStart;chromoTempEnd];
%             % end
%             % %%%%%%%%%%%%%%%%%%%%%首尾移动到内部中%%%%%%%%%%%%%%%%%%%%
% 
%             %%%%%%%%%%%%%%%%%%%%%首尾插入到内部工序中，且有内部移动到首尾%%%%%%%%%%%%%%%%%%%%%%
%             if i~=1
%                 % thisBlockScheuleId=1:sizeBlock;
%                 %首移内
%                 startFlipThisBlockScheduleId=[2:point,1,point+1:sizeBlock];
%                 newscheduleStart=schedule;
%                 thisBlockscheuleStart=thisBlockscheule(startFlipThisBlockScheduleId,:);
%                 newscheduleStart(thisBlock,:)=thisBlockscheuleStart;
%                 chromoTempStart=newscheduleStart(:,1)';
%                 %此时应该判断是否是可行解
%                 neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
%                 %内移首
%                 startFlipThisBlockScheduleId=[point,1:point-1,point+1:sizeBlock];
%                 thisBlockscheuleStart=thisBlockscheule(startFlipThisBlockScheduleId,:);
%                 newscheduleStart(thisBlock,:)=thisBlockscheuleStart;
%                 chromoTempStart=newscheduleStart(:,1)';
%                 %此时应该判断是否是可行解
% 
%                 neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
%             end
%             if i~=blockNum
%                 %尾移内
%                 endFlipThisBlockScheduleId=[1:point-1,sizeBlock,point:sizeBlock-1];
%                 newscheduleEnd=schedule;
%                 thisBlockscheuleEnd=thisBlockscheule(endFlipThisBlockScheduleId,:);
%                 newscheduleEnd(thisBlock,:)=thisBlockscheuleEnd;
%                 chromoTempEnd=newscheduleEnd(:,1)';
%                 %此时应该判断是否是可行解
%                 neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
%                 %内移尾
%                 endFlipThisBlockScheduleId=[1:point-1,point+1:sizeBlock,point];
%                 newscheduleEnd=schedule;
%                 thisBlockscheuleEnd=thisBlockscheule(endFlipThisBlockScheduleId,:);
%                 newscheduleEnd(thisBlock,:)=thisBlockscheuleEnd;
%                 chromoTempEnd=newscheduleEnd(:,1)';
%                 %此时应该判断是否是可行解
%                 neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
% 
%                 % neighborhoodChromos=[neighborhoodChromos;chromoTempStart;chromoTempEnd];
%             end            
%             %%%%%%%%%%%%%%%%%%%%%首尾插入到内部工序中，且有内部移动到首尾%%%%%%%%%%%%%%%%%%%%%%
% 
%         end
%     end
% end
% 
% function moveKeyBlock = moveFirst(keyBlock,point)
%     % 将第一个元素移动到数组的第point个位置
%     point = point+1;
%     % 保存第一个元素的值
%     elementToMove = keyBlock(1);
%     % 移动其他元素以腾出空间
%     keyBlock = [keyBlock(2:point-1), elementToMove, keyBlock(point:end)];
%     moveKeyBlock=keyBlock;
% end
% 
% function moveKeyBlock = moveEnd(keyBlock,point)
%     % 保存最后一个元素的值
%     elementToMove = keyBlock(end);
%     % 移动其他元素以腾出空间
%     keyBlock = [keyBlock(1:point-1), elementToMove, keyBlock(point:end-1)];
%     moveKeyBlock=keyBlock;
% end
% 
% function chromo = swap(id1,id2,chromo)
%     temp=chromo(1,id1);
%     chromo(1,id1)=chromo(1,id2);
%     chromo(1,id2)=temp;
% end
% 
% function isOk = isOkTest(chromo,schedule)
% 
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%这是N7基于工序编码的版本 error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 这是N7的移动版本
% function neighborhoodChromos=creatneighborhoodChromosN7(chromo,keyBlock)
%     neighborhoodChromos=[];
%     blockNum=size(keyBlock,2); 
% 
%     if blockNum==0
%         neighborhoodChromos=chromo;
%     end
%     for i=1:blockNum
%         chromosTemp=zeros(0);
%         thisBlock=keyBlock{i};
%         sizeBlock=size(thisBlock,2);
%         if sizeBlock==2
%             chromosTemp=[chromosTemp;swap(thisBlock(1),thisBlock(2),chromo)];
%         else
%             point=randperm(sizeBlock-2,1)+1;            
%             %首移动的关键块
%             thisBlockwork=chromo(thisBlock);
%             indexChromo=chromo;indexChromo(thisBlock)=-999;
%             moveKeyBlockwork = moveFirst(thisBlockwork,point);
%             indexChromo(indexChromo==-999)=moveKeyBlockwork;
%             chromosTemp=[chromosTemp;indexChromo]; 
%             %尾移动的关键块
%             indexChromo=chromo;indexChromo(thisBlock)=-999;
%             moveKeyBlockwork = moveEnd(thisBlockwork,point);
%             indexChromo(indexChromo==-999)=moveKeyBlockwork;
%             chromosTemp=[chromosTemp;indexChromo];
% 
%         end
%         neighborhoodChromos=[neighborhoodChromos;chromosTemp];
%     end
% end
% 
% function moveKeyBlock = moveFirst(keyBlock,point)
%     % 将第一个元素移动到数组的第point个位置
%     point = point+1;
%     % 保存第一个元素的值
%     elementToMove = keyBlock(1);
%     % 移动其他元素以腾出空间
%     keyBlock = [keyBlock(2:point-1), elementToMove, keyBlock(point:end)];
%     moveKeyBlock=keyBlock;
% end
% 
% function moveKeyBlock = moveEnd(keyBlock,point)
%     % 保存最后一个元素的值
%     elementToMove = keyBlock(end);
%     % 移动其他元素以腾出空间
%     keyBlock = [keyBlock(1:point-1), elementToMove, keyBlock(point:end-1)];
%     moveKeyBlock=keyBlock;
% end
% 
% function chromo = swap(id1,id2,chromo)
%     temp=chromo(1,id1);
%     chromo(1,id1)=chromo(1,id2);
%     chromo(1,id2)=temp;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% 这是N7的交换版本
% function neighborhoodChromos=creatneighborhoodChromosN7(chromo,keyBlock)
%     neighborhoodChromos=chromo;
%     blockNum=size(keyBlock,2); 
% 
%     if blockNum==0
%         neighborhoodChromos=chromo;
%     end
%     for i=1:blockNum
%         chromosTemp=zeros(0);
%         thisBlock=keyBlock{i};
%         sizeBlock=size(thisBlock,2);
%         if sizeBlock==2            
%             %chromo=swap(thisBlock(1),thisBlock(2),chromo);
%             chromosTemp=[chromosTemp;swap(thisBlock(1),thisBlock(2),chromo)];
%         else
%             point=randperm(sizeBlock-2,1);
%             %只交换首或尾
%             chromosTemp=[chromosTemp;swap(thisBlock(1),point+1,chromo)];
%             chromosTemp=[chromosTemp;swap(point+1,size(thisBlock,2),chromo)];                  
% 
%             %同时交换首和尾
%             chromoTemp=swap(thisBlock(1),point+1,chromo);
%             chromoTemp=swap(point,size(thisBlock,2),chromo);
%             chromosTemp=[chromosTemp;chromoTemp];
%             %chromo=swap(size(thisBlock,2)-1,size(thisBlock,2),chromo);
%         end
%         neighborhoodChromos=[neighborhoodChromos;chromosTemp];
%     end
% end
% 
% function chromo = swap(id1,id2,chromo)
%     temp=chromo(1,id1);
%     chromo(1,id1)=chromo(1,id2);
%     chromo(1,id2)=temp;
% end


