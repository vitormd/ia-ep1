cores = ['b- '; 'g- '; 'r- '; 'c- '; 'k- '; 'b--'; 'g--'; 'r--'; 'c--'; 'k--'; 'b-.'; 'g-.'; 'r-.'; 'c-.'; 'k-.'];
index = 0;

% Precisao no grafico, quanto menor o valor maior a precisao
nY = 5000;

legenda = cell(0,0);

figure
hold on

load Data/goalsUmVsUm_QLearning5x3.mat
index=index+1; legenda{index} = ['(' int2str(sum(recompensa(:)>0)/p) '-' int2str(sum(recompensa(:)<0)/p) '=' int2str(sum(recompensa(:))/p) ') - Q-Learning 5x3'];
nX = length(recompensa)/nY;plot(nY:nY:nY*nX,mean(reshape(recompensa(1:p,:),p*nY,nX)),cores(mod(index-1,length(cores))+1,:),'linewidth',2);

load Data/goalsUmVsUm_Sarsa5x3.mat
index=index+1; legenda{index} = ['(' int2str(sum(recompensa(:)>0)/p) '-' int2str(sum(recompensa(:)<0)/p) '=' int2str(sum(recompensa(:))/p) ') - Sarsa 5x3'];
nX = length(recompensa)/nY;plot(nY:nY:nY*nX,mean(reshape(recompensa(1:p,:),p*nY,nX)),cores(mod(index-1,length(cores))+1,:),'linewidth',2);

legend(legenda)