function [ indices ] = binify_monolithic( arr, size, edge_size )
% Split arr into overlapping bins. The data are split into
% (length(arr)/size) bins, each of which consists of (size+edge_size)
% samples.
%
% Output format is:
%                        1, size   + edge_size ;
%   size   - edge_size + 1, size*2 + edge_size ; 
% size * 2 - edge_size + 1, size*3 + edge_size ; ...

% [size * (c-1), size*c + edge_size]
il = floor(length(arr)/size);
indices = int64(zeros(il, 2));
indices(1,:) = [1, size + edge_size];
for i=2:(length(indices)-1)
    indices(i, 1) = size * (i-1) - edge_size + 1;
    indices(i, 2) = size * (i) + edge_size;
    assert(indices(i,1) <= length(arr), 'First index %d is too high.', i);
    assert(indices(i,2) <= length(arr), 'Second index %d is too high.', i);
end

% Add the final (misshapen) bin if necessary
if il*size ~= length(arr)
    indices(end,:) = [indices(end-1,1)+1, length(arr)];
end

end