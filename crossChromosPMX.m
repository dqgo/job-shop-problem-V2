%交叉操作：输入一个种群，得到一个新种群
%PMX方法  索引概率0.7
function outChromos=crossChromosPMX(inChromos,Pcross,popu) 
    lengthChromo=size(inChromos(1,:),2);
    for i=1:2:popu-1
        if rand(1)<Pcross %需要交叉
            point=randperm(lengthChromo,2);
            point=sort(point);
            point1=point(1,1);point2=point(1,2); %得到两个交叉点
            pChromo1=inChromos(i,:);pChromo2=inChromos(i+1,:);
            subsegment1=pChromo1(1,point1:point2);subsegment2=pChromo2(1,point1:point2);
            cChromo1=pChromo1;cChromo2=pChromo2;
            cChromo1(1,point1:point2)=subsegment2;
            cChromo2(1,point1:point2)=subsegment1; %已经完成了两点之间的交叉，开始检查
            [newSubsegment1, newSubsegment2]=createNewSubsegment(subsegment1,subsegment2);
            if size(newSubsegment2,2)>0 %如果新子串的大小大于0，那就要做匹配工作了
                if point1==1 %从头开始的交换
                    [cChromo1,cChromo2]=matchingTopStart(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2,lengthChromo);
                else %不是从头开始的交换
                    if point2==lengthChromo %从中间到末尾的交换
                        [cChromo1, cChromo2]=matchingEndEnd(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2,lengthChromo);
                    else %全都在中间的交换
                        [cChromo1, cChromo2]=matchingMid(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2,lengthChromo);
                    end
                end
            end
            outChromos(i,:)=cChromo1;outChromos(i+1,:)=cChromo2;
        else
            outChromos(i,:)=inChromos(i,:);outChromos(i+1,:)=inChromos(i+1,:);
        end
    end
end

%交叉操作的子模块，匹配首开始的子代
function [cChromo1, cChromo2]=matchingTopStart(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2,lengthChromo)

    for i=1:size(newSubsegment1,2) %修改cC1
        for j=point2+1:lengthChromo
            if newSubsegment2(1,i)==cChromo1(1,j)
                cChromo1(1,j)=newSubsegment1(1,i);
                break;
            end
        end
    end
    for i=1:size(newSubsegment1,2) %修改cC2
        for j=point2+1:lengthChromo
            if newSubsegment1(1,i)==cChromo2(1,j)
                cChromo2(1,j)=newSubsegment2(1,i);
                break;
            end
        end
    end
end

%交叉操作的子模块，匹配末尾结束的子代
function [cChromo1, cChromo2]=matchingEndEnd(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2,lengthChromo)
    % cChromo1(1,1:point1-1)=pChromo1(1,1:point1-1);
    % cChromo2(1,1:point1-1)=pChromo2(1,1:point1-1);
    for i=1:size(newSubsegment1,2)%修改cC1
        for j=1:1:point1-1
            if newSubsegment2(1,i)==cChromo1(1,j)
                cChromo1(1,j)=newSubsegment1(1,i);
                break;
            end
        end
    end
    for i=1:size(newSubsegment1,2)%修改cC2
        for j=1:1:point1-1
            if newSubsegment1(1,i)==cChromo2(1,j)
                cChromo2(1,j)=newSubsegment2(1,i);
                break;
            end
        end
    end
end

%交叉操作的子模块，匹配在中间的子代
function [cChromo1, cChromo2]=matchingMid(cChromo1,cChromo2,pChromo1,pChromo2,newSubsegment1,newSubsegment2,point1,point2,lengthChromo)

    for i=1:size(newSubsegment1,2) %修改cC1
        isMatching=0;
        for j=1:point1-1 %在前段进行匹配
            if newSubsegment2(1,i)==cChromo1(1,j)
                cChromo1(1,j)=newSubsegment1(1,i);
                isMatching=1;
                break;                
            end
        end
        if isMatching==0 %如果前段没有匹配成功，在后段匹配
            for j=point2+1:lengthChromo
                if newSubsegment2(1,i)==cChromo1(1,j)
                    cChromo1(1,j)=newSubsegment1(1,i);
                    break;
                end
            end
        end
    end
    for i=1:size(newSubsegment1,2) %修改cC2 %%%%%%%%%%%%%%YOUCUO
        isMatching=0;
        for j=1:point1-1 %在前段进行匹配
            if newSubsegment1(1,i)==cChromo2(1,j)
                cChromo2(1,j)=newSubsegment2(1,i);
                isMatching=1;
                break;                
            end
        end
        if isMatching==0 %如果前段没有匹配成功，在后段匹配
            for j=point2+1:lengthChromo
                if newSubsegment1(1,i)==cChromo2(1,j)
                    cChromo2(1,j)=newSubsegment2(1,i);
                    break;
                end
            end
        end
    end    
end

%交叉操作的子模块，删除掉输入的两个字符串之间的相同元素，得到两个新串
function [newSubsegment1, newSubsegment2]=createNewSubsegment(subsegment1,subsegment2)    
    for i=size(subsegment1,2):-1:1
        nowNum=subsegment1(1,i);
        for k=1:size(subsegment2,2)
            if nowNum==subsegment2(1,k)
                subsegment2(:,k)=[];
                subsegment1(:,i)=[];
                break;
            end
        end
    end
    newSubsegment1=subsegment1;newSubsegment2=subsegment2;
end
%测试通过