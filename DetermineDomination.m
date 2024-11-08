%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA121
% Project Title: Multi-Objective Particle Swarm Optimization (MOPSO)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function is_dominated=DetermineDomination(pop)

    nPop=size(pop,1);
    
    is_dominated = false(nPop,1);
    
    for i=1:nPop-1
        for j=i+1:nPop
            
            if Dominates(pop(i,:),pop(j,:))
               is_dominated(j)=true;
            end
            
            if Dominates(pop(j,:),pop(i,:))
               is_dominated(i) =true;
            end
            
        end
    end

end