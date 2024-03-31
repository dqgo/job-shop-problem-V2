% %初始化种群
% function initialPopus = createInitialPopus(popu,machNum,workpieceNum)
%         initialPopus=createInitialPopu(machNum,workpieceNum);
%         for i=2:popu
%             initialPopus=[initialPopus;createInitialPopu(machNum,workpieceNum)];
%         end
% end
% 
% %生成第一个染色体,随机
% function initialPopu = createInitialPopu(machNum,workpieceNum)
%     lengthChromo=machNum*workpieceNum;
%     initialPopu=zeros(1,lengthChromo);
%     initialPopu=1:machNum;
%     for i=1:workpieceNum-1
%         initialPopu=[initialPopu,1:machNum];
%     end
%     initialPopu=initialPopu(randperm(machNum*workpieceNum));
% end


% %初始化种群
% function initialPopus = createInitialPopus(popu,machNum,workpieceNum)
%         initialPopus=createInitialPopu(machNum,workpieceNum);
%         for i=2:popu
%             initialPopus=[initialPopus;createInitialPopu(machNum,workpieceNum)];
%         end
% end
% 
% %生成第一个染色体,随机
% function initialPopu = createInitialPopu(machNum,workpieceNum)
%     lengthChromo=machNum*workpieceNum;
%     initialPopu=zeros(1,lengthChromo);
%     initialPopu=1:workpieceNum;
%     for i=1:machNum-1
%         initialPopu=[initialPopu,1:workpieceNum];
%     end
%     initialPopu=initialPopu(randperm(machNum*workpieceNum));
% end


% 性能优化版本
% 初始化种群
function initialPopus = createInitialPopus(popu, machNum, workpieceNum)
    %B = arrayfun(func,A) 将函数 func 应用于 A 的元素，一次一个元素。
    % 然后 arrayfun 将 func 的输出串联成输出数组 B，因此，对于 A 的第 i 个元素来说，B(i) = func(A(i))。
    % 输入参数 func 是一个函数的函数句柄，此函数接受一个输入参数并返回一个标量。
    % func 的输出可以是任何数据类型，只要该类型的对象可以串联即可。（请参阅局限性查看一处例外。）
    % 数组 A 和 B 必须具有相同的大小。

    %%%Q? 为什么需要~ 这里不许要输入参数啊
    
    initialPopus = arrayfun(@(~) createInitialPopu(machNum, workpieceNum), 1:popu, 'UniformOutput', false);
    initialPopus = vertcat(initialPopus{:});

end

% 生成第一个染色体，随机
function initialPopu = createInitialPopu(machNum, workpieceNum) 
    lengthChromo = machNum * workpieceNum;    
    % 使用 repelem 生成重复的工件编号
    initialPopu = repelem(1:workpieceNum, machNum);    
    % 随机排列生成染色体
    initialPopu = initialPopu(randperm(lengthChromo));
end

