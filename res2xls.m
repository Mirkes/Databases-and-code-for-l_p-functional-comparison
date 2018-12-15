function res2xls(dir, databases, names, models, measures, fName)
%Inputs:
%   Dir is directory with res files to convert.
%   databases is cell array of database names without extension and 'Res'
%       postfix.
%   names is list (cell array) of database names to use in result file. If
%       one database contains more than one task than corresponding
%       fragments are numerated as [names{k}, ' ', num2str(r)], where k is
%       number of database and r is number of task in database.
%   models is list (cell array) of models to use in result file
%   measures is list (cell array) of accuracy measures to use in result file
%   fName is file name for result file

    % Suppress warning for adding of sheets
    warning( 'off', 'MATLAB:xlswrite:AddSheet' ) ;
    % Estimate size of table by reading all '...Res.mat' files into cell
    % array
    nDB = length(databases);
    reses = cell(nDB, 1);
    nTask = 0;
    for k = 1:nDB
        load([dir, databases{k}, 'Res.mat']);
        reses(k) = {res};
        nTask = nTask + length(res);
    end

    % Get sizes
    nMes = length(measures);
    nMod = length(models);
    % Calculate number f tests for bonferroni correction
    norm = nMod * (nMod - 1) / 2;

    % Create array for detailed information
    det = cell(nTask * (5 + nMod), nMes + 1 + nMes * (nMod + 2));
    
    % Create arrays for summary tables
    summ = zeros(nTask, nMod, nMes);
    finn = zeros(2, nMod, nMes);
    taskNames = cell(nTask, 1);
    
    s = 1; %start row in the detailed spreadsheet
    tn = 1; %Current task number
    for kT = 1:nDB
        res = reses{kT};
        nST = length(res);
        for kST = 1:nST
            % get one structure
            rr = res(kST);
            % write BD/Task name
            if nST == 1
                nam = names(kT);
            else
                nam = {[names{kT}, ' ', num2str(kST)]};
            end
            det(s, 1) = nam;
            taskNames(tn) = nam;
            s = s + 1;
            % Write the first table
            det(s + 1, 1) = {'Model'};
            det(s + 1, 2:nMes + 1) = measures;
            det(s + 2:s + nMod + 1, 1) = models;
            det(s + 2:s + nMod + 1, 2:nMes + 1) = num2cell(rr.data);
            p = nMes +3; % number of column to start
            for kM = 1:nMes
                % Get data for summary tables
                summ(tn, :, kM) = rr.data(:, kM)';
                % Write like caption
                det(s, p) = measures(kM);
                if kM == 1
                    pval = rr.thresh(1);
                else
                    pval = rr.thresh(2);
                end
                % Calculate corrected p-value
                cpval = max([1.e-5, pval / norm]);
                % Write thresholds
                det(s, p + 1) = {'Alpha'};
                det(s, p + 2) = num2cell(pval);
                det(s, p + 3) = {'Corrected alpha'};
                det(s, p + 4) = num2cell(cpval);
                % Write titles
                det(s + 1, p) = {'Model'};
                det(s + 1, p + 1:p + nMod) = models;
                det(s + 2:s + nMod + 1, p) = models';
                % Get p-value table
                switch kM
                    case 1
                        t = rr.TNNSCp;
                    case 2
                        t = rr.Accp;
                    case 3
                        t = rr.Sep;
                    case 4
                        t = rr.Spp;
                end
                t(isnan(t)) = 0.5;
                % Find elements which are insignificantly different from
                % ind
                [~, ind] = max(rr.data(:, kM));
                ind = t(ind,:) > cpval;
                finn(1, ind, kM) = finn(1, ind, kM) + 1;
                [~, ind1] = min(rr.data(:, kM));
                ind1 = t(ind1,:) > cpval;
                finn(2, ind1, kM) = finn(2, ind1, kM) + 1;
                a = [ind;ind1];
                % Form matrix to write
                det(s + 2:s + nMod + 1, p + 1:p + nMod) = num2cell(t);
                % Shift origin
                p = p + nMod + 2;
            end
            s = s + nMod + 3;
            tn = tn + 1;
        end
    end

    % Write spreadsheet with detailed information
    xlswrite(fName, det, 'Detailed');
    % Write tables for each measure
    t = cell(nTask + 6, nMod + 1);
    p = nTask + 3;
    t(1, 1) = {'Database'};
    t(2:nTask + 1, 1) = taskNames;
    t(1, 2:nMod + 1) = models;
    for kM = 1:nMes
        % Get corresponding array
        det = summ(:, :, kM);
        t(2:nTask + 1, 2:nMod + 1) = num2cell(det);
        % Form header of the next table
        t(p, 1) = {'Indicator'};
        t(p, 2:nMod + 1) = models;
        % Calculate number of the best 
        m = max(det, [], 2);
        s = sum(det == repmat(m, 1, nMod));
        t(p + 1, 1) = {'The best'};
        t(p + 1, 2:nMod + 1) = num2cell(s);
        m = min(det, [], 2);
        s = sum(det == repmat(m, 1, nMod));
        t(p + 2, 1) = {'The worst'};
        t(p + 2, 2:nMod + 1) = num2cell(s);
        t(p + 3, 1) = {'Insignificantly different from the best'};
        t(p + 4, 1) = {'Insignificantly different from the worst'};
        t(p + 3:p + 4, 2:nMod + 1) = num2cell(finn(:, :, kM));
        xlswrite(fName, t, measures{kM});
    end
    
    % Write spreadsheet for sensitivity + specificity
    t(end-1:end,:)= [];
    p = nTask + 3;
    t(1, 1) = {'Database'};
    t(2:nTask + 1, 1) = taskNames;
    t(1, 2:nMod + 1) = models;
    % Get corresponding array
    det = summ(:, :, 3) + summ(:, :, 4);
    t(2:nTask + 1, 2:nMod + 1) = num2cell(det);
    % Form header of the next table
    t(p, 1) = {'Indicator'};
    t(p, 2:nMod + 1) = models;
    % Calculate number of the best
    m = max(det, [], 2);
    s = sum(det == repmat(m, 1, nMod));
    t(p + 1, 1) = {'The best'};
    t(p + 1, 2:nMod + 1) = num2cell(s);
    m = min(det, [], 2);
    s = sum(det == repmat(m, 1, nMod));
    t(p + 2, 1) = {'The worst'};
    t(p + 2, 2:nMod + 1) = num2cell(s);
    xlswrite(fName, t, 'Se+Sp');
        
    % Reactivate warning for adding of sheets
    warning( 'on', 'MATLAB:xlswrite:AddSheet' ) ;
end