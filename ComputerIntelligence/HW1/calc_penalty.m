function penalty = calc_penalty(x, cards)
    s1 = cards(x == 1);
    s2 = cards(x == 2);
    s3 = cards(x == 3);

    % Compute constraints
    sum1 = sum(s1);
    sum2 = sum(s2);
    if isempty(s3)
        prod3 = 0;
    else
        prod3 = prod(s3);
    end

    % Penalize deviation from desired values
    penalty = abs(sum1 - 49) + abs(sum2 - 33) + abs(prod3 - 12600);

    % Additional penalty if some cards are missing or unassigned
    if length(unique(x)) < 3 || numel([s1 s2 s3]) < 15
        penalty = penalty + 1000;
    end
end
