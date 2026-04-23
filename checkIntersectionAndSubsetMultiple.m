function result = checkIntersectionAndSubsetMultiple(a, b, k)
    % Loop through each array bi
    for i = 1:length(b)
        bi = b{i, k};
        
        % Check for intersection
        common_elements = intersect(a, bi);
        
        % Check if there is an intersection
        if ~isempty(common_elements)
            % Check if a is a subset of b
            is_a_subset_of_b = all(ismember(a, bi));
            
            % Check if b is a subset of a
            is_b_subset_of_a = all(ismember(bi, a));
            
            % Return false if there is an intersection but one is not a subset of the other
            if ~(is_a_subset_of_b || is_b_subset_of_a)
                result = false;
                return;
            end
        end
    end
    
    % If no such condition is met, return true
    result = true;
end

