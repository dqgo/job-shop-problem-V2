% 变异操作：输入且得到一个种群
% function outChromos=mutatedChromos(inChromos,Pmuta,popu)
%     lengthChromo=size(inChromos(1,:),2);
%     for i=1:popu
%         outChromos(i,:)=inChromos(i,:);
%         if rand(1)<Pmuta %逆一个
%             point=sort(randperm(lengthChromo,2));
%             subsegment=inChromos(i,point(1):point(2));
%             newSubsegment=fliplr(subsegment);
%             outChromos(i,point(1):point(2))=newSubsegment;
%             % disp(i)
%         end
%     end
% end


% 使用邻域搜索的变异方法 
function outChromos=mutatedChromosNei(inChromos,Pmute,popu,muteNum,changeData,workpieceNum,machNum)    
    lengthChromo=size(inChromos(1,:),2);
    for i=1:popu
        outChromos(i,:)=inChromos(i,:);
        if rand()<Pmute
            pointer=randperm(lengthChromo,muteNum);
            arrangePointer=perms(inChromos(i,pointer));
            newChromos=inChromos(i,:);

            %得到邻域的初始化
            for j=1:size(arrangePointer,1)-1
                newChromos=[newChromos;inChromos(i,:)];
            end

            %找到每一个邻域
            for j=1:size(arrangePointer,1)                
                newChromos(j,pointer)=arrangePointer(j,:);
            end

            %对邻域进行适应度评价，找到最佳的来替换
            fitness= calcFitness(newChromos,popu,changeData,workpieceNum,machNum);
            [~,index]=sortrows(fitness);
            outChromos(i,:)=newChromos(index(1,1),:);
        end
    end        
end


