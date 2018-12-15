function res = wilcoxon(M)
    res = zeros(1, 3);
    res(1) = signrank(M(:, 1), M(:, 2));
    res(2) = signrank(M(:, 1), M(:, 3));
    res(3) = signrank(M(:, 3), M(:, 2));
end
