function J = configJogo( timer )
    
    %configuracoes de cada jogo
    J.timer = timer; %contador de tempo
    J.total=timer; %tempo total do jogo
    J.goalsA = sparse(timer,1); %matriz de gols do time A feitos no tempo especifico
    J.goalsB = sparse(timer,1); %matriz de gols do time B feitos no tempo especifico
    J.placarA = 0; %quantidade do gols do time A
    J.placarB = 0; %quantidade do gols do time B

end
