% 载入算例
function [changeData,workpieceNum,machNum]=changeDataFunction()
    %奇数列是机器号，偶数列是对应的时间
    %行代表工件号
    %FT10
    data=[0 29 1 78 2  9 3 36 4 49 5 11 6 62 7 56 8 44 9 21;
 0 43 2 90 4 75 9 11 3 69 1 28 6 46 5 46 7 72 8 30;
 1 91 0 85 3 39 2 74 8 90 5 10 7 12 6 89 9 45 4 33;
 1 81 2 95 0 71 4 99 6  9 8 52 7 85 3 98 9 22 5 43;
 2 14 0  6 1 22 5 61 3 26 4 69 8 21 7 49 9 72 6 53;
 2 84 1  2 5 52 3 95 8 48 9 72 0 47 6 65 4  6 7 25;
 1 46 0 37 3 61 2 13 6 32 5 21 9 32 8 89 7 30 4 55;
 2 31 0 86 1 46 5 74 4 32 6 88 8 19 9 48 7 36 3 79;
 0 76 1 69 3 76 5 51 2 85 9 11 6 40 7 89 4 26 8 74;
 1 85 0 13 2 61 6  7 8 64 9 76 5 47 3 52 4 90 7 45];
    odd=1:2:size(data,2);
    data(:,odd)=data(:,odd)+1;
    changeData=data;  
    workpieceNum=size(data,1);
    machNum=size(data,2)/2;
end


% function [changeData,workpieceNum,machNum]=changeDataFunction()
%     %奇数列是机器号，偶数列是对应的时间
%     %行代表工件号
%     %FT06
%     data=[2  1  0  3  1  6  3  7  5  3  4  6;
%  1  8  2  5  4 10  5 10  0 10  3  4;
%  2  5  3  4  5  8  0  9  1  1  4  7;
%  1  5  0  5  2  5  3  3  4  8  5  9 ;
%  2  9  1  3  4  5  5  4  0  3  3  1;
%  1  3  3  3  5  9  0 10  4  4  2  1];
%     odd=1:2:size(data,2);
%     data(:,odd)=data(:,odd)+1;
%     changeData=data;  
%     workpieceNum=size(data,1);
%     machNum=size(data,2)/2;
% end

% function [changeData,workpieceNum,machNum]=changeDataFunction()
%     %奇数列是机器号，偶数列是对应的时间
%     %行代表工件号
%     data=[0 3 1 2 2 3;2 2 0 3 1 4;1 2 2 2 0 3];
%     odd=1:2:size(data,2);
%     data(:,odd)=data(:,odd)+1;
%     changeData=data;  
%     workpieceNum=size(data,1);
%     machNum=size(data,2)/2;
% end


% function [changeData,workpieceNum,machNum]=changeDataFunction()
%     %奇数列是机器号，偶数列是对应的时间
%     %行代表工件号
%     data=[0 3 1 3 2 2;0 1 2 5 1 3;1 3 0 2 2 3];
%     odd=1:2:size(data,2);
%     data(:,odd)=data(:,odd)+1;
%     changeData=data;  
%     workpieceNum=size(data,1);
%     machNum=size(data,2)/2;
% end