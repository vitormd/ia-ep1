function [politica] = q_learning(T, R, S, A, gama, taxa_aprendizado, taxa_exploracao, numAcoes)

  N=numAcoes;      
  Q = zeros(S,A);
  estado = randi([1,S]);
  soma_acoes = [];
  s=randi([1,S]);

  for n=1:N;
    s = mod(n, S);
    if(s==0);
      s=S;
    end;

    a = acaoEGreedy(s, taxa_exploracao, Q, A);

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

function a_novo = acaoEGreedy(s, taxa_exploracao, Q, A)
  probabilidade = rand(1);
  if (probabilidade < taxa_exploracao)
    [nil, a_novo] = max(Q(s,:));
  else
    a_novo = randi([1,A]);
  end;
end;