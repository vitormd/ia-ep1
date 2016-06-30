classdef QLearning < handle
    properties
        A
        epsilon
        gamma
        alpha
        Q
        limites
        M
    end
    methods      
        function G = QLearning(A,epsilon,gamma,alpha,M)
            s = state(M);
            G.A = A;
            G.epsilon = epsilon;
            G.gamma = gamma;
            G.alpha = alpha;
            G.M=M;
            G.limites = s.limites;
            G.Q=zeros(prod(s.limites),A);
        end
        
        function [a Qcmac] = action(G,s)
            estado = G.enumera(s);
            if rand > G.epsilon
                V = max(G.Q(estado,:));
                as = find(G.Q(estado,:)==V);
                a = as(randi(length(as)));
            else
                a = randi(G.A);
            end
        end
                  
        function estado = enumera(G,s)
            prodFactor = [1 cumprod(G.limites(1:end-1),2)];
            estado = sum((s-1).*prodFactor,2) + 1;
        end
        
       function update(G,s,a,r,sNext)
            estadoNext = G.enumera(sNext);
            qNext = max(G.Q(estadoNext,:));
         
            estado = G.enumera(s);
            qOld = G.Q(estado,a);
            
            delta = r+G.gamma*qNext - qOld;
            G.Q(estado,a) = G.Q(estado,a) + G.alpha*delta;
       end        
    end
end