function avaliaProblema

% Tamanho da Simulacao
n=100;              % quantidade de jogos
total=1e4;          % tempo de cada jogo
nIterShow = 1e3;    % tempo para exibir informacao na tela
exibe = true;       % mostra a simulacao graficamente


% Carrega o problema que se deseja testar
load problema1.mat


nmarqGoals = 'Data/problema1.mat'; %arquivo para salvar as recompensas recebidas
tempArq = 'Data/temp.mat';


%variaveis globais
recompensa = sparse(n, total);



%Verifica se ja existe os arquivos salvos para continuar execucao
if fileattrib(nmarqGoals)
   load(nmarqGoals);
   pInit = p+1;
else
    pInit = 1;
end

simulatorCore

end


function agente = CriaAgenteA(M)
% Usa-se esse metodo para inicializar o seu agente, assim como retornar uma
% estrutura/classe/matriz dele
% A entrada e' uma estrutura M que da informacoes sobre o jogo
    agente = randomAgent(13);
end

function agente = CriaAgenteB(M)
    agente = agenteRegra(0.05,M);
end

function action = EscolheAcaoA(nPlayer,agente,sOld,aOld,reward,sNew,notFirst,horizon)
% Usa-se esse metodo para escolher a acao que seu agente vai executar.
% nPlayer: quantidade de jogadores no seu time
% agente: o mesmo retorno do metodo criado por CriaAgenteA
% sOld,sNew: representacao fatorada do estado anterior e atual
% aOld: acao executada no estado sOld
% reward: recompensa obtida ao executar a acao aOld no estado sOld quando
% transita para sNew
% notFirst: true se nao e' a primeira escolha de acao em um episodio
% horizon: horizonte restante no episodio atual
    action = zeros(1,nPlayer);
    for i=1:nPlayer
        action(i) = agente.action();
    end
end

function action = EscolheAcaoB(nPlayer,agente,sOld,aOld,reward,sNew,notFirst,horizon)
    aOrder = [1,2,4,3,5,6,8,7,11,12,9,10,13,0];
    S=state(agente.M);
    S.setFatoradoB(sNew);
    action = zeros(1,nPlayer);
    for i=1:nPlayer
        action(i) = aOrder(agente.action(S,i+agente.M.Ta));
    end
end

