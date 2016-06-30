function UmVsUm_Sarsa5x3
%TREINA UM AGENTE INTELIGENTE CONTRA 1 JOGADOR FIXO INTELIGENTE
%COM RISCO: NEUTRO
nA = 13;
%[PARADO=0,NORTE=1,SUL,LESTE,OESTE,
%CHUTE N,CHUTE S,CHUTE L,CHUTE O,CHUTE NE,CHUTE SE,CHUTE NO,CHUTE SO,
%TACKLE=13] [1,2,3,4,5,6,7,8,9,10,11,12,13]

% Modo de operacao do Simulador
total=1e6;

nIterShow = 1e4;
salvaAgente = true;
%A PARTIR DO QUE APRENDEU CONTRA 1 ALEATORIO
exibe = false;
plotPartial = true;

%A PARTIR DO QUE APRENDEU CONTRA 1 ALEATORIO
% configSimulador(Nx, Ny, Ta, Tb ), Nx e Ny devem ser impar
M = configSimulador(5,3,1,1);


    
nmarqGoals = 'Data/goalsUmVsUm_Sarsa5x3.mat'; %arquivo que salva as diffes dos gols e o timer49.988
nmarqAgente = 'Data/agenteUmVsUm_Sarsa5x3.mat';%arquivo que salva o agente
tempArq = 'Data/temp.mat';

%contador de jogos
n=30;

%variaveis globais
recompensa = sparse(n, total);
agentes = cell(1,n);

%Verifica se ja existe os arquivos salvos para continuar execucao
if fileattrib(nmarqGoals)
   load(nmarqGoals);
   if salvaAgente
        load(nmarqAgente);
   end
   pInit = p+1;
else
   pInit = 1;
end

simulatorCore

end

function agente = CriaAgenteA(M)
    nA = 13;
    epsilon = 0.1;
    gamma = 0.99;
    alpha = 0.1;
    agente = Sarsa(nA,epsilon,gamma,alpha,M); 
end

function agente = CriaAgenteB(M)
    agente = agenteRegra(0.05,M);
end

function action = EscolheAcaoA(nPlayer,agente,sOld,aOld,reward,sNew,notFirst,tempopartida)
    action = agente.action(sNew);

    if notFirst
        agente.update(sOld,aOld,reward,sNew,action);
    end
end

function action = EscolheAcaoB(nPlayer,agente,sOld,aOld,reward,sNew,notFirst,tempopartida)
    aOrder = [1,2,4,3,5,6,8,7,11,12,9,10,13,0];
    S=state(agente.M);
    S.setFatoradoB(sNew);
    action = zeros(1,nPlayer);
    for i=1:nPlayer
        action(i) = aOrder(agente.action(S,i+agente.M.Ta));
    end
end



