function  keyPath = searchKeyPath2(schedule1, schedule2)
% keyPath=[机器号 在染色体上的位置]
    % 找到关键工序的逻辑向量 
    keyWorkpiecLogical = all(schedule1 == schedule2, 2);
    % 找到关键工序的索引
    keyIndices = find(keyWorkpiecLogical);
    keyWorkpiece = [schedule1(keyIndices, 1:5),keyIndices];
    keyPath=[keyWorkpiece(end,3),keyWorkpiece(end,6)];
    % for i=size(keyWorkpiece,1):-1:2
    %     thisStartTime=keyWorkpiece(i,4);
    %     [row,~]=find(keyWorkpiece(:,5)==thisStartTime);         
    % end
      point=size(keyWorkpiece,1);
    while(point)
        thisStartTime=keyWorkpiece(point,4);
        thisMachId=keyWorkpiece(point,3);
        [row,~]=find(keyWorkpiece(:,5)==thisStartTime); 
        rowSize=size(row,1);
        if rowSize==0
            point=0;
            break;
        elseif rowSize==1
            keyPath(end+1,:)=[keyWorkpiece(row,3),keyWorkpiece(row,6)];
            point=row;
        else 
            mayKeyPath=keyWorkpiece(row,:);
            mayKeyPath=mayKeyPath(mayKeyPath(:,3)~=thisMachId,:);
            % [point,~]=find(keyWorkpiece==mayKeyPath(1,:));
            point = find(ismember(keyWorkpiece, mayKeyPath(1,:), 'rows'));
            keyPath(end+1,: )=[mayKeyPath(1,3),mayKeyPath(1,6)];
        end
    end
    keyPath=sortrows(keyPath,2);
end





% function  keyPath = searchKeyPath2(schedule1, schedule2)
%     % 找到关键工序的逻辑向量 
%     keyWorkpiecLogical = all(schedule1 == schedule2, 2);
%     % 找到关键工序的索引
%     keyIndices = find(keyWorkpiecLogical);
%     keyWorkpiece = [schedule1(keyIndices, 1:5),keyIndices];
%     keyPath=cell(1);
%     %最后一个关键块一定是关键路径的终点
%     keyPath{1,1}=[keyWorkpiece(end,6),keyWorkpiece(end,3)];
%     keyWorkpiece(end,:)=[];
%     [newkeyWorkpiece,keyPath]=f(keyWorkpiece,keyPath);
%     disp(schedule1(keyIndices, 1:2));
% end
% 
% 
% function [newkeyWorkpiece,outCell]=f(keyWorkpiece,oneCell)
%     while(size(keyWorkpiece,1)~=0)
%         thisStartTime=keyWorkpiece(end,4);        
%         tempkeyWorkpiece=keyWorkpiece(keyWorkpiece(:,5)==thisStartTime,:);
%         thisSize=size(tempkeyWorkpiece,1);
%         if thisStartTime==0 %是最后一个了
%             oneCell{1,1} = [oneCell{1,1}; [keyWorkpiece(end,6), keyWorkpiece(end,3)]]; 
%         end
%         if thisSize==1 %没有分叉
%             oneCell{1,1} = [oneCell{1,1}; [keyWorkpiece(end,6), keyWorkpiece(end,3)]];            
%             keyWorkpiece(end,:)=[];
%             [row,~]=find(keyWorkpiece(:,5)==thisStartTime);            
%             [newkeyWorkpiece,outCell]=f(keyWorkpiece(1:row(end),:),oneCell);
%             outCell=[oneCell;outCell];
%         else %有分叉
%             oneCell{1,1} = [oneCell{1,1}; [keyWorkpiece(end,6), keyWorkpiece(end,3)]]; 
%             keyWorkpiece(end,:)=[];
%             for i=1:thisSize-1
%                 oneCell{i+1}=oneCell{1};
%             end
%             for i=1:thisSize
%                 [newkeyWorkpiece,outCell]=f(keyWorkpiece,oneCell(i));
%                 outCell=[oneCell{i};outCell];
%             end
%         end
%     end
% end





% function  keyPath = searchKeyPath2(schedule1, schedule2)
%     % 找到关键工序的逻辑向量 
%     keyPathLogical = all(schedule1 == schedule2, 2);
%     % 找到关键工序的索引
%     keyIndices = find(keyPathLogical);   
%     keyPath = [keyIndices, schedule1(keyIndices, 3)];
%     disp(schedule1(keyIndices, 1:2));
% end
