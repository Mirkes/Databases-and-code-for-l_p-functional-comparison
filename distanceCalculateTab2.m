function res = distanceCalculateTab2(dims, nRep, siz)
    % Get maximal dimension
    nCoord = max(dims);
    nD = length(dims);
    res = zeros(nD, 1);
    L1 = zeros(nD, 1);
    L2 = zeros(nD, 1);
    for kR = 1:nRep
        % Generate new set of points
        data = rand(siz, nCoord);
        L1(:) = 0;
        L2(:) = 0;
        % Calculate relative contrast for L1 and L2 norms
        for k = 1:siz
            dats = abs(bsxfun(@minus, data, data(k, :)));
            dats(k, :) = [];
            for kD = 1:nD
                dim = dims(kD);
                % L1 norm calculation
                dat = sum(dats(:, 1:dim), 2);
                ma = max(dat);
                mi = min(dat);
                L1(kD) = L1(kD) + (ma - mi) / mi;
            end
            dats = dats .^ 2;
            for kD = 1:nD
                dim = dims(kD);
                % L2 norm calculation
                dat = sum(dats(:, 1:dim), 2);
                ma = sqrt(max(dat));
                mi = sqrt(min(dat));
                L2(kD) = L2(kD) + (ma - mi) / mi;
            end
        end
        L1 = L1 / siz;
        L2 = L2 / siz;
        res(L1 > L2) = res(L1 > L2) + 1;
    end
end