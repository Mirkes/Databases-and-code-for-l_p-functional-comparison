function [mins, maxs, means, stds] = distributionComparison(data, dims, P)
%distributionComparison calculates all pairwise distances for points from
%data and evaluate min, max, mean and std for this distances distributions.
%Calculations are performed for each dimension from 'dims' and each metrics
%from P separately.
%Inputs
%   data is n-by-m matrix where n is number of data points (observations)
%       and m is maximally possible dimension.
%   dims is vector of dimensions, for example [1, 2, 10, 100]. Maximal
%       dimension must be not greater than m (number of columns in data).
%   P is vector of metrics, for example, [0.01, 0.1, 0.5, 1, 2, 4, 10, 0].
%       Value 0 is interpreted as infinity (l infinity metrics is maximum
%       of absolute value of coordinatewise differences).
%Outputs
%   mins, maxs, means and stds are max, min, mean and std for pairwise
%       distances. Each of this matrix has number of rows equal to number
%       of dimensions under consideration and number of columns is number
%       of metrics under consideration.

    % Define required sizes
    n = size(data, 1);
    nP = length(P);
    nD = length(dims);

    % Create array of distances
    maxs = zeros(nD, nP);
    means = maxs;
    stds = maxs;
    mins = Inf(nD, nP);
    
    % To prevent overloading
    scale = ones(nD, nP);
    % Calculate distances between all points and point k
    for k = 1:n
        k
        % Subtract k-th point from all other points and remove k-th row
        dats = abs(bsxfun(@minus, data, data(k, :)));
        dats(k, :) = [];
        % Loop of metrics
        for kP = 1:nP
            p = P(kP);
            if p > 0
                datd = dats .^ p;
            else
                datd = dats;
            end
            % Loop of dimensions
            for kD = 1:nD
                dim = dims(kD);
                if p > 0
                    dat = sum(datd(:, 1:dim), 2) .^ (1/p);
                else
                    dat = max(datd(:, 1:dim), [], 2);
                end
                mins(kD, kP) = min([dat; mins(kD, kP)]);
                maxs(kD, kP) = max([dat; maxs(kD, kP)]);
                means(kD, kP) = means(kD, kP) + sum(dat);
                if k == 1 && maxs(kD, kP) > 1.e100
                    scale(kD, kP) = 10 ^ round(log10(maxs(kD, kP)));
                end
                stds(kD, kP) = stds(kD, kP) + sum((dat / scale(kD, kP)).^ 2);
            end
        end
    end
    % Normalise mean and std
    N = n * (n - 1);
    means = means / N;
    stds = sqrt(stds / N - (means ./ scale) .^ 2) .* scale;
end