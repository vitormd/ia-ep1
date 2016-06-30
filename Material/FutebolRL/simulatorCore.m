isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

for p=pInit:n
    agenteA = CriaAgenteA(M);
    agenteB = CriaAgenteB(M);

    J = configJogo(total);
    
    S=state(M);
    
    %Posicao inicial dos jogadores
    S.espalhamentoGoal(M,rand>0);
    tempopartida = 0;
    notFirst = false;
    
    aNew = zeros(1,M.Ta+M.Tb);
    sNewA= [];
    sNewB= [];
    reward =0;

    %Loop principal
    
    horizon = M.horizon;
    
    while J.timer>0
        tempopartida = tempopartida+1;

        % De tempos em tempos escolhe uma posicao aleatoria para iniciar
        if horizon == 0
            S.espalhamentoRand(M);
            notFirst = false;
            horizon = M.horizon;
            if (exibe)
                showGame(S, M, J);
            end
        end
        
        horizon = horizon-1;
        
        % escolhe acao para cada jogador
        aOld = aNew;
        sOldA = sNewA;
        sOldB = sNewB;
        
        sNewA = S.fatora();
        sNewB = S.fatoraB();

        aNew(1:M.Ta) = EscolheAcaoA(M.Ta,agenteA,sOldA,aOld(1:M.Ta),reward,sNewA,notFirst,horizon);
        aNew(M.Ta+1:end) = EscolheAcaoB(M.Tb,agenteB,sOldB,aOld(M.Ta+1:end),reward,sNewB,notFirst,horizon);

        notFirst = true;

        reward = S.move(aNew);
        recompensa(p,tempopartida) = reward;
        
        if abs(reward)
            S.espalhamentoGoal(M,reward<0);
        end
        
        J.placarA=J.placarA+max(reward,0);
        J.placarB=J.placarB+max(-reward,0);
        J.timer=J.timer-1;
        
        if (exibe)
            showGame(S, M, J);
        end   
        
        if mod(J.timer,nIterShow) == 0
            [p J.timer/J.total]
            full([sum(J.placarA) sum(J.placarB)])'
            
            if plotPartial
                if p > 1
                    plot(nIterShow*[1:(total-J.timer)/nIterShow],mean(reshape(recompensa(p,1:(total-J.timer)),nIterShow,(total-J.timer)/nIterShow),1),...
                        nIterShow*[1:(total-0)/nIterShow],mean(reshape(recompensa(1:(p-1),1:(total-0)),(p-1)*nIterShow,(total-0)/nIterShow),1));
                else
                    plot(nIterShow*[1:(total-J.timer)/nIterShow],mean(reshape(recompensa(p,1:(total-J.timer)),nIterShow,(total-J.timer)/nIterShow),1));
                end
                drawnow
            end
            
            if isOctave
                fflush(stdout);
            end
        end       
    end
    
    if salvaAgente
        agentes{p} = agenteA;
        save(tempArq,'agentes','M');
        movefile(tempArq,nmarqAgente);
    end
    
    save(tempArq,'recompensa','p');
    movefile(tempArq,nmarqGoals);
    J.timer = total;
    
end
