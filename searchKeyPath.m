%找关键路径函数，输入两个时间表，输出关键路径对应的工序在染色体上的位置
%keyPath=[在染色体上的序号 该工序对应的机器号]

function keyPath = searchKeyPath(schedule1,schedule2)

    lengthNum=size(schedule1,1);
    num=1;
    for i=1:lengthNum
        if schedule1(i,:)==schedule2(i,:)
            keyPath(num,:)=[i,schedule1(i,3)];
            num=num+1;
        end
    end
end

%性能改进版本
% function [noKeyPath, keyPath] = searchKeyPath2(schedule1, schedule2)
%     % 找到关键路径的逻辑向量
%     keyPathLogical = all(schedule1 == schedule2, 2);
% 
%     % 找到关键路径的索引
%     keyIndices = find(keyPathLogical);
% 
%     noKeyPath = isempty(keyIndices);
%     keyPath = [keyIndices, schedule1(keyIndices, 3)];
% end
