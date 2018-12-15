function [diff1, relContr1, diff2, relContr2] = distanceCalculate(data, dims, P)
%distanceCalculate calculates minimal amd maximal distances between all
%possible pairs in data. Dimension of data is defined by in dims vector.
%Distances are calculated for all values of metrics, specified in P.
%Outputs
%   minD1, maxD1 are maximal and minimal distances from data points to
%       origin.
%   minD2, maxD2 are maximal and minimal distances from data points to
%       specified data point (query point). This value are averaged by all
%       data points.

    n = size(data, 1);
    nP = length(P);
    % Calculate distances from each point to origin
    nD = length(dims);
    % Create array of distances
    diff1 = zeros(nP, nD);
    relContr1 = zeros(nP, nD);
    diff2 = zeros(nP, nD);
    relContr2 = zeros(nP, nD);
    % Calculate the first measure ([1])
    for kP = 1:nP
        p = P(kP);
        % Calculate matrix of corresponding degrees
        if p == 0
            dats = abs(data);
        else
            dats = data .^ p;
        end
        for kD = 1:nD
            dim = dims(kD);
            if p == 0
                datd = max(dats(:, 1:dim), [], 2);
            else
                datd = sum(dats(:, 1:dim), 2) .^ (1 / p);
            end
            ma = max(datd);
            mi = min(datd);

            diff1(kP, kD) = ma - mi;
            relContr1(kP, kD) = (ma - mi) / mi;
        end
    end
    
    % Calculate the second measure ([2])
    
    for k = 1:n
        k
        dats = abs(bsxfun(@minus, data, data(k, :)));
        dats(k, :) = [];
        for kP = 1:nP
            p = P(kP);
            if p > 0
                datd = dats .^ p;
            else
                datd = dats;
            end
            for kD = 1:nD
                dim = dims(kD);
                if p > 0
                    dat = sum(datd(:, 1:dim), 2);
                    ma = max(dat) .^ (1/p);
                    mi = min(dat) .^ (1/p);
                else
                    dat = max(datd(:, 1:dim), [], 2);
                    ma = max(dat);
                    mi = min(dat);
                end
                diff2(kP, kD) = diff2(kP, kD) + ma - mi;
                relContr2(kP, kD) = relContr2(kP, kD) + (ma - mi) / mi;
            end
        end
    end
    diff2 = diff2 / n;
    relContr2 = relContr2 / n;
end