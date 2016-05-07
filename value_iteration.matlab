function [politica] = value_iteration(T, R, S, A)

V = zeros(S, 1);
gama = 0.9
epsilon = 0.01
delta = epsilon * (1-gama)/gama % Limite da variação
iter = 0;

terminou = false;
while ~terminou
	iter = iter + 1;
	Vanterior = V;

	% Bellman
	for a=1:A
		Q(:, a) = R(:, a) + gama * T{a} * Vanterior;
	end;
	[V, politica] = max(Q, [], 2);
	% Bellman

	variacao = max(V - Vanterior) - min(V - Vanterior);

	if variacao < delta;
		terminou = true;
	end;
end;
disp(['Iterações: ' num2str(iter)]);