function result = greedy_3step(P, R, m, n,lambda1, lambda2, lambda3, X_size, Y_size)
    % Greedy algorithm based 3 parts. 
    % P : combined -log p.value matrix for data type 1&2, (m+n)*(m+n) matrix
    % R : combined correlation matrix for data type 1&2, (m+n)*(m+n) matrix
    % m : number of vars for data type 1
    % n : number of vars for data type 2
    % Lambda 1-3 : Penalty parameter for controlling community size, value in [1, 2]
    % X_max&Y_max : size limit detected community

    % ---------- Default handling ----------
    if nargin < 5
        lambda1 = 1.5;
        lambda2 = 1.5;
        lambda3 = 1.5;
        X_size  = [10, 200];
        Y_size  = [10, 200];
    elseif nargin < 8
        X_size  = [10, 200];
        Y_size  = [10, 200];
    elseif nargin ~= 9
        error('Input must be either 4, 7, or 9 arguments.');
    end

    Wp = P(1:m, (m+1):(m+n));
    Wp(Wp < 2) = 0;
    result = greedy_peeling_XY_all(Wp, lambda1);

    % Optimize
    idx = cellfun(@length, result(:,1)) > X_size(1);
    result = result(idx, :);
    idx = cellfun(@length, result(:,2)) > Y_size(1);
    result = result(idx, :);  
    result(end+1, :) = {[], []};

    nRows = size(result, 1);
    for i = 1:nRows
        if numel(result{i,1}) > X_size(2)
            idx_X = cat(1, result{i,1});
            X = R(idx_X, idx_X);
            X = (X + X') / 2;
            test = greedy_peeling_X_all(X, lambda2);
            test = sort_result(X, test);
            result{i,1} = idx_X(cat(2, test{:,1}));
        end
        if numel(result{i,2}) > Y_size(2)
            idx_Y = m + cat(1, result{i,1});
            Y = R(idx_Y, idx_Y);
            Y = (Y + Y') / 2;
            test = greedy_peeling_X_all(Y, lambda3);
            test = sort_result(Y, test);
            result{i,2} = idx_Y(cat(2, test{:,1}));
        end       
    end    