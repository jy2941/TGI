function [new_density, select_X, select_Y]=detect_one(X, Y, XY,lambda1, lambda2, lambda3, result)
%%%%  Detect one community
%%%%  From X, Y & XY 
    X = single(X);
    Y = single(Y);
    XY = single(XY);
    m = size(X, 1);
    n = size(Y, 1);   
    remove_X = [];
    remove_Y = [];
    len_X = m;
    len_Y = n;
    
    if size(XY, 1) ~= m | size(XY, 2) ~= n
        error('Something Wrong with Input Dimension');
    end    

    C_X = sum(X, 1);
    C_Y = sum(Y, 1);
    C_XY = sum(XY, 1); 
    R_XY = sum(XY,2);
    [old_val_X, node_X] = greedy_peeling_X_one(X, lambda1);
    [old_val_Y, node_Y] = greedy_peeling_X_one(Y, lambda2);

    org_density = sum(C_XY) / (m*n)^(lambda3/2); 
    % org_density = 0;
    % old_S = sum(C_X) / m^lambda1 + sum(C_Y) / n^lambda2 + sum(C_XY) / (m*n)^(lambda3/2);
    old_S = log(sum(C_X) / m^lambda1 + sum(C_Y) / n^lambda2 + 1) + log(sum(C_XY) / (m*n)^(lambda3/2));
    new_density = 0;
    select_X = [];
    select_Y = [];

    for q=1:(m+n)
    
        % disp(q)
        
        C_XY(remove_Y) = inf;  % Exclude already removed indices for X&Y (as infinity)
        R_XY(remove_X) = inf;
      
        [dT, IndT] = min(C_XY);
        [dS, IndS] = min(R_XY);  
        
        if dT == inf | dS == inf   % stop the loop if all X or all Y are excluded. 
            break;
        end
        
        c = len_X/len_Y;
        
        % Just remove first element
        if c*dS <= dT
            remove_X(end+1) = IndS;
            C_XY = C_XY - XY(IndS, :);
            C_X = C_X - X(IndS, :);
            len_X = len_X - 1;
            
            if ismember(IndS, node_X)
                C_X_q = C_X;
                remove_X_q = remove_X;
                remove_X_q_min = remove_X;
                old_val_X = 0;
    
                for i=1:(len_X-1)
                    C_X_q(remove_X_q) = inf;  % Exclude already removed indices
                    [~, IndS] = min(C_X_q);
                    remove_X_q(end+1) = IndS;
                    C_X_q = C_X_q - X(IndS, :);
                    C_X_q(remove_X_q) = 0;
                    X_sum = sum(C_X_q);
                    new_val_X = X_sum / (len_X - i)^lambda1;
                    if new_val_X > old_val_X
                        old_val_X = new_val_X;
                        remove_X_q_min = remove_X_q;
                    end
                end
                
                node_X = setdiff(1:m, remove_X_q_min);
                
                % disp(q)
            end    
       
        else
            remove_Y(end+1) = IndT;
            R_XY = R_XY - XY(:, IndT);
            C_Y = C_Y - Y(IndT, :);
            len_Y = len_Y - 1;
            
            if ismember(IndT, node_Y)
                C_Y_q = C_Y;
                remove_Y_q = remove_Y;
                remove_Y_q_min = remove_Y;
                old_val_Y = 0;
    
                for j=1:(len_Y-1)
                    C_Y_q(remove_Y_q) = inf;  % Exclude already removed indices
                    [~, IndT] = min(C_Y_q);
                    remove_Y_q(end+1) = IndT;
                    C_Y_q = C_Y_q - Y(IndT, :);
                    C_Y_q(remove_Y_q) = 0;
                    Y_sum = sum(C_Y_q);
                    new_val_Y = Y_sum / (len_Y - j)^lambda2;
                    if new_val_Y > old_val_Y
                        old_val_Y = new_val_Y;
                        remove_Y_q_min = remove_Y_q;
                    end
                end
            
                node_Y = setdiff(1:n, remove_Y_q_min);
            end        
        end
    
        XY_q = XY(node_X, node_Y);
    
        test_density = sum(sum(XY_q)) / (length(node_X)*length(node_Y))^(lambda3/2);
        % new_S = old_val_X + old_val_Y + test_density;   
        new_S = log(old_val_X + old_val_Y + 1) + log(test_density);

        if new_S > old_S & checkIntersectionAndSubsetMultiple(node_X, result, 1) & checkIntersectionAndSubsetMultiple(node_Y, result, 2) & test_density > org_density
            old_S = new_S;
            select_X = node_X;
            select_Y = node_Y;
            new_density = sum(sum(XY_q)) / (length(node_X)*length(node_Y))^(lambda3/2);
        end
    end
end