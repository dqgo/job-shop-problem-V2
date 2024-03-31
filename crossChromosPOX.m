function newChromos = crossChromosPOX(chromos, Pcross, popu,workpieceNum)
    newChromos = chromos;
    for i = 1:2:popu        
        if rand() < Pcross
            [newChromos(i,:),newChromos(i+1,:)]=POXCrossover(chromos(i,:),chromos(i+1,:),workpieceNum);
        end
    end
end

function [cChromo1, cChromo2] = POXCrossover(pChromo1, pChromo2,workpieceNum)
    J1 = randperm(workpieceNum, randperm(workpieceNum,1));
    J2 = setdiff(1:workpieceNum, J1);
    cChromo1 = pChromo1;
    for j = J1
        cChromo1(cChromo1 == j) = pChromo1(pChromo1 == j);
    end
    cChromo2 = pChromo2;
    for j = J1
        cChromo2(cChromo2 == j) = pChromo2(pChromo2 == j);
    end
    for j = J2
        cChromo2(cChromo2 == j) = pChromo1(pChromo1 == j);
    end
    for j = J2
        cChromo1(cChromo1 == j) = pChromo2(pChromo2 == j);
    end
end
