%主程序
%function GA4JSPTest()
%%%%%%%%%%系数%%%%%%%%%%%%%
    popu=300;%得是偶数，要不然交叉就错了
    maxIterate=2;
    nowIterate=0;
    Pcross=0.7;
    Pmuta=0.1;
%%%%%%%%%%系数%%%%%%%%%%%%%
    %改变算例 
    changeData=changeDataFunction(); 
    %初始化种群 
    chromos = createInitialPopus(popu);    
    while nowIterate<maxIterate
        %选择操作
        chromos=selectChromos(chromos,popu,changeData);
        %交叉操作
        chromos=crossChromos(chromos,Pcross,popu);
        %变异操作
        chromos=mutatedChromos(chromos,Pmuta,popu);
        nowIterate=nowIterate+1;
    end
    %至此，已完成GA，下面找出种群内的最优解染色体和最优解数目，并输出gant图
    endFitness=zeros(popu,2);
    endFitness(:,1)=1:popu;
    endFitness(:,2)= calcFitness(chromos,popu,changeData);
    endFitness=sortrows(endFitness,2);
    endFitness(1,2) %输出最优解的值
    endChromo=chromos(endFitness(1,1),:); %输出最优染色体序列
    bestSchedule = createSchedule(changeData,endChromo);
    drewGant(bestSchedule) %画出甘特图
    %[DAG, criticalPath] = generateDAGAndCriticalPath(endChromo, changeData)

%变异操作：输入且得到一个种群-- 简简单单逆个序
function outChromos=mutatedChromos(inChromos,Pmuta,popu)
    for i=1:popu
        outChromos(i,:)=inChromos(i,:);
        if rand(1)<Pmuta %逆一个
            point=sort(randperm(100,2));
            subsegment=inChromos(i,point(1):point(2));
            newSubsegment=fliplr(subsegment);
            outChromos(i,point(1):point(2))=newSubsegment;
        end
    end
end

%交叉操作：输入一个种群，得到一个新种群
function outChromos=crossChromos(inChromos,Pcross,popu)    
    for i=1:2:popu-1
        if rand(1)<Pcross %需要交叉
            point=randperm(100,2);
            point=sort(point);
            point1=point(1,1);point2=point(1,2); %得到两个交叉点
            pChromo1=inChromos(i,:);pChromo2=inChromos(i+1,:);
            subsegment1=pChromo1(1,point1:point2);subsegment2=pChromo2(1,point1:point2);
            cChromo1=pChromo1;cChromo2=pChromo2;
            cChromo1(1,point1:point2)=subsegment2;
            cChromo2(1,point1:point2)=subsegment1; %已经完成了两点之间的交叉，开始检查
            [newSubsegment1, newSubsegment2]=createNewSubsegment(subsegment1,subsegment2);
            if size(newSubsegment2,2)>0 %如果新子串的大小大于0，那就要做匹配工作了
                if point1==1 %从头开始的交换
                    [cChromo1,cChromo2]=matchingTopStart(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2);
                else %不是从头开始的交换
                    if point2==100 %从中间到末尾的交换
                        [cChromo1, cChromo2]=matchingEndEnd(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2);
                    else %全都在中间的交换
                        [cChromo1, cChromo2]=matchingMid(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2);
                    end
                end
            end
            outChromos(i,:)=cChromo1;outChromos(i+1,:)=cChromo2;
        else
            outChromos(i,:)=inChromos(i,:);outChromos(i+1,:)=inChromos(i+1,:);
        end
    end
end

%交叉操作的子模块，匹配首开始的子代
function [cChromo1, cChromo2]=matchingTopStart(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2)
    % cChromo1(1,point2+1:100)=pChromo1(1,point2+1:100);
    % cChromo2(1,point2+1:100)=pChromo2(1,point2+1:100);
    for i=1:size(newSubsegment1,2) %修改cC1
        for j=point2+1:100
            if newSubsegment2(1,i)==cChromo1(1,j)
                cChromo1(1,j)=newSubsegment1(1,i);
                break;
            end
        end
    end
    for i=1:size(newSubsegment1,2) %修改cC2
        for j=point2+1:100
            if newSubsegment1(1,i)==cChromo2(1,j)
                cChromo2(1,j)=newSubsegment2(1,i);
                break;
            end
        end
    end
