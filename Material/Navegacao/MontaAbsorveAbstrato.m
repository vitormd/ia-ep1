%MontaAbsorveAbstratoNovo

function MDP = MontaAbsorveAbstrato(nomeArquivo,goals,options)

% Carrega o mapa contido em 'nomeArquivo'
P = options.P;
[environment,locations] = CarregaMapa(nomeArquivo,P);

[linhas colunas]  = size(environment);

nAction = size(options.actions,1);  % Quantidade de acoes
nState  = size(locations,1);   % Quantidade de estados sem considerar as diferentes metas
nPredicado = size(options.predicates,1); % Quantidade de predicados
nAbstract = 2^nPredicado; % Quantidade de estados abstratos possiveis de montar com predicados

tamanho = length(goals)*nState;
sigma = sparse(nAbstract,tamanho);

for a=1:nAction
    totalT{a} = sparse(tamanho,tamanho);
end

map = zeros(tamanho-1, nAction+1);
posMap = 1; %indica o estado já considerando varias metas
indice = 0; %indica qual meta esta sendo analisada

for goal=goals 
% Cria matriz de transicoes para cada acao.
T = cell(nAction,1);
for a=1:nAction
    T{a} = sparse(nState,nState);
end


estadosRoom = zeros(1,nState);
for s=1:nState
    i = locations(s,1);  
    j = locations(s,2); 
    actual = environment{i,j};  
    if actual.In == P.R
        estadosRoom(s) = 1;
    end
end
estadosRoom = estadosRoom/sum(estadosRoom);


% Monta matriz de transicoes para meta corrente.
for a=1:nAction
    
    for s=1:nState 
        i = locations(s,1);  
        j = locations(s,2); 
        actual = environment{i,j};  
        distance = abs(i-locations(goal,1)) + abs(j-locations(goal,2)); 
        count = 0;
                        
        %South         
        if actual.S == options.actions(a,1) || (actual.S > 0 && options.actions(a,1) == P.Ra) || (actual.S > 0 && options.actions(a,1) == P.A) || ((actual.S == P.Sr || actual.S == P.Sc || actual.S == P.Df) && options.actions(a,1) == P.Sa)
%        if actual.S == options.actions(a,1) || (options.actions(a,1) == P.Ra) || (actual.S > 0 && options.actions(a,1) == P.A) || ((actual.S == P.Sr || actual.S == P.Sc || actual.S == P.Df) && options.actions(a,1) == P.Sa)
            if (i+1<=linhas)
                next = environment{i+1,j};
                if (distance > abs(i+1-locations(goal,1)) + abs(j-locations(goal,2)) && options.actions(a,2) == 1) || ...
                        (distance < abs(i+1-locations(goal,1)) + abs(j-locations(goal,2)) && options.actions(a,2) == 0)
                    T{a}(s,:) = T{a}(s,:)*count/(count+1); 
                    T{a}(s,next.L) = 1/(count+1); 
                    count = count+1;
                elseif (options.actions(a,1) == P.Ra && next.L > 0)
                    T{a}(s,next.L) = 0.25;
                    count = count+1;
                end
            end
        end
		
        %North        
        if actual.N == options.actions(a,1) || (actual.N > 0 && options.actions(a,1) == P.Ra) || (actual.N > 0 && options.actions(a,1) == P.A) || ((actual.N == P.Sr || actual.N == P.Sc || actual.N == P.Df) && options.actions(a,1) == P.Sa)
            if (i-1>0)
                next = environment{i-1,j};
                if (distance > abs(i-1-locations(goal,1)) + abs(j-locations(goal,2)) && options.actions(a,2) == 1) || ...
                        (distance < abs(i-1-locations(goal,1)) + abs(j-locations(goal,2)) && options.actions(a,2) == 0)
                    T{a}(s,:) = T{a}(s,:)*count/(count+1);
                    T{a}(s,next.L) = 1/(count+1);
                    count = count+1;
                elseif (options.actions(a,1) == P.Ra && next.L > 0)
                    T{a}(s,next.L) = 0.25;
                    count = count+1;
                end
            end
        end

        %East        
        if actual.E == options.actions(a,1) || (actual.E > 0 && options.actions(a,1) == P.Ra) || (actual.E > 0 && options.actions(a,1) == P.A) || ((actual.E == P.Sr || actual.E == P.Sc || actual.E == P.Df) && options.actions(a,1) == P.Sa)
            if (j+1<=colunas)
                next = environment{i,j+1};
                if (distance > abs(i-locations(goal,1)) + abs(j+1-locations(goal,2)) && options.actions(a,2) == 1) || ...
                        (distance < abs(i-locations(goal,1)) + abs(j+1-locations(goal,2)) && options.actions(a,2) == 0)
                    T{a}(s,:) = T{a}(s,:)*count/(count+1);
                    T{a}(s,next.L) = 1/(count+1);
                    count = count+1;
                elseif (options.actions(a,1) == P.Ra && next.L > 0)
                    T{a}(s,next.L) = 0.25;
                    count = count+1;
                end
            end
        end

        %West        
        if actual.W == options.actions(a,1) || (actual.W > 0 && options.actions(a,1) == P.Ra) || (actual.W > 0 && options.actions(a,1) == P.A) || ((actual.W == P.Sr || actual.W == P.Sc || actual.W == P.Df) && options.actions(a,1) == P.Sa)
            if (j-1>0)
                next = environment{i,j-1};
                if (distance > abs(i-locations(goal,1)) + abs(j-1-locations(goal,2)) && options.actions(a,2) == 1) || ...
                        (distance < abs(i-locations(goal,1)) + abs(j-1-locations(goal,2)) && options.actions(a,2) == 0 )
                    T{a}(s,:) = T{a}(s,:)*count/(count+1);
                    T{a}(s,next.L) = 1/(count+1);
                elseif (options.actions(a,1) == P.Ra && next.L > 0)
                    T{a}(s,next.L) = 0.25;
                end
            end
        end
        
        if options.actions(a,1) == P.Te
            if actual.In == P.R
                T{a}(s,:) = estadosRoom;
            end
        end
        
        T{a}(s,:) = T{a}(s,:)*(1-options.config.erroMove);
        T{a}(s,s) = 0; 
        T{a}(s,s) = 1 - sum(T{a}(s,:));
    end   
