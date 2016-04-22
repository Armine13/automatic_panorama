function list = pairsFromAdjacency(group, mat)
adjacency = mat;
list = [];
for k = 1: numel(group),
    a = group(k);
    while(1),
        bs = find(adjacency(a,:) == 1);
        if numel(bs) == 0,
            break
        end
        b = bs(1);
        list = [list; a b];
        adjacency(a, b) = 0;
    end
end