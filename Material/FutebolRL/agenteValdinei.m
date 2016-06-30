classdef agenteValdinei < handle
    properties
        epsilon
        M
        coord
        coord_x
        coord_y
        melhor_jg
        melhores
        mudou
        temp
    end
    methods
        function G = agenteValdinei(epsilon,M)
            G.epsilon = epsilon;
            G.M = M;
        end
        
        
        function a = action(G,S,jog)
            if S.P{1}.x == S.B.x & S.P{1}.y == S.B.y
                if S.P{1}.y < (ceil(G.M.Ny/2)-G.M.goalWidth)
                    a = 2;
                elseif S.P{1}.y > (ceil(G.M.Ny/2)+G.M.goalWidth)
                    a = 1;
                else
                    a = 7;
                end
            else
                if S.P{1}.x > S.B.x
                    a = 4;
                elseif S.P{1}.x < S.B.x
                    a = 3;
                elseif S.P{1}.y > S.B.y
                    a = 1;
                elseif S.P{1}.y < S.B.y
                    a = 2;
                end
            end
        end
    end
end