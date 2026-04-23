function plot3in1(X, Y, XY, result)
% All input should be correlation matrix
% Input:
% X m*m, Y n*n, XY m*n
% now assume m > n to simplify following code, I don't know what will
% happen if n > m.......

    select_X = cat(2, result{:,1});
    select_Y = cat(2, result{:,2});

    C = Y(select_Y, select_Y);
    B = X(select_X, select_X);
    A = XY(select_X, select_Y);

    [m,n] = size(A);
    ratio = m/n/1.2; % 1.2 is kind of pre-set width-length ratio

    figure; hold on;
    
    %% --- Left: Diamonds for lower triangle
    % Count number of diamonds: sum of (n - i + 1) for i=1..n
    num = n*(n+1)/2;
    % Preallocate vertex arrays (each diamond has 4 vertices)
    plotX = zeros(4, num);
    plotY = zeros(4, num);
    plotC = zeros(1, num);
    
    vx = [0 1 0 -1];
    vy = [1 0 -1 0];
    
    count = 0;
    for i = 1:n
        for j = i:n
            count = count + 1;
            x0 = -i + 1;
            y0 = 2*n - j*2 + i;
    
            plotX(:,count) = x0 + vx;
            plotY(:,count) = y0 + vy;
            plotC(count) = C(j,j-i+1);
        end
    end
    
    % Build Faces matrix (each diamond = 4 vertices)
    Faces = reshape(1:4*num, 4, num)';
    
    % Combine all vertices into one big array (columns = vertices)
    Vertices = [plotX(:) plotY(:)];
    
    % Plot all diamonds in one patch call
    patch('Faces', Faces, 'Vertices', Vertices, ...
          'FaceVertexCData', plotC', 'FaceColor', 'flat', 'EdgeColor', 'none');
    
    %% --- Bottom: Mirrored diamonds for lower triangle ---
    
    num = m*(m+1)/2;
    
    % Preallocate vertex arrays (4 vertices per diamond)
    plotX = zeros(4, num);
    plotY = zeros(4, num);
    plotC = zeros(1, num);

    vx = [0 1/ratio 0 -1/ratio];
    vy = [1/ratio 0 -1/ratio 0];

    count = 0;
    for i = 1:m
        for j = i:m
            count = count + 1;
            x0 = (j*2 - i)/ratio;
            y0 = (-i + 1)/ratio;
    
            plotX(:,count) = x0 + vx;
            plotY(:,count) = y0 + vy;
            plotC(count) = B(j,j-i+1);
        end
    end
    
    % Build Faces matrix (each diamond = 4 vertices)
    Faces = reshape(1:4*num, 4, num)';
    
    % Combine all vertices into one big array (columns = vertices)
    Vertices = [plotX(:) plotY(:)];
    
    % Plot all diamonds in one patch call
    patch('Faces', Faces, 'Vertices', Vertices, ...
          'FaceVertexCData', plotC', 'FaceColor', 'flat', 'EdgeColor', 'none');
    
    axis equal off;
    hold off;
    
    %% --- Middle Square
    vxs = [0 2/ratio 2/ratio 0];
    vys = [0 0 2 2];
    
    num = m * n;  % total number of patches   
    % Preallocate
    plotX = zeros(4, num);
    plotY = zeros(4, num);
    plotC = zeros(1, num);
    
    count = 0;
    for i = 1:m
        for j = 1:n
            count = count + 1;
            x0 = (i - 1) * 2/ratio;
            y0 = (j - 1) * 2;
    
            plotX(:,count) = x0 + vxs;
            plotY(:,count) = y0 + vys;
            plotC(count) = A(i,n+1-j);
        end
    end
    
    % Faces and Vertices for one patch call
    Faces = reshape(1:4*num, 4, num)';
    Vertices = [plotX(:) plotY(:)];
    
    % Plot all patches at once
    patch('Faces', Faces, 'Vertices', Vertices, ...
          'FaceVertexCData', plotC', 'FaceColor', 'flat', 'EdgeColor', 'none');
    colormap(jet);           % Set colormap
    caxis([-1, 1]);          % Fix color scale to range [-1, 1]
    axis equal off;
    hold off;
end    

