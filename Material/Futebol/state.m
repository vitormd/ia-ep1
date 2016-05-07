classdef state < handle
   
        properties 
        B;
        P;
        nP;
        B_direct;
        B_speed;
        limites;
        M
        end
methods   
    
function obj = state(M)
    obj.M = M;
    obj.nP = M.Ta+M.Tb;
    obj.P = cell(1,obj.nP);
    
    obj.limites = [M.Nx M.Ny 9 (M.velocidadeBola+1)];
    for i=1:obj.nP
        obj.limites = [obj.limites M.Nx];
        obj.limites = [obj.limites M.Ny];
    end
    
    obj.espalhamentoRand(M);
end

function factorState = fatora(G)
    factorState = [G.B.x G.B.y G.B_direct+1 G.B_speed+1];
    for i=1:G.nP
        factorState = [factorState G.P{i}.x];
        factorState = [factorState G.P{i}.y];
    end
end


function factorState = fatoraB(G)
    order = [0 1 2 4 3 7 8 5 6];
    factorState = [G.M.Nx-G.B.x+1 G.B.y order(G.B_direct+1)+1 G.B_speed+1];
%    factorState = [G.B.x G.B.y G.B_direct+1 G.B_speed+1];
    for i=G.nP:-1:1
        factorState = [factorState G.M.Nx-G.P{i}.x+1];
        factorState = [factorState G.P{i}.y];
    end
end


function setFatorado(G,factorState)
    G.B.x = factorState(1);
    G.B.y = factorState(2);
    G.B_direct = factorState(3)-1;
    G.B_speed = factorState(4)-1;
    k = 4;
    for i=1:G.nP
        k=k+1;
        G.P{i}.x = factorState(k);
        k=k+1;
        G.P{i}.y = factorState(k);
    end
end


function setFatoradoB(G,factorState)
    order = [0 1 2 4 3 7 8 5 6];
    G.B.x = factorState(1);
    G.B.y = factorState(2);
    G.B_direct = order(factorState(3));
    G.B_speed = factorState(4)-1;
    k = 4;
    for i=G.nP:-1:1
        k=k+1;
        G.P{i}.x = factorState(k);
        k=k+1;
        G.P{i}.y = factorState(k);
    end
end


function espalhamentoGoal(S,M,left)
    
    posicao = randperm(M.Ny*floor(M.Nx/2));

    %posicao inicial time A
    for i=1:M.Ta
        S.P{i}.y = mod(posicao(i)-1,M.Ny)+1;
        S.P{i}.x = floor((posicao(i)-1)/M.Ny)+1;
    end

    %posicao inicial time B
    for i=1:M.Tb
        S.P{i+M.Ta}.y = mod(posicao(i)-1,M.Ny)+1;
        S.P{i+M.Ta}.x = M.Nx - floor((posicao(i)-1)/M.Ny);
    end

    %Posicao inicial da bola
    S.B.x=round(M.Nx/2);
    S.B.y=round(M.Ny/2);
    S.B_speed=0;
    S.B_direct=0;
    
    if left
        if (M.Ta>0)
            S.P{1}.x=S.B.x;
            S.P{1}.y=S.B.y;
        end
    else
        if (M.Tb>0)
            S.P{M.Ta+1}.x=S.B.x;
            S.P{M.Ta+1}.y=S.B.y;
        end
    end
    
    if M.Tb == 1 && left
        S.P{M.Ta+1}.x=round(M.Nx*3/4+1);
        S.P{M.Ta+1}.y=round(M.Ny/2);
    end

    if M.Ta == 1 && ~left
        S.P{1}.x=round(M.Nx*1/4-1);
        S.P{1}.y=round(M.Ny/2);
    end

end


function espalhamentoRand(S,M)
    
    posicao = randperm(M.Ny*M.Nx);

    %posicao inicial time A e time B
    for i=1:M.Ta+M.Tb
        S.P{i}.y = mod(posicao(i)-1,M.Ny)+1;
        S.P{i}.x = floor((posicao(i)-1)/M.Ny)+1;
    end
    
    

    %Posicao inicial da bola
    i=randi(M.Ny*M.Nx);
    S.B.y=mod(i-1,M.Ny)+1;
    S.B.x=floor((i-1)/M.Ny)+1;
    S.B_speed=0;
    S.B_direct=0;

end


function reward = move(S,aNew)

        reward = 0;

        
        for i=randperm(S.M.Ta+S.M.Tb)
            S.moveAgent(i,aNew(i));
        end
        
        S.moveBall();
        
        %%% Verifica se houve GOL
        if  S.B.y>=(ceil(S.M.Ny/2)-S.M.goalWidth) && S.B.y<=(ceil(S.M.Ny/2)+S.M.goalWidth) && S.B.x==S.M.Nx
            reward = 1;
        elseif S.B.y>=(ceil(S.M.Ny/2)-S.M.goalWidth) && S.B.y<=(ceil(S.M.Ny/2)+S.M.goalWidth) && S.B.x==1
            reward = -1;
        end

end


