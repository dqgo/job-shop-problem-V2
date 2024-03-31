%适应度计算，输入一个种群，得到这个种群的每个染色体的适应度
function fitness= calcFitness(chromos,popu,changeData,workpieceNum,machNum)
    fitness=zeros(size(chromos,1),1);
    for i=1:size(chromos,1)
        schedule=createSchedule(changeData,chromos(i,:),workpieceNum,machNum);
        fitness(i,1)=max(schedule(:,5));
    end
end


