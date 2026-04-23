function [W_DSD_greedy, Clist, Node_Seq, removing_node] = greedy_peeling(Wp_DSD, lambda)
    % a simple implementation of the greedy algorithm from the Denser than
    % dense paper, using the generalized objective function (SICERS
    % Biostatistics by Chuo Chen, Chuan Bi, et al)
    % note that this only extract ONE dense subgraphs
    % Chuan
    
    N = size(Wp_DSD,1);
    Recording_Matrix = zeros(N,2);
    Recording_Clist = 1:N;
    Wp_temp = single(Wp_DSD);
    C = sum(Wp_temp, 1);
    remove_idx = [];
    temp_Clist = 1:N;
    ite = 0;
    for i = N:-1:1
        % Calculate sum ignoring NaNs
        C(remove_idx) = inf;  % Exclude already removed indices
        [~, idx_min_temp] = min(C);
        % Update remove_idx
        remove_idx = [remove_idx, idx_min_temp];
        % Calculate sum
        C = C - Wp_temp(idx_min_temp, :);
        C(remove_idx) = 0;
        sum_wp_temp = sum(C);

%         Wp_temp(idx_min_temp, :) = 0;
%         Wp_temp(:, idx_min_temp) = 0;
        % Calculate score_temp
        ite = ite + 1;
%         denom = (N - ite) .* (N - ite - 1) ./ 2;
%         score_temp = ((sum_wp_temp / 2) ./ denom) .^ lambda .* (sum_wp_temp ./ 2) .^ (1 - lambda);
%         score_temp = ((sum_wp_temp / 2) ./ (N - ite)) .^ (2*lambda) .* (sum_wp_temp ./ 2) .^ (2 - 2*lambda);        % Store values in Recording_Matrix
%         score_temp = ((sum_wp_temp / 2) ./ (N - ite)) .^ (2*lambda);
        score_temp = (sum_wp_temp / 2) ./ ((N - ite) ^ (2 * lambda));
        Recording_Matrix(N - i + 1, :) = [Recording_Clist(idx_min_temp), score_temp];
%         if isinf(score_temp)
%             Recording_Matrix(N - i + 1, :) = [Recording_Clist(idx_min_temp), 0];
%         else
%             Recording_Matrix(N - i + 1, :) = [Recording_Clist(idx_min_temp), score_temp];
%         end
    end
    % Find the index of the maximum score
%     Recording_Matrix(end-1,2) = 0;
%     Recording_Matrix(end-1:end,1) = setdiff(Recording_Clist, remove_idx);
    [~,max_idx] = max(Recording_Matrix(:,2));
    
%     sc = Recording_Matrix(:,2);
%     [~,max_idx] = max(sc(isfinite(sc)));
    % Extract the removing nodes and node sequence
    removing_node = Recording_Matrix(1:max_idx, 1);
    Node_Seq = Recording_Matrix(end:-1:max_idx+1, 1);
    % Concatenate node sequence and removing nodes
    Clist = [Node_Seq; removing_node];
    % Extract subgraph based on Clist
    W_DSD_greedy = Wp_DSD(Clist,Clist);

end