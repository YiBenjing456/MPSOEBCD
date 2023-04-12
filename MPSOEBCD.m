function MPSOEBCD(Global)
% <algorithm> <M>

    %% Generate random population
    IGDTrace = [];
    IGDTrace1 = [];
    StdTrace = [];
    currentTemp = 0;
    phi1 = 1;
    phi2 = 0.4;
    [V,Global.N] = UniformPoint(Global.N,Global.M);
    Population   = Global.Initialization();
    Population   = EnvironmentalSelection(Population,V,(Global.gen/Global.maxgen)^2);
    [N, D] = size(Population.decs);
    Vel = zeros(N, D);
    Population = Population.adds_(Vel);
    
    %% Optimization
    terminalX = Global.NotTermination(Population);
    cnGen = 1;
    while terminalX
        [LSD, Population] = LSD4Objective(Population);
        Fitness = calFitness(Population.objs);
        if length(Population) >= 2
            Rank = randperm(length(Population),floor(length(Population)/2)*2);
        else
            Rank = [1,1];
        end
        Loser  = Rank(1:end/2);
        Winner = Rank(end/2+1:end);
        Change = Fitness(Loser) <= Fitness(Winner);
        Temp   = Winner(Change);
        Winner(Change) = Loser(Change);
        Loser(Change)  = Temp;
        DivIndex = zeros(1, length(Loser));
        %% div
        [~, pos] = sort(LSD);
        cncn = 1;
        while cncn <= length(Loser)
            PosCn = find(pos == Loser(cncn));
            DivIndex(cncn) = pos(ceil(PosCn + rand*(length(Population) - PosCn)));
            cncn = cncn + 1;
        end
        Offspring      = Operator(Population(Loser),Population(Winner),Population(DivIndex),phi1,phi2);
        fprintf('Offspring length :%e',length([Population,Offspring]))
        fprintf(' phi :%e\n', phi1)
        if mod(cnGen,10) == 1
            tempDec = Offspring.decs;
            [Npop, ~] = size(tempDec);
            mean_p = repmat(mean(tempDec),Npop,1);
            stdTemp = sum(sqrt(sum((tempDec-mean_p).*(tempDec-mean_p),2)))/Npop;
            StdTrace = [StdTrace stdTemp];
        end
        Population     = EnvironmentalSelection([Population,Offspring],V,(Global.gen/Global.maxgen)^2);
        if mod(cnGen,10) == 1
            idgtemp = IGD(Population.objs,Global.PF);
            IGDTrace = [IGDTrace idgtemp];
        end
        terminalX = Global.NotTermination(Population);
        if ~terminalX
%             [Npop, ~] = size(tempDec);
%             mean_p = repmat(mean(tempDec),Npop,1);
%             stdTemp = sum(sqrt(sum((tempDec-mean_p).*(tempDec-mean_p),2)))/Npop;
%             StdTrace = [StdTrace stdTemp];
            idgtemp = IGD(Population.objs,Global.PF);
            IGDTrace = [IGDTrace idgtemp];
            folder = fullfile('Data',func2str(Global.algorithm));
            save(fullfile(folder,sprintf('%s_%s_%s_M%d_D%d_%d.mat','1004IGDTrace',func2str(Global.algorithm),class(Global.problem),Global.M,Global.D,Global.run)),'IGDTrace');
            save(fullfile(folder,sprintf('%s_%s_%s_M%d_D%d_%d.mat','1004StdTrace',func2str(Global.algorithm),class(Global.problem),Global.M,Global.D,Global.run)),'StdTrace');
        end   
%         fprintf('Population length :%e\n',length(Population))
        cnGen = cnGen + 1;
    end
%     folder = pwd;
%     y = sprintf('Std-Trace-%s_%s_M%d_D%d_%d.mat',func2str(Global.algorithm),class(Global.problem),Global.M,Global.D,Global.run);
%     save(y, 'StdTrace');
end
