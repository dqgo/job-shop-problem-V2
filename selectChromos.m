% %选择操作：输入一个种群，得到一个新种群
function outChromos = selectChromos(inChromos, popu, changeData, workpieceNum, machNum,fitness,pElite)
    roulette = zeros(popu, 5);
    % fitness = calcFitness(inChromos, popu, changeData, workpieceNum, machNum);
    global thisAGVCmax;
    global thisMinCmax;
    thisAGVCmax=mean(fitness);
    thisMinCmax=min(fitness);
    
    % 适应度缩放
    scaledFitness = 1 ./ (fitness + min(fitness));
    % scaledFitness = 1 ./ (fitness);
    roulette(:, 2) = fitness; % 适应度
    roulette(:, 1) = 1:popu; % 伪指针
    roulette(:, 3) = scaledFitness.*0.85 ; % 伪适应度，可以根据问题的特性调整缩放参数
    sumFitness = sum(roulette(:, 3)); % 伪适应度之和
    roulette(:, 4) = roulette(:, 3) / sumFitness;
    roulette(1, 5) = roulette(1, 4);
    roulette(:, 5) = cumsum(roulette(:, 4));

    % 使用 rand 一次性生成所有的指针
    pointers = rand(1, popu);

    % 使用 histcounts 进行选择
    [~, ~, idx] = histcounts(pointers, [0; roulette(:, 5)]);

    % 精英选择，将上一代中的最优两个个体直接复制到下一代中
    [~, eliteIdx] = sort(fitness);
    eliteCount = round(pElite*popu); % 保留最优的几个个体
    eliteChromos = inChromos(eliteIdx(1:eliteCount), :);
    
    % 遗传下去，除了精英个体外的其他个体
    outChromos = inChromos(roulette(idx, 1), :);
    
    % 将精英个体插入到新种群中
    outChromos(end - eliteCount + 1:end, :) = eliteChromos;
    temp=randperm(size(inChromos,1));
    outChromos=outChromos(temp,:);
end






% %选择操作：输入一个种群，得到一个新种群
% function outChromos = selectChromos(inChromos,popu,changeData,workpieceNum,machNum)
%     outChromos=zeros(popu,workpieceNum*machNum);
%     roulette=zeros(popu,5);
%     roulette(:,2)=calcFitness(inChromos,popu,changeData,workpieceNum,machNum);%适应度
%     roulette(:,1)=1:popu; %伪指针
%     roulette=sortrows(roulette,2);
%     roulette(:,3)=roulette(:,2)*1.2;%伪适应度
%     sumFitness=sum(roulette(:,3));%伪适应度之和
%     roulette(:,4)=roulette(:,3)/sumFitness;
%     roulette(1,5)=roulette(1,4);
%     for i=2:popu
%         roulette(i,5)=roulette(i-1,5)+roulette(i,4);
%     end
%     %得到轮盘，然后开始转指针
%     for i=1:popu
%         pointer=rand(1);
%         %开始检查指针的落脚处
%         if pointer<roulette(1,5)
%             outChromos(i,:)=inChromos(roulette(1,1),:);
%         else 
%             for j=2:popu
%                 if (pointer>roulette(j-1,5)&&(pointer<roulette(j,5)))
%                     outChromos(i,:)=inChromos(roulette(j,1),:);
%                     break;
%                 end
%             end
%         end
%     end
% end

%性能优化版本
% function outChromos = selectChromos(inChromos, popu, changeData, workpieceNum, machNum)
%     roulette=zeros(popu,5);
%     roulette(:,2)=calcFitness(inChromos,popu,changeData,workpieceNum,machNum);%适应度
%     roulette(:,1)=1:popu; %伪指针
%     roulette=sortrows(roulette,2);
%     roulette(:,3)=roulette(:,2)*1.2;%伪适应度
%     sumFitness=sum(roulette(:,3));%伪适应度之和
%     roulette(:,4)=roulette(:,3)/sumFitness;
%     roulette(1,5)=roulette(1,4);
%     roulette(:, 5) = cumsum(roulette(:, 4));
%     % 使用rand一次性生成所有的指针
%     pointers = rand(1, popu);
% 
%     % 使用histcounts进行选择
%     %%%%%%%%%%%%%%%%%%%%%%%%%GPT%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%看不懂%%%%%%%%%%%%%%%%%%%%%%%%
%     [~, ~, idx] = histcounts(pointers, [0; roulette(:, 5)]);
%     outChromos = inChromos(roulette(idx, 1), :);
% end


% function outChromos = selectChromos(inChromos, popu, changeData, workpieceNum, machNum)
%     roulette=zeros(popu,5);
%     roulette(:,2)=calcFitness(inChromos,popu,changeData,workpieceNum,machNum);%适应度
%     global thisCmax;
%     thisCmax=min(roulette(:,2));
%     roulette(:,1)=1:popu; %伪指针
%     roulette=sortrows(roulette,2);
%     roulette(:,3)=roulette(:,2)*1.2;%伪适应度
%     roulette(:,3)=1./roulette(:,3);
%     sumFitness=sum(roulette(:,3));%伪适应度之和
%     roulette(:,4)=roulette(:,3)/sumFitness;
%     roulette(1,5)=roulette(1,4);
%     roulette(:, 5) = cumsum(roulette(:, 4));
% 
%     % 使用rand一次性生成所有的指针
%     pointers = rand(1, popu);
% 
%     % 使用histcounts进行选择
%     %%%%%%%%%%%%%%%%%%%%%%%%%GPT%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%看不懂%%%%%%%%%%%%%%%%%%%%%%%%
%     [~, ~, idx] = histcounts(pointers, [0; roulette(:, 5)]);
%     outChromos = inChromos(roulette(idx, 1), :);
% end