function moveAgent(S,i,a)

    xBall=S.B.x;
    yBall=S.B.y;
    xNext=S.P{i}.x;
    yNext=S.P{i}.y;      
    %ficar parado
    if a==0
        xNext=S.P{i}.x;
        yNext=S.P{i}.y;
    %norte
    elseif a==1    
        if rand < S.M.jogadoravancaProb
            xNext = S.P{i}.x;
            yNext = max(S.P{i}.y-1,1);
        else
            xNext=S.P{i}.x;
            yNext = S.P{i}.y;
        end
    %sul
    elseif a==2
        if rand < S.M.jogadoravancaProb
            xNext=S.P{i}.x;
            yNext = min(S.P{i}.y+1,S.M.Ny);
        else
            xNext=S.P{i}.x;
            yNext = S.P{i}.y;
        end

    %leste
    elseif a==3
        if rand < S.M.jogadoravancaProb
            xNext = min(S.P{i}.x+1,S.M.Nx);
            yNext = S.P{i}.y;
        else
            xNext=S.P{i}.x;
            yNext = S.P{i}.y;
        end
    %oeste
    elseif a==4  
        if rand < S.M.jogadoravancaProb
            xNext = max(S.P{i}.x-1,1);
            yNext = S.P{i}.y;
        else
            xNext=S.P{i}.x;
            yNext = S.P{i}.y;
        end
        
    elseif a>=5 && a<=12
        if(S.P{i}.x==S.B.x && S.P{i}.y==S.B.y)
            S.B_direct = a-4;
            S.B_speed=S.M.velocidadeBola;
        end
    elseif a==13           
        if(S.P{i}.x~=S.B.x || S.P{i}.y~=S.B.y)
            if(sum(abs([S.P{i}.x - S.B.x,  S.P{i}.y - S.B.y]))<=1)
                if rand < S.M.recuperaBola %a probabilidade de um jogador recuperar a bola estando perto dela eh a mesma estando no mesmo lugar da bola
                    xBall=S.P{i}.x;  %No minimo deveria levar em conta probabilidade de tackle
                    yBall=S.P{i}.y;
                    S.B_direct = 0;
                    S.B_speed=0;
                end
            end
        end
    end


    for j=1:S.M.Ta+S.M.Tb
        if i==j 
            continue;
        end

        if (xNext == S.P{j}.x && yNext == S.P{j}.y)  %impede que jogadores ocupem a mesma posicao tem que olhar todas as demais coordenadas
            xNext = S.P{i}.x;
            yNext = S.P{i}.y;
            break;
        end
    end
    if S.P{i}.x==S.B.x && S.P{i}.y==S.B.y %bola e jogador estao no mesmo lugar, jogador carrega a bola com probabilidade de sucesso e perda pra outro jogador
        if rand<=S.M.sucesso
            xBall = xNext;
            yBall = yNext;
        end        
    end
    S.P{i}.x=xNext;
    S.P{i}.y=yNext;
    S.B.x=xBall;
    S.B.y=yBall;    
end

function moveBall(S)

    if S.B_speed > 0


        if rand > S.M.acertaChute
            S.B_speed=max(S.B_speed-1,0);
        end
            
        if S.B_direct==1                     %N
            S.B.y=max(1,S.B.y-S.B_speed);     
        elseif S.B_direct==2                 %S
            S.B.y=min(S.M.Ny,S.B.y+S.B_speed);
        elseif S.B_direct==3                 %L
            S.B.x=min(S.B.x+S.B_speed,S.M.Nx);
        elseif S.B_direct==4                 %O
            S.B.x=max(S.B.x-S.B_speed,1);
        elseif S.B_direct==5                 %NE
            if rand(1)<=S.M.desvio
                S.B.x=min(S.B.x+S.B_speed,S.M.Nx);
            end
            if rand(1)<=S.M.desvio
                S.B.y=max(S.B.y-S.B_speed,1);           
            end
        elseif S.B_direct==6              %SE
            if rand(1)<=S.M.desvio
                S.B.x=min(S.B.x+S.B_speed,S.M.Nx);
            end
            if rand(1)<=S.M.desvio
                S.B.y=min(S.B.y+S.B_speed,S.M.Ny);           
            end
        elseif S.B_direct==7              %NO
            if rand(1)<=S.M.desvio
                S.B.x=max(S.B.x-S.B_speed,1);
            end
            if rand(1)<=S.M.desvio
                S.B.y=max(S.B.y-S.B_speed,1);
            end
        elseif S.B_direct==8              %SO
            if rand(1)<=S.M.desvio
                S.B.x=max(S.B.x-S.B_speed,1);
            end
            if rand(1)<=S.M.desvio
                S.B.y=min(S.B.y+S.B_speed,S.M.Ny);  
            end
        end

        
        S.B_speed=max(S.B_speed-1,0); %decaimento da velocidade da bola
        if(S.B_speed==0)
            S.B_direct=0;
        end

        if rand < S.M.recuperaBola
            for l=1:S.M.Ta+S.M.Tb
                if(S.B.x==S.P{l}.x && S.B.y == S.P{l}.y)
                    S.B_speed=0;
                    S.B_direct=0;   
                end        
            end
        end    
        
    end


end

end
end