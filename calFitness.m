function Fitness = calFitness(PopObj)
    % Calculate the fitness by shift-based density
    [N, M] = size(PopObj);
    fmax = max(PopObj,[],1);
    fmin = min(PopObj,[],1);
    % normlization
    PopObj = (PopObj-repmat(fmin,N,1))./repmat(fmax-fmin,N,1);
    % compute the fitness
    Fitness = zeros(1,N);
    cn = 1;
    while cn <= N
        DiffObj = repmat(PopObj(cn, :),N,1) - PopObj;
        flag = DiffObj > 0;
        factor = sum(flag, 2)/M;
        Fitness(cn) = Fitness(cn) + sum(factor.*sum(DiffObj.*flag, 2));
        cn = cn + 1;
    end
end
