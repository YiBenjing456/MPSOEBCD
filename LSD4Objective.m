function [LSD, Population] = LSD4Objective(Population)
    %LSD4OBJECTIVE 此处显示有关此函数的摘要
    %% get the fitness;
    Fitness = Population.objs;
    [PopSize, M] = size(Fitness);
    LSD = zeros(1, PopSize);
    cn = 1;
    while cn <= M
        TempF = Fitness(:, cn)';
        [TempF, SortedIndex] = sort(TempF);
        Population = Population(SortedIndex);
        LSD = LSD(SortedIndex);
        x(1,:) = TempF(3:PopSize) - TempF(2:PopSize-1);
        x(2,:) = TempF(2:PopSize-1) - TempF(1:PopSize-2);
        x = sort(x);
        TempLSD = ((x(1,:)./x(2,:))/max(x(1,:)./x(2,:))).*(sum(x)/max(sum(x)));
        LSD(2: PopSize-1) = LSD(2: PopSize-1) + TempLSD;
%         LSD(1) = inf;
        cn = cn + 1;
    end
end

