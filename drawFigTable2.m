function drawFigTable2(data)
    % Define metrics to use
    metr = [0.01, 0.1, 0.5, 1, 2, 0];
    nM = length(metr);
    nR = size(data, 1) / 10;
    % Create figure
    figure;
    nf = 1; % Number of figure
    for k = 1:nR
        dat = data((k-1)*10 + 1:k*10, :);
        for m = 1:nM
            subplot(nR, nM, nf);
            plot(dat(:, 1), dat(:, 2), '.k');%, 'MarkerFaceColor', 'k');
            [cl, fur, rc] = searchDist(dat, metr(m));
            hold on;
            plot(dat(cl, 1), dat(cl, 2), 'xb-');
            plot(dat(fur, 1), dat(fur, 2), '+r-');
            title(['RC = ', num2str(rc)]);
            axis([0, 1, 0, 1]);
            axis square;
            set(gca,'YTickLabel',[]);
            set(gca,'XTickLabel',[]);
            nf = nf + 1;
        end
    end
end

function [cl, fur, rc] = searchDist(data, p)
    % Calculate distances btween all points
    mi = Inf;
    ma = 0;
    for k = 1:10
        dats = abs(bsxfun(@minus, data, data(k, :)));
        dats(k, :) = [];
        if p > 0
            dist = sum(dats .^ p, 2) .^ (1/p);
        else
            dist = max(dats, [], 2);
        end
        [tmp, ind] = max(dist);
        if tmp > ma
            ma = tmp;
            fur1 = k;
            if ind < k
                fur2 = ind;
            else
                fur2 = ind + 1;
            end
        end
        [tmp, ind] = min(dist);
        if tmp < mi
            mi = tmp;
            cl1 = k;
            if ind < k
                cl2 = ind;
            else
                cl2 = ind + 1;
            end
        end
    end
	rc = (ma - mi) / mi;
    cl = [cl1, cl2];
    fur = [fur1, fur2];
end