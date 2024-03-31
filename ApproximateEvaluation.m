% neighborhoodSchedule=[1工件号 2工序号 3机器号 4开工时间 5完工时间 6关键工序标志位 7被其他函数占用 8变动工序标志位 --2v\0u]
% 中间neighborhoodSchedule=[7头长或尾长]   
% neighborhoodSign是移动的类型  0是v移动到u之前 1是u移动到v之后  -1是没有移动，即原始解
function [fitness]=ApproximateEvaluation(neighborhoodSchedule,Cmax,neighborhoodSign)
    neighborhoodNum=size(neighborhoodSchedule,3);
    jobProcessNum=max(neighborhoodSchedule(:,2,1)); %工件的工序数
    if neighborhoodNum==1
        fitness=Cmax;
    else
        fitness=zeros(neighborhoodNum,1);
        fitness(1,1)=Cmax;
        headSchedule = searchHeadLength(neighborhoodSchedule(:,:,1));
        % headSchedule=[6关键工序标志位 7头长]
        tailSchedule = searchTailLength(neighborhoodSchedule(:,:,1));
        % TailSchedule=[6关键工序标志位 7尾长]
        newSchedule=[headSchedule(:,1:7),tailSchedule(:,7),neighborhoodSchedule(:,8,1)];
        % 这里就是原始的解的状况  newSchedule=[7头长 8尾长 9变动工序标志位]
        for i =2:neighborhoodNum
            % 从第二个开始
            % 第一种情况：将工序 u 移动到 v 之后,第二种情况 ：将工序 v 移动到 u
            % 之前这里需要检查u、v的位置，还需要知道是u移动的还是v移动造成的位置变化
            % ！往前推，需要知道是那种变化造成的移动！！！设置移动标记
            thisSchedule=neighborhoodSchedule(:,:,i);
            rowUIndex=find(thisSchedule(:,8)==0);
            rowVIndex=find(thisSchedule(:,8)==2);
            row1Index=find(thisSchedule(:,8)==1);
            Uschedule=thisSchedule(rowUIndex,:);
            Vschedule=thisSchedule(rowVIndex,:);
            schedule1=thisSchedule(row1Index,:);
            schedule1=sortrows(schedule1,4);
            if neighborhoodSign(i) %如果是u移动到v之后


                % 先找到l1的头长--jpl1和mpu
                %判断u是否是机器上的第一个工序
                sameUMachineSchedule=thisSchedule(thisSchedule(:,3)==Uschedule(1,3),:);
                URowInSMS=find(sameUMachineSchedule(:,8)==0);
                if URowInSMS==1 %是第一个工序,则L（0，JP【l1】）+PJPl1  这里是否还用判断JP是否还存在？？ 判断一个吧，如果不存在就是0
                    % 找l1的JP
                    l1Schedule=schedule1(1,:);
                    % l1JPIndex=ismember(thisSchedule(:,1:2),[l1Schedule(1,1),l1Schedule(1,2)-1],"rows");
                    % l1JPRow=find(l1JPIndex); %找到的是在thisSchedule中的行数
                    if l1Schedule(1,2)~=1  %如果l1JP存在                  
                        %需要找到l1JP的头长和工作时间
                        l1JPIndex=ismember(newSchedule(:,1:2),[l1Schedule(1,1),l1Schedule(1,2)-1],"rows");
                        l1JPRow=find(l1JPIndex); %找到的是在newSchedule中的行数
                        l1JPSchedule=newSchedule(l1JPRow,:);
                        l1HeadLength=l1JPSchedule(1,7)+l1JPSchedule(1,5)-l1JPSchedule(1,4);
                    else
                        l1HeadLength=0;
                    end                    
                else %如果不是第一个工序--max(lJP,lMPu)
                    % 还是先判断JPl1是否存在
                    if l1Schedule(1,2)~=1  %如果l1JP存在   
                        l1JPIndex=ismember(newSchedule(:,1:2),[l1Schedule(1,1),l1Schedule(1,2)-1],"rows");
                        l1JPRow=find(l1JPIndex); %找到的是在newSchedule中的行数
                        l1JPSchedule=newSchedule(l1JPRow,:);
                        l1HeadLength1=l1JPSchedule(1,7)+l1JPSchedule(1,5)-l1JPSchedule(1,4);
                    else
                        l1HeadLength1=0;                        
                    end
                    % 现在找U的MP
                    MPUSchedule=sameUMachineSchedule(URowInSMS-1,:);
                    MPUInNSIndex=ismember(newSchedule(:,1:2),[MPUSchedule(1,1),MPUSchedule(1,2)],'rows');
                    MPUInNSRow=find(MPUInNSIndex);%找到MPU在newSchedle中的行数
                    l1HeadLength2=newSchedule(MPUInNSRow,7)+newSchedule(MPUInNSRow,5)-newSchedule(MPUInNSRow,4);
                    l1HeadLength=max(l1HeadLength1,l1HeadLength2);
                end
                HeadLength=l1HeadLength;
                % 至此，求完了l1的头长，现在来看w
                MPwScheduleNow=l1Schedule; % 把MP初始化为l1
                MPwHeadLength=l1HeadLength;
                schedulew=[schedule1;Vschedule;Uschedule];
                for j=2:size(schedulew,1)
                    thiswSchedule=schedulew(j,:);
                    % max(LJPw)+PJPu, 变L(MPw)+PMPw)
                    % 还是先看看JP吧
                    if thiswSchedule(1,2)~=1 %先看看JP有没有
                        JPwIndex=ismember(newSchedule,[thiswSchedule(1,1),thiswSchedule(1,2)-1],'rows');
                        JPwRow=find(JPwIndex);
                        JPwSchedule=newSchedule(JPwRow,:);
                        wHeadLength1=JPwSchedule(1,7)+JPwSchedule(1,5)-JPwSchedule(1,4);
                    else
                        wHeadLength1=0;
                    end
                    wHeadLength2=MPwHeadLength+MPwScheduleNow(1,5)-MPwScheduleNow(1,4);
                    wHeadLength=max(wHeadLength1,wHeadLength2);
                    % 求得wHL之后，修改表单
                    MPwScheduleNow=thiswSchedule;
                    MPwHeadLength=wHeadLength;
                    % HeadLength是l1-lk-V-U的头长
                    HeadLength=[HeadLength;wHeadLength];
                end

                %求完了头长，开始求尾长吧来
                % 先找到JSU的尾长 --先判断JSU是否存在
                if Uschedule(1,2)==jobProcessNum
                    JSUtailLength=0;
                else
                    JSUIndex=ismember(newSchedule(:,1:2),[Uschedule(1,1),Uschedule(1,2)+1],'rows');
                    JSURow=find(JSUIndex);
                    JSUSchedule=newSchedule(JSURow);
                    JSUtailLength=JSUSchedule(1,8);
                end
                % 看看v是不是机器的最后一个工序
                sameVMachineSchedule=thisSchedule(thisSchedule(:,3)==Vschedule(1,3),:);
                VRowInSMS=find(sameVMachineSchedule(:,8)==0);
                if VRowInSMS==size(sameVMachineSchedule,1) %如果V是机器的最后一道工序
                    UTailLength=Uschedule(1,5)-Uschedule(1,4)+JSUtailLength;
                else %qita
                    MSVSchedule=sameVMachineSchedule(VRowInSMS+1,:);
                    % 现在找MSV的尾长
                    MSVInNewScheduleIndex=ismember(newSchedule(:,1:2),[MSVSchedule(1,1),MSVSchedule(1,2)],'rows');
                    MSVInNSRow=find(MSVInNewScheduleIndex);
                    UTailLength1=JSUtailLength;
                    UTailLength2=newSchedule(MSVInNSRow,8);
                    UTailLength=Uschedule(1,5)-Uschedule(1,4)+max(UTailLength1,UTailLength2);
                end
                % 现在求完了U的尾长，更新表单
                MSwScheduleNow=Uschedule;% 把MS初始化为U
                TailLength=UTailLength;
                MSwTailLength=UTailLength;
                % 开始求w--w-v !!!!!!!倒着求，！倒着放！
                for j=size(schedulew,1)-1:-1:1
                    thiswSchedule=schedulew(j,:);
                    % 对于js和ms，还是先判断存在
                    % 还是先看看JS吧
                    if thiswSchedule(1,2)~=jobProcessNum %先看看JS有没有
                        JSwIndex=ismember(newSchedule,[thiswSchedule(1,1),thiswSchedule(1,2)+1],'rows');
                        JSwRow=find(JSwIndex);
                        JSwSchedule=newSchedule(JSwRow,:);
                        wTailLength1=JSwSchedule(1,8);
                    else
                        wTailLength1=0;
                    end
                    wTailLength2=MSwTailLength;
                    wTailLength=max(wTailLength1,wTailLength2)+thiswSchedule(1,5)-thiswSchedule(1,4);
                    % 求得wTL之后，修改表单
                    MSwScheduleNow=thiswSchedule;
                    MSwTailLength=wTailLength;
                    % TailLength是l1-lk-V-U的头长
                    TailLength=[wTailLength;TailLength];                    

                end
                % 现在求完了每个工序的头长尾长，开始求最大完工时间
                makespans=HeadLength+TailLength;
                maxMakespan=max(makespans);
                % 现在写完了第一种情况，来看看第二种吧家人们
            else




                
            end
        end
    end
end




            % 找到u=0 和v=2，在找到中间=1 的，全部进行搜索
            % maxCmax=0; %初始化最大记录
            % rowUIndex=find(newSchedule(:,9)==0);
            % rowVIndex=find(newSchedule(:,9)==2);
            % row1Index=find(newSchedule(:,9)==1);
            % rowIndex=[rowUIndex;rowVIndex;row1Index];
            % indexNum=size(rowIndex,1);
            % for j=indexNum
            %     thisMax=newSchedule(rowIndex(j),7)+newSchedule(rowIndex(j),8)+newSchedule(rowIndex(j),5)-newSchedule(rowIndex(j),4); %别忘了加上pu
            %     if thisMax>maxCmax
            %         maxCmax=thisMax;
            %     end
            % end
            % fitness(i,1)=maxCmax;