end

% Se o agente esta na meta, entao nao tem transicao para nenhum estado
for a=1:nAction
    T{a}(goal,:) = 0;
end

% Monta sigma
for s=1:nState 
    auxSum = zeros(1,nPredicado);
    i = locations(s,1);  %pega posicao linha do estado concreto a ser verificado
    j = locations(s,2);  %pega posicao coluna do estado concreto a ser verificado
    actual = environment{i,j}; %pega o estado concreto atual 
    distance = abs(i-locations(goal,1)) + abs(j-locations(goal,2)); % calcula distancia do estado atual ate a meta
    
    if actual.In == P.R 
        auxSum(13) = 1; 
    end
    
    if distance <= options.config.DTG  
        auxSum(14) = 1; 
        auxSum(15) = 1;
    elseif distance <= options.config.DTGMedia
        auxSum(15) = 1;
    end
        
    %South	
    if (i+1<=linhas)
        if distance < abs(i+1-locations(goal,1)) + abs(j-locations(goal,2)) 
            if actual.S == P.E 
                auxSum(1) = 1;
            elseif actual.S == P.Df
                auxSum(2) = 1;
            elseif actual.S == P.Sr
                auxSum(3) = 1;
            elseif actual.S == P.Sc
                auxSum(4) = 1;
            end
        else
            if actual.S == P.E 
                auxSum(7) = 1;
            elseif actual.S == P.Df
                auxSum(8) = 1;
            elseif actual.S == P.Sr
                auxSum(9) = 1;
            elseif actual.S == P.Sc
                auxSum(10) = 1;
            end
        end
    end

    %North
    if (i-1>0)
        if distance < abs(i-1-locations(goal,1)) + abs(j-locations(goal,2))
            if actual.N == P.E 
                auxSum(1) = 1;
            elseif actual.N == P.Df
                auxSum(2) = 1;
            elseif actual.N == P.Sr
                auxSum(3) = 1;
            elseif actual.N == P.Sc
                auxSum(4) = 1;
            end
        else
            if actual.N == P.E 
                auxSum(7) = 1;
            elseif actual.N == P.Df
                auxSum(8) = 1;
            elseif actual.N == P.Sr
                auxSum(9) = 1;
            elseif actual.N == P.Sc
                auxSum(10) = 1;
            end
        end
    end

    %East
    if (j+1<=colunas)
        if distance < abs(i-locations(goal,1)) + abs(j+1-locations(goal,2))
            if actual.E == P.E 
                auxSum(1) = 1;
            elseif actual.E == P.Df
                auxSum(2) = 1;
            elseif actual.E == P.Sr
                auxSum(3) = 1;
            elseif actual.E == P.Sc
                auxSum(4) = 1;
            end
        else
            if actual.E == P.E 
                auxSum(7) = 1;
            elseif actual.E == P.Df
                auxSum(8) = 1;
            elseif actual.E == P.Sr
                auxSum(9) = 1;
            elseif actual.E == P.Sc
                auxSum(10) = 1;
            end
        end
    end

    %West
    if (j-1>0)
        if distance < abs(i-locations(goal,1)) + abs(j-1-locations(goal,2))
            if actual.W == P.E 
                auxSum(1) = 1;
            elseif actual.W == P.Df
                auxSum(2) = 1;
            elseif actual.W == P.Sr
                auxSum(3) = 1;
            elseif actual.W == P.Sc
                auxSum(4) = 1;
            end
        else
            if actual.W == P.E 
                auxSum(7) = 1;
            elseif actual.W == P.Df
                auxSum(8) = 1;
            elseif actual.W == P.Sr
                auxSum(9) = 1;
            elseif actual.W == P.Sc
                auxSum(10) = 1;
            end
        end
    end
        
    %P.Sa  
    if (sum(auxSum(1,2:4)) > 0)   %Oposite to Goal
        auxSum(5) = 1;
    end    
    if (sum(auxSum(1,8:10)) > 0)  %Head to Goal
        auxSum(11) = 1;
    end
    
    %P.A 
    if (sum(auxSum(1,1:4)) > 0)   %Oposite to Goal
        auxSum(6) = 1;
    end    
    if (sum(auxSum(1,7:10)) > 0)  %Head to Goal
        auxSum(12) = 1;
    end
    
    posicao = (options.predicates(:,3)'*auxSum')+1;
    sigma(posicao,posMap) = 1; 
    map(posMap,1) = posicao;
    
    posMap = posMap + 1;   