end

%交叉操作的子模块，匹配末尾结束的子代
function [cChromo1, cChromo2]=matchingEndEnd(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2)
    % cChromo1(1,1:point1-1)=pChromo1(1,1:point1-1);
    % cChromo2(1,1:point1-1)=pChromo2(1,1:point1-1);
    for i=1:size(newSubsegment1,2)%修改cC1
        for j=1:1:point1-1
            if newSubsegment2(1,i)==cChromo1(1,j)
                cChromo1(1,j)=newSubsegment1(1,i);
                break;
            end
        end
    end
    for i=1:size(newSubsegment1,2)%修改cC2
        for j=1:1:point1-1
            if newSubsegment1(1,i)==cChromo2(1,j)
                cChromo2(1,j)=newSubsegment2(1,i);
                break;
            end
        end
    end
end

%交叉操作的子模块，匹配在中间的子代
function [cChromo1, cChromo2]=matchingMid(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2)
    % cChromo1(1,1:point1-1)=pChromo1(1,1:point1-1);
    % cChromo1(1,point2+1:100)=pChromo1(1,point2+1:100);
    % cChromo2(1,1:point1-1)=pChromo2(1,1:point1-1);
    % cChromo2(1,point2+1:100)=pChromo2(1,point2+1:100);
    for i=1:size(newSubsegment1,2) %修改cC1
        isMatching=0;
        for j=1:point1-1 %在前段进行匹配
            if newSubsegment2(1,i)==cChromo1(1,j)
                cChromo1(1,j)=newSubsegment1(1,i);
                isMatching=1;
                break;                
            end
        end
        if isMatching==0 %如果前段没有匹配成功，在后段匹配
            for j=point2+1:100
                if newSubsegment2(1,i)==cChromo1(1,j)
                    cChromo1(1,j)=newSubsegment1(1,i);
                    break;
                end
            end
        end
    end
    for i=1:size(newSubsegment1,2) %修改cC2 %%%%%%%%%%%%%%YOUCUO
        isMatching=0;
        for j=1:point1-1 %在前段进行匹配
            if newSubsegment1(1,i)==cChromo2(1,j)
                cChromo2(1,j)=newSubsegment2(1,i);
                isMatching=1;
                break;                
            end
        end
        if isMatching==0 %如果前段没有匹配成功，在后段匹配
            for j=point2+1:100
                if newSubsegment1(1,i)==cChromo2(1,j)
                    cChromo2(1,j)=newSubsegment2(1,i);
                    break;
                end
            end
        end
    end    
end

%交叉操作的子模块，删除掉输入的两个字符串之间的相同元素，得到两个新串
function [newSubsegment1, newSubsegment2]=createNewSubsegment(subsegment1,subsegment2)
    %sizeNum=size(subsegment1);
    for i=size(subsegment1,2):-1:1
        nowNum=subsegment1(1,i);
        for k=1:size(subsegment2,2)
            if nowNum==subsegment2(1,k)
                subsegment2(:,k)=[];
                subsegment1(:,i)=[];
                break;
            end
        end
    end
    newSubsegment1=subsegment1;newSubsegment2=subsegment2;
end
%测试通过


