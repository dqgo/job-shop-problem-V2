% 这是N7基于机器的编码
function neighborhoodChromos=creatneighborhoodChromosN7old(chromo,keyBlock,schedule)
    neighborhoodChromos=chromo;
    schedule=sortrows(schedule,4);
    blockNum=size(keyBlock,2); 
    if blockNum==0
        neighborhoodChromos=chromo;
    end
    for i=1:blockNum
        chromosTemp=zeros(0);
        thisBlock=keyBlock{i};
        sizeBlock=size(thisBlock,2);
        if sizeBlock==2
            % chromosTemp=[chromosTemp;swap(thisBlock(1),thisBlock(2),chromo)];
            if all([i~=1,i~=blockNum])
                thisBlockscheule=schedule(thisBlock,:);
                newschedule=schedule;
                newschedule(thisBlock,:)=[thisBlockscheule(end,:);thisBlockscheule(1,:)];
                chromoTemp=newschedule(:,1)';
                neighborhoodChromos=[neighborhoodChromos;chromoTemp];
            end
        else
            thisBlockscheule=schedule(thisBlock,:);
            point=randperm(sizeBlock-2,1)+1;
            % %%%%%%%%%%%%%%%%%%%%%首尾移动到内部中%%%%%%%%%%%%%%%%%%%%
            % if i~=1
            %     thisBlockScheuleId=1:sizeBlock;
            %     startFlipThisBlockScheduleId=[2:point,1,point+1:sizeBlock];
            %     newscheduleStart=schedule;
            %     thisBlockscheuleStart=thisBlockscheule(startFlipThisBlockScheduleId,:);
            %     newscheduleStart(thisBlock,:)=thisBlockscheuleStart;
            %     chromoTempStart=newscheduleStart(:,1)';
            %     neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
            % end
            % if i~=blockNum
            %     endFlipThisBlockScheduleId=[1:point-1,sizeBlock,point:sizeBlock-1];
            %     newscheduleEnd=schedule;
            %     thisBlockscheuleEnd=thisBlockscheule(endFlipThisBlockScheduleId,:);
            %     newscheduleEnd(thisBlock,:)=thisBlockscheuleEnd;
            %     chromoTempEnd=newscheduleEnd(:,1)';
            %     neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
            %     % neighborhoodChromos=[neighborhoodChromos;chromoTempStart;chromoTempEnd];
            % end
            % %%%%%%%%%%%%%%%%%%%%%首尾移动到内部中%%%%%%%%%%%%%%%%%%%%

            %%%%%%%%%%%%%%%%%%%%%首尾插入到内部工序中，且有内部移动到首尾%%%%%%%%%%%%%%%%%%%%%%
            if i~=1
                % thisBlockScheuleId=1:sizeBlock;
                %首移内
                startFlipThisBlockScheduleId=[2:point,1,point+1:sizeBlock];
                newscheduleStart=schedule;
                thisBlockscheuleStart=thisBlockscheule(startFlipThisBlockScheduleId,:);
                newscheduleStart(thisBlock,:)=thisBlockscheuleStart;
                chromoTempStart=newscheduleStart(:,1)';
                %此时应该判断是否是可行解
                neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
                %内移首
                startFlipThisBlockScheduleId=[point,1:point-1,point+1:sizeBlock];
                thisBlockscheuleStart=thisBlockscheule(startFlipThisBlockScheduleId,:);
                newscheduleStart(thisBlock,:)=thisBlockscheuleStart;
                chromoTempStart=newscheduleStart(:,1)';
                %此时应该判断是否是可行解

                neighborhoodChromos=[neighborhoodChromos;chromoTempStart];
            end
            if i~=blockNum
                %尾移内
                endFlipThisBlockScheduleId=[1:point-1,sizeBlock,point:sizeBlock-1];
                newscheduleEnd=schedule;
                thisBlockscheuleEnd=thisBlockscheule(endFlipThisBlockScheduleId,:);
                newscheduleEnd(thisBlock,:)=thisBlockscheuleEnd;
                chromoTempEnd=newscheduleEnd(:,1)';
                %此时应该判断是否是可行解
                neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];
                %内移尾
                endFlipThisBlockScheduleId=[1:point-1,point+1:sizeBlock,point];
                newscheduleEnd=schedule;
                thisBlockscheuleEnd=thisBlockscheule(endFlipThisBlockScheduleId,:);
                newscheduleEnd(thisBlock,:)=thisBlockscheuleEnd;
                chromoTempEnd=newscheduleEnd(:,1)';
                %此时应该判断是否是可行解
                neighborhoodChromos=[neighborhoodChromos;chromoTempEnd];

                % neighborhoodChromos=[neighborhoodChromos;chromoTempStart;chromoTempEnd];
            end            
            %%%%%%%%%%%%%%%%%%%%%首尾插入到内部工序中，且有内部移动到首尾%%%%%%%%%%%%%%%%%%%%%%

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

function chromo = swap(id1,id2,chromo)
    temp=chromo(1,id1);
    chromo(1,id1)=chromo(1,id2);
    chromo(1,id2)=temp;
end

function isOk = isOkTest(chromo,schedule)

end