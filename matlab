function [number_of_islands, nodeIsland] = node_islanding( nnode, nbranch, fnode, tnode, branch_status );

%Program created by Sara Mullen
%Adapted for use on Project 4 by Anthony Giacomoni

%%inputs needed 
%nnode
%nbranch
%branch_status vector
%fnode vector
%tnode vector




%----------------------INITIALIZATION-------------------------

systemSplit = 0;    % Initialize to 0 - no islands in system.

% Initialize zero arrays.

NnodeColumn  = zeros(nnode,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% ISLAND CHECKING - SKM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%Experience the power of SKM%%%%%%%%%%%%%%%%%%%%%%%

islandID    = 0;            % Initialize to zero.
nodeIsland   = NnodeColumn;   % Vector with island number for each node.
beginFIFO   = 1;            % Pointer to first element in first-in first-out(FIFO) Queue.
endFIFO     = 1;            % Pointer to last element in FIFO.
nodeInFIFO   = NnodeColumn';  % Identifies whether a node is in the FIFO.
branch        = 1;            % Holds next branch to be checked.
branchDone    = ~branch_status;  % Identifies whether a branch has been checked yet.

% Identify multi-node islands.
while ((sum(branchDone) < nbranch) && (branch <= nbranch))
    % Find first 'IN' branch to begin identifying an island.
    flag = 0;
    while((flag == 0) && (branch <= nbranch))
        if ((branch_status(branch) >= 1) && (branchDone(branch) == 0))
            islandID = islandID + 1;    % Increment ID# for next island.
            flag = 1;   % First in branch has been found, proceed with sweep.
            nodeIsland(fnode(branch)) = islandID;
            nodeIsland(tnode(branch)) = islandID;
            % Add to and from node to FIFO Queue if not there already.
            if (nodeInFIFO(fnode(branch)) == 0)
                nodeFIFO(endFIFO) = fnode(branch);
                endFIFO = endFIFO + 1;
                nodeInFIFO(fnode(branch)) = 1;
            end
            if (nodeInFIFO(tnode(branch)) == 0)
                nodeFIFO(endFIFO) = tnode(branch);
                endFIFO = endFIFO + 1;
                nodeInFIFO(tnode(branch)) = 1;
            end
            branchDone(branch) = 1;         % Mark branch as checked.
        end
        branch = branch + 1;                % Increment branch pointer.
    end %Find beginning of new island.
    
    % Island sweep - identify all nodes in the island.
    while (beginFIFO ~= endFIFO)
        % Grab first node in FIFO Queue.
        node = nodeFIFO(beginFIFO);
        % Find the nodees still connected to it that haven't been checked, add to FIFO.
        branchTemp = find((fnode == node) & (branch_status >= 1) & (branchDone == 0));
        for i = 1:length(branchTemp)
            if(nodeInFIFO(tnode(branchTemp(i))) == 0)
                nodeFIFO(endFIFO) = tnode(branchTemp(i));
                endFIFO = endFIFO + 1;
                nodeInFIFO(tnode(branchTemp(i))) = 1;
            end
            nodeIsland(tnode(branchTemp(i))) = nodeIsland(node);
        end
        branchDone(branchTemp) = 1;         % Mark branchs as checked.
        
        branchTemp2 = find((tnode == node) & (branch_status == 1) & (branchDone == 0));
        for i = 1:length(branchTemp2)
            if(nodeInFIFO(fnode(branchTemp2(i))) == 0)
                nodeFIFO(endFIFO) = fnode(branchTemp2(i));
                endFIFO = endFIFO + 1;
                nodeInFIFO(fnode(branchTemp2(i))) = 1;
            end
            nodeIsland(fnode(branchTemp2(i))) = nodeIsland(node);
        end
        branchDone(branchTemp2) = 1;        % Mark branch as checked.
        beginFIFO = beginFIFO + 1;
    end %Island Sweep
    
end %Multi-node island identification.

%Assign island IDs to single bus islands.
noIsland = find(nodeIsland == 0);
nodeIsland(noIsland) = (islandID+1):(islandID+length(noIsland));
islandID = islandID + length(noIsland);
number_of_islands = max(nodeIsland);
end
