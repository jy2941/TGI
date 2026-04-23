function [new_density, select_X, select_Y]=detect_complex_XY_one(X, Y, XY,lambda1, lambda2, lambda3, result)
%%%%  Detect one community
%%%%  From X, Y & XY 
    X = single(X);
    Y = single(Y);
    XY = single(XY);
    m = size(X, 1);
    n = size(Y, 1);
    remove_X = [];
    remove_Y = [];
    
    node_X = 1:m;
    node_Y = 1:n;
    select_X = [];
    select_Y = [];

    new_density = 0;
    org_density = sum(XY, 'all') / (m*n)^(lambda3/2); 
    old_S = sum(X, 'all') / m^lambda1 + sum(Y, 'all') / n^lambda2 + sum(XY, 'all') / (m*n)^(lambda3/2); 

    for q=1:(m+n)
    
        disp(q)
        % Define XY_q
        XY_q = XY;
    
        XY_q(remove_X, :) = 0;
        XY_q(:, remove_Y) = 0;    
    
        C = sum(XY_q,1); 
        R = sum(XY_q,2);
        dT = min(C(C>0));
        dS = min(R(R>0));
        
        if length(dT) == 0 | length(dS) == 0   % stop the loop if all X or all Y are excluded. 
            break;
        end
    
        IndT = find(C==dT, 1);
        IndS = find(R==dS, 1);
        c = (m-length(remove_X))/(n-length(remove_Y));
        
        % Just remove first element
        if c*dS <= dT
            remove_X(end+1) = IndS;
            
            remove_X_q = remove_X;
            remove_X_q_min = remove_X_q;
    
            X_qi = X;
            X_qi(remove_X_q, :) = 0;
            X_qi(:, remove_X_q) = 0;
            old_val = 0;
            C = sum(X_qi, 1);
    
            for i=1:(m-length(remove_X)-2)
                C(remove_X_q) = inf;  % Exclude already removed indices
                [~, IndT] = min(C(C>0));
                remove_X_q = [remove_X_q, IndT];
                C = C - X_qi(IndT, :);
                C(remove_X_q) = 0;
                X_qi_sum = sum(C);
                new_val = X_qi_sum / (m - length(remove_X_q) )^lambda1;
                if new_val > old_val
                    old_val = new_val;
                    remove_X_q_min = remove_X_q;
                end
            end
            
            node_X = setdiff(1:m, remove_X_q_min);
       
        else
            remove_Y(end+1) = IndT;
    
            remove_Y_q = remove_Y;
            remove_Y_q_min = remove_Y_q;  
    
            Y_qj = Y;
            Y_qj(remove_Y_q, :) = 0;
            Y_qj(:, remove_Y_q) = 0;
            old_val = 0;
            R = sum(Y_qj, 1); 
    
            for j=1:(n-length(remove_Y)-2)    
                R(remove_Y_q) = inf;  % Exclude already removed indices
                [~, IndS] = min(R(R>0));
                remove_Y_q = [remove_Y_q, IndS];
                R = R - Y_qj(IndS, :);
                R(remove_Y_q) = 0;
                Y_qj_sum = sum(R);
                new_val = Y_qj_sum / (n - length(remove_Y_q) )^lambda2;
                if new_val > old_val
                    old_val = new_val;
                    remove_Y_q_min = remove_Y_q;
                end
            end
    
            node_Y = setdiff(1:n, remove_Y_q_min);        
        end
    
        X_q = X(node_X, node_X);
        Y_q = Y(node_Y, node_Y);
        XY_q = XY(node_X, node_Y);
    
        new_S = sum(sum(X_q)) / length(node_X)^lambda1 + sum(sum(Y_q)) / length(node_Y)^lambda2 + sum(sum(XY_q)) / (length(node_X)*length(node_Y))^(lambda3/2);
        test_density = sum(sum(XY_q)) / (length(node_X)*length(node_Y))^(lambda3/2);
    
        if new_S > old_S & checkIntersectionAndSubsetMultiple(node_X, result, 1) & checkIntersectionAndSubsetMultiple(node_Y, result, 2) & test_density > org_density
            old_S = new_S;
            select_X = node_X;
            select_Y = node_Y;
            new_density = sum(sum(XY_q)) / (length(node_X)*length(node_Y))^(lambda3/2);
            disp(new_density)
        end
     end
end