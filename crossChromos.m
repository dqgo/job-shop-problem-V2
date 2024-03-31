function chromos=crossChromos(chromos,Pcross,popu,workpieceNum)
    if rand()<=0.9
        chromos=crossChromosPOX(chromos,Pcross,popu,workpieceNum);
    else
        chromos=crossChromosPMX(chromos,Pcross,popu);
    end
end

% function chromos = crossChromos(chromos, Pcross, popu, workpieceNum,numCross,machNum,changeData)
%     newChromos = chromos;
%     for i = 1:2:popu
%         % 检查是否应该进行交叉
%         if rand() < Pcross
%             % 选择两个父代染色体
%             parent1 = chromos(i, :);
%             parent2 = chromos(i+1, :);
%             % 多次交叉
%             for j = 1:numCross
%                 % 随机选择交叉算法
%                 if rand() <= 0.7
%                     tempChromos = crossChromosPOX([parent1; parent2], Pcross,2, workpieceNum);
%                 else
%                     tempChromos = crossChromosPMX([parent1; parent2], Pcross,2);
%                 end
% 
%                 % 选择最优染色体
%                 if calcFitness(tempChromos(1,:),1,changeData,workpieceNum,machNum) > calcFitness(newChromos(i, :),1,changeData,workpieceNum,machNum)
%                     newChromos(i, :) = tempChromos(1,:);
%                 end
% 
%                 if calcFitness(tempChromos(2,:),1,changeData,workpieceNum,machNum) > calcFitness(newChromos(i+1, :),1,changeData,workpieceNum,machNum)
%                     newChromos(i+1, :) = tempChromos(2,:);
%                 end
%             end
%         end
%     end
%       % 更新染色体
%     chromos = newChromos;
% end

% function chromos = crossChromos(chromos, Pcross, popu, workpieceNum, numCross, machNum, changeData)
%     newChromos = chromos;
%     for i = 1:2:popu
%         % 检查是否应该进行交叉
%         if rand() < Pcross
%             % 选择两个父代染色体
%             parent1 = chromos(i, :);
%             parent2 = chromos(i+1, :);
%             % 生成 2n 个新的子代
%             offspring = zeros(2*numCross, length(parent1));
%             for j = 1:numCross
%                 if rand() <= 0.5
%                     temp1 = crossChromosPOX([parent1; parent2], Pcross, 2, workpieceNum);
%                 else
%                     temp1 = crossChromosPMX([parent1; parent2], Pcross, 2);
%                 end
%                 % 存储两行子代
%                 offspring(2*j-1, :) = temp1(1,:);
%                 offspring(2*j, :) = temp1(2,:);
%             end
%             % 选择最优的两个子代和父代
%             allChromos = [parent1; parent2; offspring];
%             %[~, idx] = max(calcFitness(allChromos,1,changeData,workpieceNum,machNum));
%             [fitness, idx] = sortrows(calcFitness(allChromos,size(allChromos,1),changeData,workpieceNum,machNum));
%             % 更新染色体
%             newChromos(i, :) = allChromos(idx(1), :);
%             newChromos(i+1, :) = allChromos(idx(2), :);
%         end
%     end
%     chromos = newChromos;
% end

