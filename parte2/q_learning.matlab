function [Q, V, politica] = q_learning(T, R, S, A, gama, taxa_aprendizado, maxIter, taxa_eploracao)

  N=maxIter;      
  Q = zeros(S,A);
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
    % % Recompensa atual
    r = R(s,a); 

    % Atualiza Q(s,a) 
    Q(s,a) = Q(s,a) + ((taxa_aprendizado) * (r + gama*max(Q(s_novo,:)) - Q(s,a)));

    s = s_novo; % Atualiza o estado atual
  end;
  [V, politica] = max(Q,[],2);
end;
