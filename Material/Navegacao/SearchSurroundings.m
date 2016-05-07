function [surr] = SearchSurroundings(map, line, column, direction, P)
        
    l2 = line;
    c2 = column;
    if (direction == 'N')
        l2 = line-1;
    elseif (direction == 'S')
        l2 = line+1;
    elseif (direction == 'E') 
        c2 = column+1;
    elseif (direction == 'W')
        c2 = column-1;
    end
    
    if (l2 == 0 || c2 == 0 || (l2 > size(map,1)) || (c2 > size(map,2)))
        surr = 0;    
    else
        mapcell = map(l2,c2);

        if (mapcell == 'd') % This mapcell is close to a door. What can we see through it?
            if (direction == 'N')
                through = map(l2-1,c2);
            elseif (direction == 'S')
                through = map(l2+1,c2);
            elseif (direction == 'E') 
                through = map(l2,c2+1);
            else
                through = map(l2,c2-1);
            end

            if (through == 'r')
                surr = P.Sr;
            else 
                surr = P.Sc;                    
            end
        elseif (mapcell == 'r' || mapcell == 'c' || mapcell == '.')             
            if (l2-1 == 0 || c2-1 == 0 || (l2+1 > size(map,1)) || (c2+1 > size(map,2)))
                surr = 0;    
            elseif (map(l2-1,c2) == 'd' || map(l2+1,c2) == 'd' || map(l2,c2-1) == 'd' || map(l2,c2+1) == 'd') % Searches for far door
                surr = P.Df; % Found one
            else
                surr = P.E;  % Empty mapcell
            end
        else 
            surr = P.W; % It is just a wall
        end
    end
end
