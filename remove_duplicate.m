function A_unique = remove_duplicate(A)
    % Initialize a logical index array for columns to keep
    colsToKeep = true(1, size(A, 2));

    % Compare each column with all subsequent columns
    for i = 1:size(A, 2)
        for j = i+1:size(A, 2)
            if isequal(A(:, i), A(:, j))
                colsToKeep(j) = false; % Mark the duplicate column for removal
            end
        end
    end

    A_unique = A(:,colsToKeep);
end