% function outChromos = selectChromos(inChromos, popu, changeData, workpieceNum, machNum)
%     roulette=zeros(popu,5);
%     roulette(:,2)=calcFitness(inChromos,popu,changeData,workpieceNum,machNum);%适应度
%     global thisCmax;
%     thisCmax=min(roulette(:,2));
%     roulette(:,1)=1:popu; %伪指针
%     roulette=sortrows(roulette,2);
%     roulette(:,3)=roulette(:,2)*2;%伪适应度
%     roulette(:,3)=1./roulette(:,3);
%     sumFitness=sum(roulette(:,3));%伪适应度之和
%     roulette(:,4)=roulette(:,3)/sumFitness;
%     roulette(1,5)=roulette(1,4);
%     roulette(:, 5) = cumsum(roulette(:, 4));
% 
%     % 使用rand一次性生成所有的指针
%     pointers = rand(1, popu);
% 
%     % 使用histcounts进行选择
%     [~, ~, idx] = histcounts(pointers, [0; roulette(:, 5)]);
% 
%     % 精英选择，将上一代中的最优个体直接复制到下一代中
%     [~, eliteIdx] = min(roulette(:, 2));
%     outChromos = inChromos(roulette(idx, 1), :);
%     outChromos(end, :) = inChromos(eliteIdx, :);
% end

% function outChromos = selectChromos(inChromos, popu, changeData, workpieceNum, machNum)
%     roulette=zeros(popu,5);
%     roulette(:,2)=calcFitness(inChromos,popu,changeData,workpieceNum,machNum); % 适应度
%     global thisCmax;
%     thisCmax=min(roulette(:,2));
%     roulette(:,1)=1:popu; % 伪指针
%     roulette=sortrows(roulette,2);
%     roulette(:,3)=roulette(:,2)*1.2; % 伪适应度
%     roulette(:,3)=1./roulette(:,3);
%     sumFitness=sum(roulette(:,3)); % 伪适应度之和
%     roulette(:,4)=roulette(:,3)/sumFitness;
%     roulette(1,5)=roulette(1,4);
%     roulette(:, 5) = cumsum(roulette(:, 4));
% 
%     % 使用 rand 一次性生成所有的指针
%     pointers = rand(1, popu);
% 
%     % 使用 histcounts 进行选择
%     [~, ~, idx] = histcounts(pointers, [0; roulette(:, 5)]);
% 
%     % 精英选择，将上一代中的最优两个个体直接复制到下一代中
%     [~, eliteIdx] = sort(roulette(:, 2));
%     eliteCount = round(popu/50); % 保留最优的两个个体
%     eliteChromos = inChromos(eliteIdx(1:eliteCount), :);
% 
%     % 遗传下去，除了精英个体外的其他个体
%     outChromos = inChromos(roulette(idx, 1), :);
% 
%     % 将精英个体插入到新种群中
%     outChromos(end-eliteCount+1:end, :) = eliteChromos;
% end

% function outChromos = selectChromos(inChromos, popu, changeData, workpieceNum, machNum)
%     roulette = zeros(popu, 5);
%     fitness = calcFitness(inChromos, popu, changeData, workpieceNum, machNum);
%     global thisAGVCmax;
%     global thisMinCmax;
%     thisAGVCmax=mean(fitness);
%     thisMinCmax=min(fitness);
% 
%     % 适应度缩放
%     scaledFitness = 1 ./ (fitness + min(fitness));
% 
%     roulette(:, 2) = fitness; % 适应度
%     roulette(:, 1) = 1:popu; % 伪指针
%     roulette(:, 3) = scaledFitness *1; % 伪适应度，可以根据问题的特性调整缩放参数
%     sumFitness = sum(roulette(:, 3)); % 伪适应度之和
%     roulette(:, 4) = roulette(:, 3) / sumFitness;
%     roulette(1, 5) = roulette(1, 4);
%     roulette(:, 5) = cumsum(roulette(:, 4));
% 
%     % 使用 rand 一次性生成所有的指针
%     pointers = rand(1, popu);
% 
%     % 使用 histcounts 进行选择
%     [~, ~, idx] = histcounts(pointers, [0; roulette(:, 5)]);
% 
%     % 精英选择，将上一代中的最优两个个体直接复制到下一代中
%     [~, eliteIdx] = sort(fitness);
%     eliteCount = round(popu/20); % 保留最优的几个个体
%     eliteChromos = inChromos(eliteIdx(1:eliteCount), :);
% 
%     % 遗传下去，除了精英个体外的其他个体
%     outChromos = inChromos(roulette(idx, 1), :);
% 
%     % 将精英个体插入到新种群中
%     outChromos(end - eliteCount + 1:end, :) = eliteChromos;
% end

