function groups = findImageClusters(adjacency)
%Finds groups of connected vertices in adjacency matrix
%Returns a cell array of vectors
a = adjacency;
groups = {};
while(1)
    [i, j] = find(a==1);
    if length(i) == 0,
        break
    end
    C = [];
    f = i(end);
    
    while(length(f) ~= 0),
        x = f(1);
        f = f(2:end);
        C = [C x];
        
        adj = [find(a(x,:)==1) find(a(:,x)==1)'];
        adj = unique(adj);
        for q = 1:numel(C),
            adj = adj(adj~=C(q));
        end
        f = [f adj];
        f = unique(f);
    end
    groups = [groups C];
    for q = 1:numel(C),
        a(C(q),:) = 0;
        a(:,C(q)) = 0;
    end
end