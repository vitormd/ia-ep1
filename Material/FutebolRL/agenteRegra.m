classdef agenteRegra < handle
    properties
        epsilon
        M
        coord
        coord_x
        coord_y
        melhor_jg
        melhores
        mudou
        temp
    end
    methods
        function G = agenteRegra(epsilon,M)
            G.epsilon = epsilon;
            G.M = M;
            G.melhor_jg = 0;
            G.melhores = 0;
            for i=1:M.Tb
                G.coord_x(i) = 0;
                G.coord_y(i) = 0;
            end
            G.coord = cell(4,6);
            G.coord{1} = [ceil(G.M.Nx*(1/4)),ceil(G.M.Ny/2)];
            G.coord{2} = [ceil(G.M.Nx*(3/4)),ceil(G.M.Ny/2);ceil(G.M.Nx*(1/4)),ceil(G.M.Ny/2)];
            G.coord{3} = [ceil(G.M.Nx*(1/4)),ceil(G.M.Ny*(3/4));ceil(G.M.Nx/4),ceil(G.M.Ny*(1/4));ceil(G.M.Nx*(3/4)),ceil(G.M.Ny/2)];
            G.coord{4} = [ceil(G.M.Nx*(3/4)),ceil(G.M.Ny*(3/4));ceil(G.M.Nx/4),ceil(G.M.Ny*(3/4));ceil(G.M.Nx*(1/4)),ceil(G.M.Ny*(1/4));ceil(G.M.Nx*(3/4)),ceil(G.M.Ny*(1/4))];
            G.mudou = 0;
            G.temp = 0;
        end
        
        function G = melhor_caminho(G,S)
            min_dist = 99999;
            G.mudou = 0;
            for i=G.M.Ta+1:G.M.Ta+G.M.Tb
                dist = abs(S.P{i}.x - S.B.x) + abs(S.P{i}.y - S.B.y);
                if(dist<min_dist)
                    min_dist = dist;
                    G.melhor_jg = i;
                end
            end
            if(G.melhor_jg ~= G.melhores)
                G.melhores = G.melhor_jg;
                G.mudou = 1;
            end
        end
        
        function a = action(G,S,jog)
            if rand > G.epsilon
                G = melhor_caminho(G,S);
                if(G.M.Tb > 1)
                    if(G.mudou == 1)
                        for j=G.M.Ta+1:G.M.Ta+G.M.Tb
                            if(j ~= G.melhor_jg)
                                celula = G.coord{G.M.Tb-1};
                                G.temp = j - G.M.Ta;
                                if (j>G.melhor_jg)
                                    G.temp = j - 1 - G.M.Ta;
                                end
                                G.coord_x(j) = celula(G.temp,1);
                                G.coord_y(j) = celula(G.temp,2);
                            end
                        end
                    end
                end
                if (jog == G.melhor_jg)
                    if(S.P{jog}.x == S.B.x && S.P{jog}.y == S.B.y) %Se o jogador estiver com a bola
                        if(S.B.x<G.M.Nx-G.M.posChute)
                            a = 3; %Ande para direita(frente)
                        else if(S.B.y<ceil(G.M.Ny/2)-G.M.goalWidth) %Se o jogador estiver acima do gol
                                a = 2; %Ande para baixo
                            else if(S.B.y>ceil(G.M.Ny/2)+G.M.goalWidth) %Se o jogador estiver abaixo do gol
                                    a = 1; %Ande para cima
                                else
                                    a = 3;
                                end
                            end
                        end
                        for i=1:G.M.Ta+G.M.Tb %tomada de decisao (planejamento)
                            if(i ~= jog);
                                if((S.P{jog}.x == S.P{i}.x - 1) && (S.P{jog}.y == S.P{i}.y))
                                    if(S.B.y>ceil(G.M.Ny/2)-ceil(G.M.goalWidth/2))
                                        a = 1; %Ande para cima
                                    else
                                        a = 2;
                                    end
                                end
                                if((S.P{jog}.x == S.P{i}.x + 1) && (S.P{jog}.y == S.P{i}.y))
                                    if(S.B.y>ceil(G.M.Ny/2)-ceil(G.M.goalWidth/2))
                                        a = 1; %Ande para cima
                                    else
                                        a = 2;
                                    end
                                end
                            end
                        end
                        if(S.B.x>=G.M.Nx-G.M.posChute) %Se o jogador estiver perto do gol
                            if((ismember(S.B.y, (ceil(G.M.Ny/2)-G.M.goalWidth):(ceil(G.M.Ny/2)+G.M.goalWidth)))) %Se o jogador estiver de frente pro gol
                                a = 7; %Chuta para direita(frente)
                            else if(S.B.y<ceil(G.M.Ny/2)-ceil(G.M.goalWidth/2)) %Se o jogador estiver acima do gol e na mesma coluna do gol
                                    if(G.M.Tb > 1)
                                        if(1 == S.P{jog}.x)
                                            a = 6;  %Chuta para baixo
                                        else if(S.B.x>=G.M.Nx-G.M.posChute)
                                                a = 10; %Chuta para o sudeste
                                            else
                                                a = 3;
                                            end
                                        end
                                    else
                                        if(G.M.Nx == S.P{jog}.x)
                                            a = 6;  %Chuta para baixo
                                        else
                                            a = 10; %Chuta para o sudeste
                                        end
                                    end
                                else if(S.B.y>ceil(G.M.Ny/2)-ceil(G.M.goalWidth/2)) %Se o jogador estiver abaixo do gol e na mesma coluna do gol
                                        if(G.M.Tb > 1)
                                            if((1 == S.P{jog}.x))
                                                a = 5; %Chuta para cima
                                            else if(S.B.x>=G.M.Nx-G.M.posChute)
                                                    a = 9; %Chuta para o nordeste
                                                else
                                                    a = 3;
                                                end
                                            end
                                        else
                                            if(G.M.Nx == S.P{jog}.x)
                                                a = 5; %Chuta para cima
                                            else
                                                a = 9; %Chuta para o nordeste
                                            end
                                        end
                                    else
                                        a = 3;
                                    end
                                end
                            end
                        end
                    else
                        if(S.P{jog}.x < S.B.x) %Se a bola estiver a direita do jogador
                            a = 3; %Ande para a direita
                        else if(S.P{jog}.x > S.B.x) %Se a bola estiver a esquerda do jogador
                                a = 4; %Ande para a esquerda
                            else if(S.P{jog}.y < S.B.y) %Se a bola estiver abaixo do jogador
                                    a = 2; %Ande para baixo
                                else if(S.P{jog}.y > S.B.y) %Se a bola estiver acima do jogador
                                        a = 1; %Ande para cima
                                    end
                                end
                            end
                        end
                        for j=1:G.M.Ta+G.M.Tb %tomada de decisao (planejamento)
                            if(j ~= jog);
                                if(((S.P{jog}.x == S.P{j}.x) && (((S.P{jog}.y == S.P{j}.y - 1))))) %Se o oponente estiver acima ou abaixo em relacao ao jogador                                    
                                    if(S.P{jog}.y < S.B.y)
                                        if(S.P{jog}.x < S.B.x) %Se a bola estiver a direita do jogador
                                            a = 3; %Ande para a direita
                                        else
                                            a = 4; %Ande para a esquerda
                                        end
                                    else
                                        a = 1;
                                    end
                                else if(((S.P{jog}.x == S.P{j}.x) && (((S.P{jog}.y == S.P{j}.y + 1))))) %Se o oponente estiver acima ou abaixo em relacao ao jogador
                                        if(S.P{jog}.y > S.B.y)
                                            if(S.P{jog}.x < S.B.x) %Se a bola estiver a direita do jogador
                                                a = 3; %Ande para a direita
                                            else
                                                a = 4; %Ande para a esquerda
                                            end
                                        else
                                            a = 2;
                                        end
                                    else if(((S.P{jog}.x == S.P{j}.x + 1) && (S.P{jog}.y == S.P{j}.y - 1)) || ((((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y - 1)) || ((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y)) || ((S.P{jog}.x == S.P{j}.x + 1) && (S.P{jog}.y == S.P{j}.y)) || (((S.P{jog}.x == S.P{j}.x + 1) && (S.P{jog}.y == S.P{j}.y + 1)) || ((((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y + 1)) || ((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y)))))))) %Se o oponente estiver acima e a direita do jogador ou se o oponente estiver a esquerda ou a direita do jogador ou acima do gol                                            
                                            if(S.P{jog}.y == S.B.y)
                                                if(S.P{jog}.x < S.B.x) %Se a bola estiver a direita do jogador
                                                    a = 3; %Ande para a direita
                                                else
                                                    a = 4; %Ande para a esquerda
                                                end
                                                if(((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y)) || ((S.P{jog}.x == S.P{j}.x + 1) && (S.P{jog}.y == S.P{j}.y)))
                                                    a = 1;
                                                end
                                            else
                                                if(((S.P{jog}.x == S.P{j}.x + 1) && (S.P{jog}.y == S.P{j}.y - 1)) || ((((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y - 1)))))
                                                    if(S.P{jog}.x < S.B.x) %Se a bola estiver a direita do jogador
                                                        a = 3; %Ande para a direita
                                                    else if(S.P{jog}.x == S.B.x)
                                                            if(S.P{jog}.y < S.B.y)
                                                                a = 2;
                                                            else
                                                                a = 1;
                                                            end
                                                        else
                                                            a = 4; %Ande para a esquerda
                                                        end
                                                    end
                                                else
                                                    a = 2;
                                                end
                                            end
                                            
                                            if((S.P{j}.x == S.B.x) && (S.P{j}.y == S.B.y) || (j == G.melhor_jg))
                                                a = 2; %Ande para baixo
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        for ad=1:G.M.Ta+G.M.Tb %tomada de decisao (planejamento)
                            if(ad ~= jog) %Para todos os adversarios
                                if((((((S.P{jog}.x == S.B.x - 1) || (S.P{jog}.x == S.B.x + 1)) && (S.P{ad}.x == S.B.x)) && (S.P{jog}.y == S.B.y)) && (S.P{ad}.y == S.B.y)) ||  (((((S.P{jog}.y == S.B.y - 1) || (S.P{jog}.y == S.B.y + 1)) && (S.P{ad}.y == S.B.y)) && (S.P{jog}.x == S.B.x)) && (S.P{ad}.x == S.B.x))) %Se o jogador estiver ao lado da bola
                                    a = 13; %Roube a bola
                                end
                            end
                        end
                    end
                else
                    if (jog ~= G.melhor_jg)
                        a = 15;
                        for j=G.M.Ta+1:G.M.Ta+G.M.Tb % Aqui e feita uma otimizacao no posicionamento
                            if(j ~= G.melhor_jg)
                                if((S.P{jog}.x == G.coord_x(j) && S.P{jog}.y == G.coord_y(j)))
                                    aux_x = G.coord_x(jog);
                                    aux_y = G.coord_y(jog);
                                    G.coord_x(jog) = G.coord_x(j);
                                    G.coord_y(jog) = G.coord_y(j);
                                    G.coord_x(j) = aux_x;
                                    G.coord_y(j) = aux_y;
                                    j = G.M.Tb;
                                    a = 14;
                                end
                            end
                        end
                        if(a~=0 && a~=14)
                            if(S.P{jog}.x < G.coord_x(jog)) %Se a bola estiver a direita do jogador
                                a = 3; %Ande para a direita
                            else if(S.P{jog}.x > G.coord_x(jog)) %Se a bola estiver a esquerda do jogador
                                    a = 4; %Ande para a esquerda
                                else if(S.P{jog}.y < G.coord_y(jog)) %Se a bola estiver abaixo do jogador
                                        a = 2; %Ande para baixo
                                    else if(S.P{jog}.y > G.coord_y(jog)) %Se a bola estiver acima do jogador
                                            a = 1; %Ande para cima
                                        end
                                    end
                                end
                            end
                        end
                        if(a~=0 && a~=14)
                            for j=1:G.M.Ta+G.M.Tb %tomada de decisao (planejamento)
                                if(j ~= jog && j ~= G.melhor_jg);
                                    if((S.P{jog}.x == S.P{j}.x) && (((S.P{jog}.y == S.P{j}.y - 1)))) %Se o oponente estiver acima ou abaixo em relacao ao jogador
                                        if((S.P{jog}.y < G.coord_y(jog)))
                                            if((S.P{j}.x == S.B.x) && (S.P{j}.y == S.B.y))
                                                a = 3; %Ande para a esquerda
                                            else
                                                if((S.P{jog}.x < G.coord_x(jog)))
                                                    a = 4; %Ande para a esquerda
                                                else
                                                    a = 3; %Ande para a direita
                                                end
                                            end
                                        else
                                            a = 1; %Ande para cima
                                        end
                                    else if((S.P{jog}.x == S.P{j}.x) && ((S.P{jog}.y == S.P{j}.y + 1)))
                                            if((S.P{jog}.x == G.coord_x(jog)))
                                                if((S.P{jog}.y > G.coord_y(jog)))
                                                    if((S.P{j}.x == S.B.x) && (S.P{j}.y == S.B.y))
                                                        a = 3; %Ande para a esquerda
                                                    else if((S.P{j}.x == G.coord_x(j)) && (S.P{j}.y == G.coord_y(j)))
                                                            a = 3;
                                                        else
                                                            a = 14;
                                                        end
                                                    end
                                                else
                                                    if((S.P{j}.x == G.coord_x(j)) && (S.P{j}.y == G.coord_y(j)))
                                                        a = 2;
                                                    else if((S.P{jog}.x < G.coord_x(jog)))
                                                            a = 3; %Ande para a esquerda
                                                        else
                                                            a = 4; %Ande para a direita
                                                        end
                                                    end
                                                end
                                            end
                                        else if(((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y)))
                                                if(S.P{jog}.y <= G.coord_y(jog))
                                                    a = 2; %Ande para baixo
                                                else
                                                    a = 1; %Ande para cima
                                                end
                                            else if(((S.P{jog}.x == S.P{j}.x + 1) && (S.P{jog}.y == S.P{j}.y)))
                                                    if(S.P{jog}.y == G.coord_y(jog))
                                                        a = 3; %Ande para a direita
                                                        if(S.P{jog}.x > S.B.x)
                                                            a = 4; %Ande para cima
                                                        end
                                                    else if(S.P{jog}.y >= G.coord_y(jog))
                                                            a = 1; %Ande para cima
                                                        else
                                                            a = 2; %Ande para baixo
                                                        end
                                                    end
                                                else if(((S.P{jog}.x == S.P{j}.x + 1) && (S.P{jog}.y == S.P{j}.y - 1)) || ((((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y - 1))))) %Se o oponente estiver acima e a direita do jogador ou se o oponente estiver a esquerda ou a direita do jogador ou acima do gol
                                                        if(j > G.M.Ta)
                                                            if((S.P{j}.x == G.coord_x(j)) && (S.P{j}.y == G.coord_y(j)))
                                                                if((S.P{jog}.x < G.coord_x(jog)))
                                                                    if((S.P{j}.x == S.B.x) && (S.P{j}.y == S.B.y))
                                                                        a = 3; %Ande para a direita
                                                                    else
                                                                        if((S.P{jog}.y > G.coord_y(jog)))
                                                                            a = 1;
                                                                        else
                                                                            a = 2;
                                                                        end
                                                                    end
                                                                else
                                                                    if((S.P{j}.x == S.B.x) && (S.P{j}.y == S.B.y))
                                                                        a = 4; %Ande para a direita
                                                                    else
                                                                        if((S.P{jog}.y > G.coord_y(jog)))
                                                                            a = 1;
                                                                        else
                                                                            a = 2;
                                                                        end
                                                                    end
                                                                end
                                                            else
                                                                a = 1; %Ande para cima
                                                            end
                                                        else
                                                            a = 1; %Ande para cima
                                                        end
                                                    else if(((S.P{jog}.x == S.P{j}.x + 1) && (S.P{jog}.y == S.P{j}.y + 1)) || ((((S.P{jog}.x == S.P{j}.x - 1) && (S.P{jog}.y == S.P{j}.y + 1))))) %Se o oponente estiver abaixo e a direita do jogador ou se o oponente estiver a esquerda ou a direita do jogador ou abaixo do gol
                                                            if(j > G.M.Ta)
                                                                if((S.P{j}.x == G.coord_x(j)) && (S.P{j}.y == G.coord_y(j)))
                                                                    if((S.P{jog}.x < G.coord_x(jog)))
                                                                        a = 3; %Ande para a esquerda                                                                        
                                                                    else
                                                                        if((S.P{jog}.y > G.coord_y(jog)))
                                                                            a = 1;
                                                                        else
                                                                            a = 4;
                                                                        end
                                                                    end                                                                    
                                                                else
                                                                    if((S.P{jog}.y > G.coord_y(jog)))
                                                                        a = 1;
                                                                    else
                                                                        a = 2;
                                                                    end
                                                                end
                                                            else
                                                                a = 2; %Ande para baixo
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                a = randi(13); %Fa�a uma a��o aleat�ria
            end
        end
    end
end