function result = detect_test_all(X, Y, XY,lambda1, lambda2, lambda3)

    result = cell(20, 2);
    i = 1;
    m = size(X, 1);
    n = size(Y, 1); 

    % Original Density
    org_density = 0;
    % org_density = sum(sum(XY)) / (m*n)^(lambda3/2);
    median_value = median(XY, "all");

    while true & i<10
    
        disp(['Round ', num2str(i)])
        disp('******************')

        [new_density, select_X, select_Y]=detect_test(X, Y, XY,lambda1, lambda2, lambda3, result);

        if new_density > org_density
            XY(select_X, select_Y) = median_value;
            result{i, 1} = select_X;
            result{i, 2} = select_Y;
            i = i+1;
        else 
            break
    end    
end 
