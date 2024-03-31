function outChromos = joinImmigrant(inChromos,fitness,machNum,workpieceNum,immigrantSize)
    popu=size(inChromos,1);
    newPopuNum=popu*immigrantSize;
    [~,index]=sortrows(fitness);
    newChromos = createInitialPopus(newPopuNum,machNum,workpieceNum);
    inChromos(index(end-newPopuNum+1:end),:)=newChromos;
    outChromos=inChromos;
end