%选择操作：输入一个种群，得到一个新种群
function outChromos = selectChromos(inChromos,popu,changeData)
    outChromos=zeros(popu,100);
    roulette=zeros(popu,5);
    roulette(:,2)=calcFitness(inChromos,popu,changeData);%适应度
    roulette(:,1)=1:popu; %伪指针
    roulette=sortrows(roulette,2);
    roulette(:,3)=roulette(:,2)*1.2;%伪适应度
    sumFitness=sum(roulette(:,3));%伪适应度之和
    roulette(:,4)=roulette(:,3)/sumFitness;
    roulette(1,5)=roulette(1,4);
    for i=2:popu
        roulette(i,5)=roulette(i-1,5)+roulette(i,4);
    end
    %得到轮盘，然后开始转指针
    for i=1:popu
        pointer=rand(1);
        %开始检查指针的落脚处
        if pointer<roulette(1,5)
            outChromos(i,:)=inChromos(roulette(1,1),:);
        else 
            for j=2:popu
                if (pointer>roulette(j-1,5)&&(pointer<roulette(j,5)))
                    outChromos(i,:)=inChromos(roulette(j,1),:);
                    break;
                end
            end
        end
    end
end

%适应度计算，输入一个种群，得到这个种群的每个染色体的适应度
function fitness= calcFitness(chromos,popu,changeData)
    fitness=zeros(popu,1);
    for i=1:popu
        schedule=createSchedule(changeData,chromos(i,:));
        fitness(i,1)=max(schedule(:,5));
    end
end

%生成甘特图
function drewGant(schedule)
    randColor = rand(10, 3);
    figure;   
    ylim([0 11]);
    for i=1:100
        x=schedule(i,4:5);
        y=[schedule(i,3) schedule(i,3)];
        line(x,y,'lineWidth',30,'color',randColor(schedule(i,1),:));
    end
    randColor = rand(10, 3);

    %%%%%%%%%%%%%%%%%%%%%%%%%%GPT写出来的，不会%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    legendText = cell(10, 1); % 创建一个单元格数组来存储工件名称
    for i = 1:10
        chatTxt = "工件" + int2str(i);
        legendText{i} = chatTxt; % 将工件名称添加到单元格数组中
    end
    legend(legendText, 'TextColor', 'k'); % 添加图例并指定文本颜色为黑色
    %%%%%%%%%%%%%%%%%%%%%%%%%%GPT写出来的，不会%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


%生成一个染色体的时间表
%解码，生成时间表
function schedule = createSchedule(changeData,chromo)
    schedule=zeros(100,5);
    workpieceProcessId=zeros(1,10);
    workpieceCanStartTime=zeros(1,10);
    for i=1:100
        workpieceId=chromo(i);
        workpieceProcessId(workpieceId)=workpieceProcessId(workpieceId)+1;
        machId=changeData(workpieceId,2*workpieceProcessId(workpieceId)-1);
        workpieceSpeedTime=changeData(workpieceId,2*workpieceProcessId(workpieceId));
        newSchedule=schedule(schedule(:,3)==machId,:);       
        isInsert=0;
        if size(newSchedule,1)==0 %空的 直接安排
            workpieceStartTime=0;
            isInsert=1;        
        else 
            newSchedule=sortrows(newSchedule,4); %排序一下
            if newSchedule(1,4)>=workpieceCanStartTime(workpieceId)+workpieceSpeedTime %有安排了 就先看第一行
                workpieceStartTime=workpieceCanStartTime(workpieceId);
                isInsert=1;
            end
            if isInsert==0 %从第二行开始遍历
                for j=2:size(newSchedule)       %下行注释 间隔时间要大于用时，间隔结束时间要大于工件的拟完工时间
                    if newSchedule(j,4)-newSchedule(j-1,5)>=workpieceSpeedTime
                        if newSchedule(j,4)>=workpieceCanStartTime+workpieceSpeedTime
                            workpieceSpeedTime=max(workpieceCanStartTime(workpieceId),newSchedule(j-1,5));
                            isInsert=1;
                            break;
                        end
                    end
                end
            end
            if isInsert==0 %遍历完了都没插入 直接插入在最后
                    workpieceStartTime=max(workpieceCanStartTime(workpieceId),newSchedule(end,5));
            end
         end 
         
        %在此已经完成插入了，要更新各个表单
        workpieceCanStartTime(workpieceId)=workpieceStartTime+workpieceSpeedTime; %更新结束时间表
        workpieceEndTime=workpieceStartTime+workpieceSpeedTime;
        schedule(i,:)=[workpieceId,workpieceProcessId(workpieceId),machId,workpieceStartTime,workpieceEndTime];
    end
