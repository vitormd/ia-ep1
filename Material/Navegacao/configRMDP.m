function options = configRMDP(predSel)
%Inicializa Variaveis

config.erroMove   = 0.1;  %indica a probabilidade de uma ação dar errado e o agente ficar no mesmo lugar
config.erroObserve = 0;  %indica a probabilidade da observação de um objeto ocorrer com sucesso

% Valores utilizados para indicar predicados com relação a distância a meta
config.DTG = 5;      %distancia perto da meta
config.DTGMedia = 8; %distancia media


% Predicados --------------------------
% Estabelece um valor arbitrário para cada predicado

% Predicados Relativos à Meta, esses predicados admitem duas versões: head to goal e opposite to goal
P.W  = 0;  %wall - este deve ficar sempre como 0, enquanto os outros devem ser maior que zero
P.E  = 1;  %empty space
P.Dc = 2;  %close door - este predicado não foi mais considerado (na verdade trocou-se ele por see corridor e see room)
P.Df = 3;  %far door
P.Sc = 4;  %see corridor
P.Sr = 5;  %see room
P.Sa = 6;  %see ambience(room/corridor) - usado apenas nos artigos da Karina (são redundantes)
P.A  = 7;  %see anything - usado apenas nos artigos da Karina (são redundantes)

% Predicados Absolutos, esses predicados admitem versão única
P.R  = 8;  %room
P.C  = 9;  %corridor
P.Ra = 10; %aleatorio - não utilizado exatamente como um predicado, mas é utilizado para permitir ação aleatória
P.In  = 11;
P.DTG = 12;
P.DTGMedia = 13;
P.Te = 14;


%Abstract States ----------------------
%Opposite to Goal
%Empty 1
%Far Door 2
%See Room 4
%See Corridor 8
%See Ambience 16
%Anything 32

%Head to Goal
%Empty 64
%Far Door 128
%See Room 256
%See Corridor 512
%See Ambience 1024
%Anything 2048
%In Room 4096
%Near to Goal 8192
%Distancia Media 16384

%Abstract Actions ---------------------
actions = [%Opposite to Goal
              P.E  0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  %Empty
              P.Df 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0;  %Far Door
              P.Sr 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0;  %See Room
              P.Sc 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;  %See Corridor
%               P.Sa 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0;  %See Ambience
%               P.A  0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0;  %See Anything
 
              %Head to Goal
              P.E  1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0;   %Empty
              P.Df 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0;   %Far Door
              P.Sr 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0;   %See Room
              P.Sc 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0;  %See Corridor
%               P.Sa 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0;  %See Ambience
%               P.A  1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0;  %See Anything
%               P.Ra  -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  %Random
%               P.Te -1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0;
          ];
          
      
actions(:,3:end) = 0; %isso autoriza toda acao ser executada sempre
      
actSel = find(actions(:,3:end)*predSel' | ~any(actions(:,3:end),2));
actions = actions(actSel,:);




% Aqui nada pode ser mudado, principalmente a ordem
% para desconsiderar um predicado, basta multiplicar por zero a terceira
% coluna

predicates = [
			  %Opposite
			  P.E  0 1;  %Empty
              P.Df 0 2;  %Door far
              P.Sr 0 4;  %See room
              P.Sc 0 8;  %See corridor
              P.Sa 0 16;  %See ambience(Df,Sr,Sc)
              P.A  0 32;  %Anything(E,Df,Sr,Sc) 
              %Head
			  P.E  1 64;  
              P.Df 1 128; 
              P.Sr 1 256;  
              P.Sc 1 512;  
              P.Sa 1 1024;  
              P.A  1 2048;
              P.In -1 4096; %In room
              P.DTG -1 8192; %Near to goal
              P.DTGMedia -1 16384]; %Median distance to goal
          
predicates(:,3) = predicates(:,3).*predSel';

         % 
% nAbstract = 32768; %15 predicados


                                                                %DTG DTGMedia
predicadosEmTexto   = ['Em';'Df'; 'Sc'; 'Sr'; 'Sa'; 'An';'In'; 'DG';  'DM'];                 
predicadosVariaveis = [P.E; P.Df; P.Sc; P.Sr; P.Sa; P.A; P.In; P.DTG; P.DTGMedia];

% 2.^[0:14] eleva o número 2 de 0 a 14: 
% 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384
options.predSel = predSel;
options.P = P;
options.config = config;
options.actions = actions;
options.predicates = predicates;
options.print.predicadosEmTexto = predicadosEmTexto;
options.print.predicadosVariaveis = predicadosVariaveis;


