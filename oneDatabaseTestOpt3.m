function res = oneDatabaseTestOpt3(X, Y)
% Test one database with constant parameters
    % Define constants
    k = 11; % Number of neighbours
    Ps = [0.01, 0.1, 0.5, 1, 2, 4, 10, 0]; % Degree of L_p norm. 0 means infinity
    % Calculate main statistics
    datas = myKNN(X, Y, k, Ps, true);
    % Evaluate significance of differences
    n = size(X, 1);
    pos = sum(Y);
    nY = size(Y, 2);
    for kY = nY:-1:1
        res(kY).data = datas(:, :, kY);
        res(kY).TNNSCp = pValues(res(kY).data(:, 1) / (n * k), n * k);
        res(kY).Accp = pValues(res(kY).data(:, 2), n);
        res(kY).Sep = pValues(res(kY).data(:, 3), pos(kY));
        res(kY).Spp = pValues(res(kY).data(:, 4), n - pos(kY));
        % Calculate "population" variance
        vP = pos(kY) * (n - pos(kY)) / (n ^ 3);
        % Calculate threholds of significance
        res(kY).thresh = cdf('Normal', -sqrt([n * k, n] / (8 * vP)) * 0.01, 0, 1);
    end
end

function res = pValues(vals, n)
% Evaluate significance of differences of two proportins in vector val each
% of which was estimated in sample with n elements.
    dP = abs(bsxfun(@minus, vals, vals'));
    hP = bsxfun(@plus, vals, vals');
    res = cdf('Normal', -dP ./ sqrt((hP .* ( 2 - hP )) / (2 * n)), 0, 1);
end

function [res] = myKNN(data, Y, K, Ps, LOOCV)
%myKNN perform kNN algorithm for database data with number of neighbours K,
%metrics L_p. Data poinr labels are presented in vector Y. Each label
%is 0 or 1. Label 1 is considered as "positive" event.
%LOOCV is boolean variable with true for LOOCV and false for Test of
%trqining set.
%
%Outputs:
%   res(1) is sum of number of neighbors with the same labels as tested
%       case
%   res(2) is accuracy
%   res(3) is sensitivity
%   res(4) is specificity

    % Get sizes
    nP = length(Ps);
    nY = size(Y, 2);
    % Create output array
    res = zeros(nP, 4, nY);
    
    % Get sizes
    n = size(data, 1);
    pos = sum(Y);

    % Array for data collection
    poss = zeros(n, nP, nY);
    
    % Start testing
    parfor m = 1:n
        % Calculate distances
        dats = abs(bsxfun(@minus, data, data(m, :)));
        % Loop for different measures
        for kP = 1:nP
            p = Ps(kP);
            % Calculate distances
            if p > 0
                dat = sum(dats .^ p, 2);
            else
                dat = max(dats, [], 2);
            end
            % Sort distances
            [~, ind] = sort(dat);
            if LOOCV
                % For LOOCV
                ind = ind(2:K + 1);
            else
                % For training set test
                ind = ind(1:K);
            end
            % Calculate number of positive events
            poss(m, kP, :) = sum(Y(ind, :));
        end
    end
    
    % Transform data to required statistics
            
    %Loop for diffrent problems (columns of Y)
    for kY = 1:nY
        % Get number of positive neighbours
        pe = poss(:, :, kY);
        % Get list of positive candidates
        ind = Y(:, kY) == 1;
        % Number of neighbours of correct class for negative case has to be
        % inverted
        pe(~ind, :) = K - pe(~ind, :);
        % Define number of neighbours with correct class
        % save sum in the correct place
        res(:, 1, kY) = sum(pe)';
        % Calculate the accuracy
        res(:, 2, kY) = sum(pe * 2 > K)';
        % Calculate true positive and true negative
        res(:, 3, kY) = sum(pe(ind, :) * 2 > K)';
        res(:, 4, kY) = sum(pe(~ind, :) * 2 > K)';
    end
    % Normalise statistics
    res(:, 2, :) = res(:, 2, :) / n;
    pos = reshape(pos, 1, 1, []);
    for kP = 1:nP
        res(kP, 3, :) = res(kP, 3, :) ./ pos;
        res(kP, 4, :) = res(kP, 4, :) ./ (n - pos);
    end
end