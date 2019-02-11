%Main test
%what is parameter to control process - use value
% 0 to generate the new dataset and save it
% 1 to load data from file
% 2 to calculate maximal and minimal distances for one dataset
% 3 to calculate table with min, max, mean and std without normalisation.
% 4, 5, 6 to calculate res files for different normalisations. This
%   calculation requires huge time. Code is optimised to use parallel
%   calculation.
% 7 to convert calculated Res files to MS Excel for readability
% 8 to apply Friedman test and Nomenyi post hoc test.
% 9 to apply Wilcoxon signed rank test to compare metrics
% 10 to apply Wilcoxon signed rank test to compare preprocessing
% 11 Reproduction of Table 2
% 12 Creation figures for table 2 explanation
% 13 Draw figure with unit circles

what = 3;

switch what
    case 0
        % Generate or download dataset
        data = datasetGenerator(200, 10000);
        save('data.mat', 'data', '-v7.3');
    case 1
        % Load dataset
        load('data.mat');
    case 2
        % Define set of dimensions
        dim = [1, 2, 3, 4, 5:5:size(data,2)];
        % Define set of metrics
        metr = [3, 2, 1, 2/3, 2/5, 0];
        % Create array for result
        [diff1, relContr1, diff2, relContr2] =...
            distanceCalculate(data, dim, metr);
    case 3
        % Define set of dimensions
        dim = [1, 2, 3, 4, 5:5:size(data,2)];
        % Define set of metrics
        metr = [0.01, 0.1, 0.5, 1, 2, 4, 10, 0];
        [mins, maxs, means, stds] = distributionComparison(data, dim, metr);
        % Form figures for Fig 3.
        % Line specifications
        ls = {'-r', '--g', ':k', '-.b', '-r', '--g', ':k', '-.b'};
        wid = [3, 3, 3, 3, 1.5, 1.5, 1.5, 1.5];
        p = {'0.01', '0.1', '0.5', '1', '2', '4', '10', '\infty'};
        % Form two figures
        for f = 1:2
            figure;
            if f == 1
                dat = (maxs - mins) ./ mins;
                for k = 1:size(dat, 2)
                    loglog(dim, dat(:,k), ls{k}, 'LineWidth', wid(k));
                    hold on;
                end
                title('Relative contrast', 'FontSize', 20);
                fName = 'RelCont1.png';
            else
                dat = stds ./ means;
                for k = 1:size(dat, 2)
                    semilogx(dim, dat(:,k), ls{k}, 'LineWidth', wid(k));
                    hold on;
                end
                title('Coefficient of variation', 'FontSize', 20);
                fName = 'CV1.png';
            end
            axis([min(dim), max(dim), min(dat(:)), max(dat(:))]);
            legend(p, 'FontSize', 16);
            set(gca, 'FontSize', 20);
            xlabel('Dimension', 'FontSize', 20);
            saveFigures(fName);
        end
    case 4 % Calculations are not fast!
        names = {'Banknote', 'blood', 'breastCancer', 'climate', 'colposcopy',...
            'Cryotherapy', 'diabetic', 'EggEyeState', 'gizette', 'HTRU2',...
            'Immunotherapy', 'Ionoshp', 'liver', 'maledon', 'minboone',...
            'Musk', 'Musk2', 'plrx', 'qsar', 'sonar', 'spect', 'spectf',...
            'telescope', 'theorem', 'vertebral'};
        normalisation = 0; % no normalisation
        nN = length(names);
        for k = 1:nN
            % Display database name
            fprintf('\n%s',names{k});
            % Load database
            load(['databases\', names{k}, '.mat']);
            % normalise if necessary
            if normalisation == 1
                X = zscore(X);
            elseif normalisation == 2
                mi = min(X);
                ma = max(X);
                X = bsxfun(@rdivide, bsxfun(@minus, X, mi), (ma - mi));
            end
            % Calculate results
            res = oneDatabaseTestOpt3(X, Y);
            % Save results
            save(['without/', names{k}, 'Res.mat'], 'res', '-v7.3');
        end
    case 5 % Calculations are not fast!
        names = {'Banknote', 'blood', 'breastCancer', 'climate', 'colposcopy',...
            'Cryotherapy', 'diabetic', 'EggEyeState', 'gizette', 'HTRU2',...
            'Immunotherapy', 'Ionoshp', 'liver', 'maledon', 'minboone',...
            'Musk', 'Musk2', 'plrx', 'qsar', 'sonar', 'spect', 'spectf',...
            'telescope', 'theorem', 'vertebral'};
        normalisation = 1; % normalisation to unit variance
        nN = length(names);
        for k = 1:nN
            % Display database name
            fprintf('\n%s',names{k});
            % Load database
            load(['databases\', names{k}, '.mat']);
            % normalise if necessary
            if normalisation == 1
                X = zscore(X);
            elseif normalisation == 2
                mi = min(X);
                ma = max(X);
                X = bsxfun(@rdivide, bsxfun(@minus, X, mi), (ma - mi));
            end
            % Calculate results
            res = oneDatabaseTestOpt3(X, Y);
            % Save results
            save(['unit/', names{k}, 'Res.mat'], 'res', '-v7.3');
        end
    case 6 % Calculations are not fast!
        names = {'Banknote', 'blood', 'breastCancer', 'climate', 'colposcopy',...
            'Cryotherapy', 'diabetic', 'EggEyeState', 'gizette', 'HTRU2',...
            'Immunotherapy', 'Ionoshp', 'liver', 'maledon', 'minboone',...
            'Musk', 'Musk2', 'plrx', 'qsar', 'sonar', 'spect', 'spectf',...
            'telescope', 'theorem', 'vertebral'};
        normalisation = 2; % normalisation to interval [-1, 1]
        nN = length(names);
        for k = 1:nN
            % Display database name
            fprintf('\n%s',names{k});
            % Load database
            load(['databases\', names{k}, '.mat']);
            % normalise if necessary
            if normalisation == 1
                X = zscore(X);
            elseif normalisation == 2
                mi = min(X);
                ma = max(X);
                X = bsxfun(@rdivide, bsxfun(@minus, X, mi), (ma - mi));
            end
            % Calculate results
            res = oneDatabaseTestOpt3(X, Y);
            % Save results
            save(['inter/', names{k}, 'Res.mat'], 'res', '-v7.3');
        end
    case 7
        load('allNames.mat');
        load('metrNames.mat');
        res2xls('without/', dbNames, names, metrNames, measures, 'empty.xlsx');
        res2xls('unit/', dbNames, names, metrNames, measures, 'standardised.xlsx');
        res2xls('inter/', dbNames, names, metrNames, measures, 'dispersion.xlsx');
    case 8
        % Provide test of one file of standard format, created by res2xls
        % Critical values for Nomenyi post hoc test
        load('NomenyiCV.mat')
        cvN = nomCV(:,2);   % nomCV(:,1) means 0.01,
                            % nomCV(:,2) means 0.05,
                            % nomCV(:,3) means 0.10,
        % Measures to apply
        measures = {'TNNSC', 'Accuracy', 'Se+Sp'};
        % Constats
        nMetr = 8;  % Number of metrix (models). Corresponds to 'B1:I1'.
        nDB = 36;   % Number of databases. Corresponds to 'A2:A37'.
        % Data matrix in range 'B2:I37'.
        % dbNames contains list of models.
        [~, ~, metrNames] = xlsread('empty.xlsx', measures{1}, 'B1:I1');
        % metrNames contains list of metrics.
        [~, ~, dbNames] = xlsread('empty.xlsx', measures{1}, 'A2:A37');
        nM = length(measures);
        % Loop of normalisations
        for norm = 1:3
            switch norm
                case 1
                    % File name to test
                    fNameIn = 'empty.xlsx';
                    % File name to save
                    fNameOut = 'emptyTest.xlsx';
                case 2
                    % File name to test
                    fNameIn = 'standardised.xlsx';
                    % File name to save
                    fNameOut = 'standardisedTest.xlsx';
                case 3
                    % File name to test
                    fNameIn = 'dispersion.xlsx';
                    % File name to save
                    fNameOut = 'dispersionTest.xlsx';
            end
            
            for k = 1:nM
                % Read matrix of results
                M = xlsread(fNameIn, measures{k}, 'B2:I37');
                % Define names of sheets
                nam = [measures{k}, ' '];
                rankDataFriedman(M, metrNames, cvN, dbNames, fNameOut, nam);
            end
        end
    case 9
        % Create array for results. The first three rows correspond to
        % empty preprocessing, the seconf three rows correspond to
        % standardised data, and the last three rows correspond to
        % norlaisation to unit interval (standard dispersion).
        % The rows 1, 4, and 7 correspond to TNNSC
        % The rows 2, 5, and 8 correspond to Accuracy
        % The rows 3, 6, and 9 correspond to Se+Sp
        % The first column contains p-values for comparison of L_0.5 and L_1
        % The first column contains p-values for comparison of L_0.5 and L_2
        % The first column contains p-values for comparison of L_1 and L_2
        res = zeros(9, 3);
        for row = 1:9
            switch row 
                case 1
                    M = xlsread('empty.xlsx', 'TNNSC', 'D2:F37');
                case 2
                    M = xlsread('empty.xlsx', 'Accuracy', 'D2:F37');
                case 3
                    M = xlsread('empty.xlsx', 'Se+Sp', 'D2:F37');
                case 4
                    M = xlsread('standardised.xlsx', 'TNNSC', 'D2:F37');
                case 5
                    M = xlsread('standardised.xlsx', 'Accuracy', 'D2:F37');
                case 6
                    M = xlsread('standardised.xlsx', 'Se+Sp', 'D2:F37');
                case 7
                    M = xlsread('dispersion.xlsx', 'TNNSC', 'D2:F37');
                case 8
                    M = xlsread('dispersion.xlsx', 'Accuracy', 'D2:F37');
                case 9
                    M = xlsread('dispersion.xlsx', 'Se+Sp', 'D2:F37');
            end
            res(row, :) = wilcoxon(M);
        end
    case 10
        % Create array for results. The first three rows correspond to
        % TNNSC, the seconf three rows correspond to Accuracy, and the last
        % three rows correspond to Se+Sp accuracy.
        % The rows 1, 4, and 7 correspond to L_0.5
        % The rows 2, 5, and 8 correspond to L_1
        % The rows 3, 6, and 9 correspond to L_2
        % The first column contains p-values for comparison of empty and
        %   standardized preprocessing
        % The first column contains p-values for comparison of empty and
        %   standard dispersion preprocessing
        % The first column contains p-values for comparison of standardized
        %   and standard dispersion preprocessing
        res = zeros(9, 3);
        ME = xlsread('empty.xlsx', 'TNNSC', 'D2:F37');
        MS = xlsread('standardised.xlsx', 'TNNSC', 'D2:F37');
        MD = xlsread('dispersion.xlsx', 'TNNSC', 'D2:F37');
        p = 0;
        for k = 1:3
            res(p + k, :) = wilcoxon([ME(:, k), MS(:, k), MD(:, k)]);
        end
        ME = xlsread('empty.xlsx', 'Accuracy', 'D2:F37');
        MS = xlsread('standardised.xlsx', 'Accuracy', 'D2:F37');
        MD = xlsread('dispersion.xlsx', 'Accuracy', 'D2:F37');
        p = 3;
        for k = 1:3
            res(p + k, :) = wilcoxon([ME(:, k), MS(:, k), MD(:, k)]);
        end
        ME = xlsread('empty.xlsx', 'Se+Sp', 'D2:F37');
        MS = xlsread('standardised.xlsx', 'Se+Sp', 'D2:F37');
        MD = xlsread('dispersion.xlsx', 'Se+Sp', 'D2:F37');
        p = 6;
        for k = 1:3
            res(p + k, :) = wilcoxon([ME(:, k), MS(:, k), MD(:, k)]);
        end
    case 11 %Reproduction of Table 2
        dims = [1, 2, 3, 4, 10, 15, 20, 100];
        % Calculate fraction for 10, 20 and 100 points and form one matrix
        res = [distanceCalculateTab2(dims, 1000, 10),...
            distanceCalculateTab2(dims, 1000, 20),...
            distanceCalculateTab2(dims, 1000, 100)];
    case 12
        % Figures to table 2 explanations
        % For reproducibility we use once generated set of data sets but to
        % produce another dataset please simply remove commentaries for the
        % next two lines
        % data = rand(10 * 10, 2);
        % save('dataTab2Fig.mat', 'data', '-v7.3');
        % Load previously load data
        load('dataTab2Fig.mat');
        drawFigTable2(data);
    case 13
        % 13 Draw figure with unit circles
        figure;
        ls = {':k', '-.b', '-r', '--g', ':k', '-.b'};
        wid = [1, 1, 2, 2, 2, 2];
        p = [0.5, 1, 2, 4, 10, 0];
        hold on;
        for k = 1:length(p)
            drawCircle(p(k), ls{k}, wid(k));
        end
        axis equal;
        axis([-1.1, 1.7, -1.1, 1.1]);
        legend({'0.5', '1', '2', '4', '10', '\infty'}, 'FontSize', 20);
        set(gca, 'XTick', [-1, 0, 1]);
        set(gca, 'YTick', [-1, 0, 1]);
        set(gca,'FontSize', 20);
        plot([0, 0], [-1, 1], '-k');
        plot([-1, 1], [0, 0], '-k');
        %set(gca,'Visible','off');
        
        %figure for p=0.01
        p = 0.1;
        x = -0.01:0.000001:-0.000977;
        y = ((1 - abs(x) .^ p) .^ (1 / p));
        figure;
        plot([x, -fliplr(y), y, -fliplr(x), -x, fliplr(y), -y, fliplr(x)], [y, -fliplr(x), -x, fliplr(y), -y, fliplr(x), x, -fliplr(y)], '-k');
        set(gca, 'XTick', [-0.01, 0, 0.01]);
        set(gca, 'YTick', [-0.01, 0, 0.01]);
        set(gca,'FontSize', 20);
        axis equal;
        axis([-0.01, 0.01, -0.01, 0.01]);
        hold on;
        plot([0, 0], [-0.01, 0.01], '-k');
        plot([-0.01, 0.01], [0, 0], '-k');
        
        %figure for p=0.01
        p = 0.01;
        x = -1.e-29:1.e-33:-7.8886e-31;
        y = ((1 - abs(x) .^ p) .^ (1 / p));
        figure;
        plot([x, -fliplr(y), y, -fliplr(x), -x, fliplr(y), -y, fliplr(x)], [y, -fliplr(x), -x, fliplr(y), -y, fliplr(x), x, -fliplr(y)], '-k');
        set(gca, 'XTick', [-1.e-29, 0, 1.e-29]);
        set(gca, 'YTick', [-1.e-29, 0, 1.e-29]);
        set(gca,'FontSize', 20);
        axis equal;
        axis([-1.e-29, 1.e-29, -1.e-29, 1.e-29]);
        hold on;
        plot([0, 0], [-1.e-29, 1.e-29], '-k');
        plot([-1.e-29, 1.e-29], [0, 0], '-k');
end
