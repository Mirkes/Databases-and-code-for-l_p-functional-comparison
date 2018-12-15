function drawCircle(p, lineSpec, width)
    x = -1:0.001:1;
    if p == 0
        plot([-1, 1, 1, -1, -1], [1, 1, -1, -1, 1], lineSpec, 'LineWidth', width);
    else
        y = ((1 - abs(x) .^ p) .^ (1 / p));
        plot([x, fliplr(x)], [y, -fliplr(y)], lineSpec, 'LineWidth', width);
    end
end