function [environment,locations] = CarregaMapa(nomeArquivo,P)

    % P sao as definicoes de constantes para room, corridor, etc.    
    % Characters that must be skipped (represent walls)
    wall = ['-' '|' '.' ' ' '\n' 'd'];

    fid = fopen(nomeArquivo,'r');
    
    mapa = [];
    linhas  = str2num(fgets(fid));
    colunas = str2num(fgets(fid));
    while (~feof(fid))
        mapa = [mapa; fgets(fid)];
    end 
    fclose(fid);
    
    [linhasArq,colunasArq] = size(mapa);
        
    environment = cell(linhas,colunas);
	states = linhas*colunas;
    locations = zeros(states,2);
    i = 1;	
    count = 0;
    for l=1:linhasArq
        j = 1;
        soma_i = false;
        for c=1:(colunasArq-1)
            celula = mapa(l,c);
            if (sum(celula == wall) == 0) % Se celula nao eh parede
                if(celula == 'r')
                    environment{i,j}.In = P.R;
                elseif (celula == 'c')
                    environment{i,j}.In = P.C;
                end
                
                count = count + 1;
                environment{i,j}.N = SearchSurroundings(mapa,l,c,'N',P);
                environment{i,j}.S = SearchSurroundings(mapa,l,c,'S',P);
                environment{i,j}.E = SearchSurroundings(mapa,l,c,'E',P);
                environment{i,j}.W = SearchSurroundings(mapa,l,c,'W',P);                
                environment{i,j}.L = count;
                locations(count,1:2) = [i j]; %[locations; [i j]];
                j = j + 1;
                soma_i = true;
            end
        end
        if (soma_i)
            i = i + 1;
        end        
    end
end    
    
