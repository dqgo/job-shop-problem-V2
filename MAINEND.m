%MIANEND部分
function MAINEND(popu,chromos,changeData,workpieceNum,machNum)   
    global MAINNum;
    global EndAns;
    endFitness=zeros(popu,2);
    endFitness(:,1)=1:popu;
    endFitness(:,2)= calcFitness(chromos,popu,changeData,workpieceNum,machNum);
    endFitness=sortrows(endFitness,2);
    endFitness(1,2) %输出最优解的值
    EndAns(1,MAINNum)=endFitness(1,2);
    endChromo=chromos(endFitness(1,1),:); %输出最优染色体序列
    bestSchedule = createSchedule(changeData,endChromo,workpieceNum,machNum);
    %ganttData={[bestSchedule(:,4)'];[bestSchedule(:,5)'];[bestSchedule(:,3)'];[bestSchedule(:,1)'];[bestSchedule(:,2)']};
    %drewGant(ganttData) %画出甘特图
    drewGant(bestSchedule,workpieceNum,machNum)
end