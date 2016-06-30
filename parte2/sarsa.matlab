function [Q, V, politica, E] = sarsa(T, R, S, A, gama, taxa_aprendizado, maxIter, taxa_exploracao, lambda)

  N=maxIter;      
  Q = zeros(S,A);
  E = zeros(S,A);
  estado = randi([1,S]);

  for n=1:N
    s=randi([1,S]);

    if (mod(n,S*2)==0);
      s = randi([1,S]);
    end;

    a = acaoEGreedy(s, taxa_exploracao, Q, A);

    s_novo = find(cumsum(T{a}(s,:)) > rand, 1, 'first');
    a_novo = acaoEGreedy(s_novo, taxa_exploracao, Q, A);

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

function a_novo = acaoEGreedy(s, taxa_exploracao, Q, A)
  probabilidade = rand(1);
  if (probabilidade < taxa_exploracao)
    [nil, a_novo] = max(Q(s,:));
  else
    a_novo = randi([1,A]);
  end;
end;