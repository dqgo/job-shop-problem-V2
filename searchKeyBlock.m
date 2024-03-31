% % %找到关键块函数，输入一个关键路径，得到是否含有关键块，和他的关键块
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%GPT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% keyPath=[机器号 在染色体上的位置]
% keyBlock{}=[在染色体上的位置]
function keyBlock = searchKeyBlock(keyPath)
if(size(keyPath)~=0)
        numSteps = size(keyPath, 1);
        keyBlock = cell(1, numSteps); % 为每个步骤初始化一个关键块
        % 初始化第一个关键块
        currentBlock = [keyPath(1, 2)];
        currentMachine = keyPath(1, 1);
        for i = 2:numSteps
            if keyPath(i, 1) == currentMachine
                % 与前一个工序在同一台机器上，添加到当前块
                currentBlock = [currentBlock, keyPath(i, 2)];
            else
                % 不在同一台机器上，结束当前块，并初始化新块
                if numel(currentBlock) > 1
                    keyBlock{i - 1} = currentBlock;
                end
                currentBlock = [keyPath(i, 2)];
                currentMachine = keyPath(i, 1);
            end
        end
        % 存储最后一个关键块
        if numel(currentBlock) > 1
            keyBlock{numSteps} = currentBlock;
        end
        % 移除空块
        keyBlock = keyBlock(~cellfun('isempty', keyBlock));
    else
    keyBlock={};
end





% function keyBlock = searchKeyBlock(keyPath)
% if(size(keyPath)~=0)
%         numSteps = size(keyPath, 1);
%         keyBlock = cell(1, numSteps); % 为每个步骤初始化一个关键块
%         % 初始化第一个关键块
%         currentBlock = [keyPath(1, 1)];
%         currentMachine = keyPath(1, 2);
%         for i = 2:numSteps
%             if keyPath(i, 2) == currentMachine
%                 % 与前一个工序在同一台机器上，添加到当前块
%                 currentBlock = [currentBlock, keyPath(i, 1)];
%             else
%                 % 不在同一台机器上，结束当前块，并初始化新块
%                 if numel(currentBlock) > 1
%                     keyBlock{i - 1} = currentBlock;
%                 end
%                 currentBlock = [keyPath(i, 1)];
%                 currentMachine = keyPath(i, 2);
%             end
%         end
%         % 存储最后一个关键块
%         if numel(currentBlock) > 1
%             keyBlock{numSteps} = currentBlock;
%         end
%         % 移除空块
%         keyBlock = keyBlock(~cellfun('isempty', keyBlock));
% else
%     keyBlock={};
% end

















% function keyBlock = searchKeyBlock(keyPath)
% 
%     numSteps = size(keyPath, 1);
%     keyBlock = cell(1, numSteps); % 为每个步骤初始化一个关键块
% 
%     % 初始化第一个关键块
%     currentBlock = [keyPath(1, 1)];
%     currentMachine = keyPath(1, 2);
% 
%     for i = 2:numSteps
%         if keyPath(i, 2) == currentMachine
%             % 与前一个工序在同一台机器上，添加到当前块
%             currentBlock = [currentBlock, keyPath(i, 1)];
%         else
%             % 不在同一台机器上，结束当前块，并初始化新块
%             if numel(currentBlock) > 1
%                 keyBlock{i - 1} =currentBlock;
%             end
%             currentBlock = [keyPath(i, 1)];
%             currentMachine = keyPath(i, 2);
%         end
%     end
% 
%     % 存储最后一个关键块
%     if numel(currentBlock) > 1
%         keyBlock{numSteps} = currentBlock;
%     end
% 
%     % 移除空块
%     keyBlock = keyBlock(~cellfun('isempty', keyBlock));
% end
% 
