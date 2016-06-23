function [Q, V, politica, E] = sarsa(T, R, S, A, gama, taxa_aprendizado, maxIter, taxa_eploracao, lambda)

  N=maxIter;      
  Q = zeros(S,A);
  E = zeros(S,A);
  estado = randi([1,S]);

  for n=1:N
    s=randi([1,S]);

    if (mod(n,S*2)==0);
      s = randi([1,S]);
    end;

    % Melhor açao, se dentro de x%
    % Caso contrario, aleatorio
    probabilidade = rand(1);
    if (probabilidade < taxa_eploracao)
      [nil, a] = max(Q(s,:));
    else
      a = randi([1,A]);
    end;

    % % Decide o proximo s_novo observando as recompensas associadas as acoes (s, s', a)
    s_novo = find(cumsum(T{a}(s,:)) > rand, 1, 'first');
    [nil, a_novo] = max(R(s_novo,:));
    % % Recompensa atual
    r = R(s,a); 

    % Atualiza Q(s,a) 
    delta = r + gama*(Q(s_novo, a_novo)) - Q(s,a);
    for si=1:S;
      for ai=1:A;
        if(si == s && ai == a);
          E(si, ai) = (gama*lambda*E(si, ai)) + 1;
        else;
          E(si, ai) = (gama*lambda*E(si, ai));
        end;
      end;
    end;
    Q(s,a) = Q(s,a) + taxa_aprendizado * E(s, a) * delta;

    s = s_novo; % Atualiza o estado atual
  end;
  [V, politica] = max(Q,[],2);
end;
