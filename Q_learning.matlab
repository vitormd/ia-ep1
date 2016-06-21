function [Q, V, policy] = mdp_Q_learning(T, R, S, A, gama, learning, maxIter, eGreedyProb, recompensa_estado_final)

    N=maxIter;      
    Q = zeros(S,A);
    s = randi([1,S]);

    for n=1:N
        if (mod(n,S*2)==0); s = randi([1,S]); end;

        % Soft-greedy.
        % Melhor acao, se dentro de x%
        % Caso contrario, aleatorio
        random_value = rand(1);
        if (random_value < eGreedyProb)
          [nil, a] = max(Q(s,:));
        else
          a = randi([1,A]);
        end;
 
        % Decide o proximo s_meta observando as recompensas associadas as acoes (s, s', a)
        t_s_meta = rand(1);
        t = 0; 
        s_meta = 0;
        while ((t < t_s_meta) && (s_meta < S)) 
            s_meta = s_meta+1;
            t = t + T{a}(s,s_meta);
        end; 
        % Recompensa atual
        r = R(s,a); 

        % Atualiza Q(s,a) 
        Q(s,a) = Q(s,a) + ((learning) * (r + gama*max(Q(s_meta,:)) - Q(s,a)));

        s = s_meta; % Atualiza o estado atual
    end;

    %compute the value function and the policy
    [V, policy] = max(Q,[],2);        

end;
