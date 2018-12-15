function rankDataFriedman(M, mods, cv, dbs, fName, sheetPref)
%Friedman test and post-hoc the two-tailed Nemenyi test
%Inputs
%   M contains data for ranking. Each row contains data for one database.
%   mods contains names for algorithms
%   cv contains critical values for specified alpha
%   dbs contains names of databases
%   fName contains name of Excel file
%   sheetPref contains prefix for spreadsheets to write. Each subset of
%   metrics hac to be written to separate sheet.
%
    % Suppress warning for adding of sheets
    warning( 'off', 'MATLAB:xlswrite:AddSheet' ) ;
    % Main loop for selection of the 
    while true
        % Transform results to ranks
        A = tiedrank(M')';
        % Get sizes
        [N, m] = size(A);
        % Form data for spread sheet
        Ex = cell(2 * (N +  m + 11), max(m, 5) + 1);
        K = 1;
        Ex(K, 1) = {'Database'};
        Ex(K, 2:m + 1) = mods;
        K = K + 1;
        Ex(K:K + N - 1, 1) = dbs;
        Ex(K:K + N - 1, 2:m + 1) = num2cell(M);
        K = K + N + 2;
        Ex(K, 1) = {'Rank matrix (1 means the worst)'};
        K = K + 1;
        Ex(K, 1) = {'Database'};
        Ex(K, 2:m + 1) = mods;
        K = K + 1;
        Ex(K:K + N - 1, 1) = dbs;
        Ex(K:K + N - 1, 2:m + 1) = num2cell(A);
        K = K + N + 1;
        % Calculate mean ranks for all classifiers
        mRanks = mean(A);
        Ex(K, 1) = {'Mean ranks'};
        Ex(K, 2:m + 1) = num2cell(mRanks);
        K = K + 1;
        Ex(K, 1) = {'# Databases (N)'};
        Ex(K, 2) = num2cell(N);
        Ex(K, 3) = {'# Models'};
        Ex(K, 4) = num2cell(m);
        % Calculate chi^2 statistics
        % for non-tied
        % chiSq = 12 * N / (m * (m + 1)) * (sum(mRanks .^2)...
        %     - ((m + 1) ^ 2) * m / 4);
        % Tied version
        chiSq = 4 * N ^ 2 * (m - 1) * (sum(mRanks .^ 2)...
            - ((m + 1) ^ 2) * m / 4)/...
            (4 * sum(A(:) .^ 2) - N * m * (m + 1)^2);
        
        pVal = 1 - cdf('Chisquare', chiSq, m - 1);
        K = K + 1;
        Ex(K, 1) = {'Chi^2_F'};
        Ex(K, 2) = num2cell(chiSq);
        Ex(K, 3) = {'Degree of freedom'};
        Ex(K, 4) = num2cell(m - 1);
        Ex(K, 5) = {'p-value'};
        Ex(K, 6) = num2cell(pVal);
        % F distribution version
        fVal = (N - 1) * chiSq / (N * (m - 1) - chiSq);
        pVal = 1 - cdf('F', fVal, m - 1, (N - 1) * (m - 1));
        K = K + 1;
        Ex(K, 1) = {'F_F'};
        Ex(K, 2) = num2cell(fVal);
        Ex(K, 3) = {'Degrees of freedom'};
        Ex(K, 4) = {sprintf('%d/%d', m - 1, (N - 1) * (m - 1))};
        Ex(K, 5) = {'p-value'};
        Ex(K, 6) = num2cell(pVal);
        
        % Post hoc Nemenyi test
        CD = cv(m) * sqrt(m * (m + 1) / (6 * N));
        K = K + 2;
        Ex(K, 1) = {'Critical distance'};
        Ex(K, 2) = num2cell(CD);
        
        % Matrix of distances
        D = abs(bsxfun(@minus, mRanks, mRanks'));
        K = K + 2;
        Ex(K, 1) = {'Matrix of distances'};
        K = K + 1;
        Ex(K, 1) = {'Model'};
        Ex(K, 2:m + 1) = mods;
        Ex(K + 1:K + m, 1) = mods;
        Ex(K + 1:K + m, 2:m + 1) = num2cell(D);
        K = K + m + 3;
        Ex(K, 1) = {'Matrix of significant distances (1 means significant)'};
        K = K + 1;
        Ex(K, 1) = {'Model'};
        Ex(K, 2:m + 1) = mods;
        Ex(K + 1:K + m, 1) = mods;
        Ex(K + 1:K + m, 2:m + 1) = num2cell((D > CD) + 0);

        % Check the necessity to continue
        % First of all let us check number of significant differences for
        % each model
        d = sum(D > CD);
        % Let us check do the worst model has significant difference with
        % at least one another model
        [~, ind] = min(mRanks);
        md = d(ind);
        K = K + m + 3;
        if md > 0
            Ex(K, 1) = {'Model'};
            Ex(K, 2) = mods(ind);
            Ex(K, 3) = {'is the worst and has significant difference with'};
            Ex(K, 4) = num2cell(md);
            Ex(K, 5) = {'models.'};
        else
            Ex(K, 1) = {'There is no model with significant difference with any other model'};
        end
        % Write data to file
        xlswrite(fName, Ex, [sheetPref, num2str(m)]);

        % Check the stop condition
        if m < 5 || md == 0
            break;
        end
        
        % Remove selected candidate
        M(:, ind) = [];
        mods(ind) = [];
    end
    % Reactivate warning for adding of sheets
    warning( 'on', 'MATLAB:xlswrite:AddSheet' ) ;
end