end



% Combina a matriz de transicao de todas metas
inicio = (indice*nState)+1;
fim = (indice*nState)+nState;

for k=1:nAction  
    totalT{k}(inicio:fim,inicio:fim) = T{k}(:,:);
end
indice = indice +1;
end



%constroi as acoes disponiveis em cada estado abstrato
sigmaAction = zeros(nAbstract,nAction);

actAlways = ~any(options.actions(:,3:end),2)';
sigmaAction(:,actAlways) = 1;

for i=1:nAbstract %aux
        actionsSel = find(bitget(i-1,[1:15])*options.actions(:,3:end)');
        sigmaAction(i,actionsSel) = 1;
end


[i j] = size(totalT{1}(:,:));

% % chega na meta e para
% count = 0;
% R = -ones(i,nAction);
% for goal=goals
%     for a=1:nAction
%         totalT{a}(goal + count,:) = 0;
%     end
%     count = count + nState;
% end


% chega na meta e fica na meta
count = 0;
R = zeros(i,nAction);
for goal=goals
    for a=1:nAction
        totalT{a}(goal + count,:) = 0;
        totalT{a}(goal + count,goal + count) = 1;
    end
    R(goal + count,:) = 1;    
    count = count + nState;
end




nState = i;
bInit = ones(nState,1)/(nState); 
T = totalT;


%constroi observacao multivariavel
multiSigma = zeros(nState,sum(options.predSel));
for i=find(sum(sigma'))
    s = find(sigma(i,:));
    predObser = bitget(i-1,find(options.predSel));
    multiSigma(s,:) = ones(length(s),1)*predObser;
end


% nAbstract = nState;
% sigma = eye(nState);

MDP.S = nState;
MDP.A = nAction;
MDP.O = nAbstract;
MDP.T = T;
MDP.R = R;
MDP.sigma = sigma;
MDP.bInit = bInit;
MDP.sigmaAction = sigmaAction;
MDP.multiSigma = multiSigma;
MDP.multiO = sum(options.predSel);

MDP2.S = MDP.S;
MDP2.A = MDP.A;
MDP2.T = MDP.T;
MDP2.R = MDP.R;
MDP2.bInit = MDP.bInit;

MDP = MDP2;


