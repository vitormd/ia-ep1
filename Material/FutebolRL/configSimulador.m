function M = configSimulador(Nx, Ny, Ta, Tb )

    % configuracoes da dinamica do jogo
    M.sucesso = 0.9; %probabilidade de sucesso ao carregar a bola
    M.jogadoravancaProb= 0.95; %probabilidade do jogador avancar  (sem a bola)
    M.acertaChute= 0.9; %probabilidade do jogador acertar o chute
    M.recuperaBola= 0.5; %probabilidade de tackle (tomar a bola de outro jogador ou nao)
    M.desvio=0.5; %probabilidade da bola fazer curva
    
    %velocidade maxima da bola quando um jogador acerta o chute
    M.velocidadeBola= max(1,floor((-1+sqrt(1+Nx*8*1/3))/2)); % a velocidade decai em 1 a cada iteracao
    M.posChute = ((M.velocidadeBola*(M.velocidadeBola+1))/2); %aqui � calculado quanto que o chute vai percorrer
    M.goalWidth = floor(Ny/6);
    
    
    % configuracoes de exibicao
    M.cellWidth = 3;
    M.delay = 0.05;

    % configuracoes do tamanho do jogo
    M.Nx = Nx;
    M.Ny = Ny;
    M.Ta = Ta;
    M.Tb = Tb;
    
    M.horizon = 3*(Nx+Ny);

end

