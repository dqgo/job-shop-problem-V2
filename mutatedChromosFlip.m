% 变异操作：输入且得到一个种群
function outChromos=mutatedChromosFlip(inChromos,Pmuta,popu)
    lengthChromo=size(inChromos(1,:),2);
    for i=1:popu
        outChromos(i,:)=inChromos(i,:);
        if rand(1)<Pmuta %逆一个
            point=sort(randperm(lengthChromo,2));
            subsegment=inChromos(i,point(1):point(2));
            newSubsegment=fliplr(subsegment);
            outChromos(i,point(1):point(2))=newSubsegment;
            % disp(i)
        end
    end
end