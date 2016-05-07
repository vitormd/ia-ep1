function [V, politica] = policy_iteration(T, R, S, A)

V = zeros(S, 1);
gama = 0.9
% Bellman
for a=1:A
  Q(:, a) = R(:, a) + gama * T{a} * V;
end;
[nil, politica] = max(Q, [], 2);iter = 0;
% Bellman

terminou = false;
while ~terminou
  iter = iter + 1;

  % itera política
  for a=1:A
    ind = find(politica == a);
    if ~isempty(ind)
      T_politica(ind,:) = T{a}(ind,:);
      R_politica(ind,1) = R(ind,a);
    end
  end
  if issparse(R_politica)
    R_politica = sparse(R_politica);
  end;
  V = (speye(S,S) - gama*T_politica) \ R_politica;
  % itera plítica

  % Bellman
  for a=1:A
    Q(:, a) = R(:, a) + gama * T{a} * V;
  end;
  [nil, politica_seguitne] = max(Q, [], 2);
  % Bellman

  if politica == politica_seguitne;
    terminou = true;
  end;

  politica = politica_seguitne;
end;

disp(['Iterações: ' num2str(iter)]);