end



%生成popu个初试种群，随机
function initialPopus = createInitialPopus(popu)
        initialPopus=createInitialPopu();
        for i=2:popu
            initialPopus=[initialPopus;createInitialPopu()];
        end
end

%生成第一个染色体,随机
function initialPopu = createInitialPopu()
    initialPopu=1:1:10;
    for i=1:9
        initialPopu=[initialPopu,1:1:10];
    end
    initialPopu=initialPopu(randperm(100));
end



%机器号加1处理
function changeData=changeDataFunction()
    %奇数列是机器号，偶数列是对应的时间
    %行代表工件号
    %FT10
    data=[0 29 1 78 2  9 3 36 4 49 5 11 6 62 7 56 8 44 9 21;
 0 43 2 90 4 75 9 11 3 69 1 28 6 46 5 46 7 72 8 30;
 1 91 0 85 3 39 2 74 8 90 5 10 7 12 6 89 9 45 4 33;
 1 81 2 95 0 71 4 99 6  9 8 52 7 85 3 98 9 22 5 43;
 2 14 0  6 1 22 5 61 3 26 4 69 8 21 7 49 9 72 6 53;
 2 84 1  2 5 52 3 95 8 48 9 72 0 47 6 65 4  6 7 25;
 1 46 0 37 3 61 2 13 6 32 5 21 9 32 8 89 7 30 4 55;
 2 31 0 86 1 46 5 74 4 32 6 88 8 19 9 48 7 36 3 79;
 0 76 1 69 3 76 5 51 2 85 9 11 6 40 7 89 4 26 8 74;
 1 85 0 13 2 61 6  7 8 64 9 76 5 47 3 52 4 90 7 45];
    odd=1:2:20;
    data(:,odd)=data(:,odd)+1;
    changeData=data;    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [DAG, criticalPath] = generateDAGAndCriticalPath(chromo, changeData)
%     % Step 1: Build a directed acyclic graph (DAG)
%     numJobs = size(changeData, 1);
%     %numMachines = max(changeData(:, 2:2:end));
%     DAG = zeros(numJobs, 10);
% 
%     for i = 1:numel(chromo)
%         job = chromo(i);
%         processId = DAG(job, 1) + 1;
%         machineId = changeData(job, 2 * processId - 1);
%         DAG(job, processId) = machineId;
%     end
% 
%     % Step 2: Topological Sorting
%     temp=digraph(DAG);
%     [~, topologicalOrder] = toposort(temp);
% 
%     % Step 3: Calculate Critical Path
%     numTasks = numel(topologicalOrder);
%     earliestStart = zeros(1, numTasks);
%     latestStart = inf(1, numTasks);
% 
%     for i = 1:numTasks
%         task = topologicalOrder(i);
%         machineId = DAG(task, processId);
% 
%         if processId == 1
%             earliestStart(i) = 0;
%         else
%             previousTasks = find(DAG(:, processId - 1) == machineId);
%             maxPreviousES = max(earliestStart(ismember(topologicalOrder, previousTasks)));
%             earliestStart(i) = maxPreviousES + changeData(task, 2 * processId);
%         end
%     end
% 
%     for i = numTasks:-1:1
%         task = topologicalOrder(i);
%         processId = DAG(task, 1);
%         machineId = DAG(task, processId);
%         if processId == 10
%             latestStart(i) = earliestStart(i);
%         else
%             nextTasks = find(DAG(:, processId + 1) == machineId);
%             minNextLS = min(latestStart(ismember(topologicalOrder, nextTasks)));
%             latestStart(i) = minNextLS - changeData(task, 2 * processId);
%         end
%     end
% 
%     criticalPathIndices = find(earliestStart == latestStart);
%     criticalPath = topologicalOrder(criticalPathIndices);
% end
% 
