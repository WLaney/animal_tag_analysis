function [ means, stds, rmss ] = extract_bin_features( arr, inds )
% Get mean, std. dev, energy, and RMS for each input bin.
% These are used later for machine learning.

means = zeros(length(inds), 1);
stds = means;
rmss = means;

bins = cell(length(inds),1);
for i=1:length(inds)
    bins{i} = single(arr(inds(i,1):inds(i,2)));
end

parfor i=1:length(bins)
   bin = bins{i};
   means(i) = sum(mean(bin)); 
   stds(i)  = sum(std(bin)); 
   rmss(i)  = sum(rms(bin)); 
end

end