%函数输入对应的染色体和他的关键块 输出他的所有N5邻域操作之后的邻域染色体
%keyBlock是元胞
function neighborhoodChromos=creatneighborhoodChromosN5(chromo,keyBlock)
    neighborhoodChromos=chromo;
    blockNum=size(keyBlock,2); 
    
    if blockNum==0
        neighborhoodChromos=chromo;
    end
    for i=1:blockNum
        chromosTemp=zeros(0);
        thisBlock=keyBlock{i};
        sizeBlock=size(thisBlock,2);
        if sizeBlock==2            
            %chromo=swap(thisBlock(1),thisBlock(2),chromo);
            chromosTemp=[chromosTemp;swap(thisBlock(1),thisBlock(2),chromo)];
        else
            %chromo=swap(thisBlock(1),thisBlock(2),chromo);
            %只交换首或尾
            chromosTemp=[chromosTemp;swap(thisBlock(1),thisBlock(2),chromo)];
            chromosTemp=[chromosTemp;swap(size(thisBlock,2)-1,size(thisBlock,2),chromo)];
            %同时交换首和尾
            chromoTemp=swap(thisBlock(1),thisBlock(2),chromo);
            chromoTemp=swap(size(thisBlock,2)-1,size(thisBlock,2),chromo);
            chromosTemp=[chromosTemp;chromoTemp];
            %chromo=swap(size(thisBlock,2)-1,size(thisBlock,2),chromo);
        end
        neighborhoodChromos=[neighborhoodChromos;chromosTemp];
    end
end

function chromo = swap(id1,id2,chromo)
    temp=chromo(1,id1);
    chromo(1,id1)=chromo(1,id2);
    chromo(1,id2)=temp;
end


% function neighborhoodChromos = creatneighborhoodChromos(chromo, keyBlock)
%     numOperations = length(chromo);
%     numKeyBlocks = length(keyBlock);
%     neighborhoodChromos = cell(1, numOperations * (numOperations - 1) * numKeyBlocks);
% 
%     index = 1;
%     for i = 1:numOperations
%         for j = (i + 1):numOperations
%             for k = 1:numKeyBlocks
%                 % 复制原染色体以进行修改
%                 neighborChromo = chromo;
% 
%                 % 交换位于关键块内的两个工序的位置
%                 block = keyBlock{k};
%                 neighborChromo(block(i)) = chromo(block(j));
%                 neighborChromo(block(j)) = chromo(block(i));
% 
%                 % 存储邻域染色体
%                 neighborhoodChromos{index} = neighborChromo;
%                 index = index + 1;
%             end
%         end
%     end
% end
