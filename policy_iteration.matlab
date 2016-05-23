function [politica] = policy_iteration(T, R, S, A)

V = zeros(S, 1);
gama = 0.9
% Bellman - para começar com uma politica arbitrária (mesma que ones(S, 1)) e uma função valor arbitrária
for a=1:A
  Q(:, a) = R(:, a) + gama * T{a} * V;
end;
[V, politica] = max(Q, [], 2);iter = 0;
% Bellman

terminou = false;
while ~terminou
  iter = iter + 1;

  % Bellman
  for a=1:A
    Q(:, a) = R(:, a) + gama * T{a} * V;
  end;
  [V, politica_seguinte] = max(Q, [], 2);
  % Bellman

  if politica == politica_seguinte;
    terminou = true;
  end;

  politica = politica_seguinte;
end;

disp(['Iterações: ' num2str(iter)]);