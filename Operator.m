function Offspring = Operator(Loser,Winner, Diversity, phi1, phi2)
    % The code of CLMCSO

    %% Parameter setting
    LoserDec  = Loser.decs;
    WinnerDec = Winner.decs;
    DivDec = Diversity.decs;
    [N,D]     = size(LoserDec);
	LoserVel  = Loser.adds;
    WinnerVel = Winner.adds;
    Global    = GLOBAL.GetObj();

    %% Competitive swarm optimizer
    r1     = repmat(rand(N,1),1,D);
    r2     = repmat(rand(N,1),1,D);
    r3     = repmat(rand(N,1),1,D);
    OffVel = r1.*LoserVel + phi1*r2.*(WinnerDec-LoserDec) + phi2*r3.*(DivDec-LoserDec);
    OffDec = LoserDec + OffVel + r1.*(OffVel-LoserVel);%;%
    %% Update the winners
    OffDec1 = WinnerDec;
    OffVel1 = WinnerVel;
 
    %% Polynomial mutation
    Lower  = repmat(Global.lower,N,1);
    Upper  = repmat(Global.upper,N,1);
    disM   = 20;
    Site   = rand(N,D) < 1/D;
    mu     = rand(N,D);
    temp   = Site & mu <= 0.5;
    OffDec1       = max(min(OffDec1,Upper),Lower);
    OffDec1(temp) = OffDec1(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                   (1-(OffDec1(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
    temp  = Site & mu>0.5; 
    OffDec1(temp) = OffDec1(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                   (1-(Upper(temp)-OffDec1(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
	Offspring = INDIVIDUAL([OffDec1;OffDec],[OffVel1;OffVel]);
%     Offspring = INDIVIDUAL(OffDec,OffVel);
end