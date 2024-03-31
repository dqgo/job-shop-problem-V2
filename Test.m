w=zeros(1,1000000);  

for j=1:1000000
    p = 1;    

    n = 100;
    outc = 2*rand(n,1) - 1; 
    we = p;
    for i = 1:n
        if outc(i) > 0
            we = we*1.1; 
        else
            we = we*0.9;
        end
    end    

    mealth = mean(we); % 期望财富
  
    w(1,j)=mealth;
    
end
mean2(w)