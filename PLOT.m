% === Parameters ===
m = 200;         % Number of rows in A and B
n = 10;        % Number of columns in A and C

% === Random matrices ===
A = rand(m, n);    % Left panel
B = rand(m, m);    % Center panel
C = rand(n, n);    % Bottom panel

s = 1;sr = 2;     % Diamond patch half-side

figure; hold on;

% --- Left: Diamonds for lower triangle
for i = 1:n
    for j = i:n
        x0 = -i + 1;
        y0 = sr*n - j*2 + i;

        vx = [0 s 0 -s];
        vy = [s 0 -s 0];

        patch(x0 + vx, y0 + vy, C(i,j), 'EdgeColor', 'none');
    end
end


% --- Bottom: Mirrored diamonds for lower triangle ---

for i = 1:m
    for j = i:m
        x0 = j*2-i; 
        y0 = -i+1; 

        vx = [0 s 0 -s];
        vy = [s 0 -s 0];

        patch(x0 + vx, y0 + vy, B(i,j), 'EdgeColor', 'none');
    end
end

% --- Middle Square
for i = 1:m
    for j = 1:n
        x0 = (i - 1) * 2;
        y0 = (j - 1) * 2;

        vxs = [0 sr sr 0];
        vys = [0 0 sr sr];

        patch(x0 + vxs, y0 + vys, B(i,j), 'EdgeColor', 'none');
    end
end

hold off;
axis equal off;