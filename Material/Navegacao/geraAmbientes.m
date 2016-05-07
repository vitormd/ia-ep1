goals = [17 20 23 26 29 62 74 107 110 113 119];

options = configRMDP([1 1 1 1 0 0 1 1 1 1 0 0 1 1 1]);

nomeArquivo = 'mapa1.txt';

MDP = MontaAbsorveAbstrato(nomeArquivo,goals,options);

save ambiente1.mat MDP



goals = [32 35 38 41 44 47 50 53 56 59 122 149 212 215 218 221 224 227 230 233 239 302 392 395 401 404 407 410 413 416 419 482 503 506 509];

options = configRMDP([1 1 1 1 0 0 1 1 1 1 0 0 1 1 1]);

nomeArquivo = 'mapa2.txt';

MDP = MontaAbsorveAbstrato(nomeArquivo,goals,options);

save ambiente2.mat MDP



goals = [8];

options = configRMDP([1 1 1 1 0 0 1 1 1 1 0 0 1 1 1]);

nomeArquivo = 'mapaTeste.txt';

MDP = MontaAbsorveAbstrato(nomeArquivo,goals,options);

save ambienteTeste.mat MDP