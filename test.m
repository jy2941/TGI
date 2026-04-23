tic()
[W_density_new, select_X_new, select_Y_new] = greedy_test(X(1:3000, 1:4500), 1.4);
% setdiff(1:m, remove_X)
toc()


tic()
result = greedy_peeling_XY_all(XY, 1.3);
% setdiff(1:m, remove_X)
toc()


result = cell(20, 2);
detect_complex_XY_one(X, Y, XY, 1.5, 1.5, 1.5, result);



tic()
length(x)
% setdiff(1:m, remove_X)
toc()


Y = X(1001:3000, 1001:3000);
XY = X(1:1000, 1001:3000);
X = X(1:1000, 1:1000);

result = cell(20, 3);
[new_density, select_X, select_Y]=detect_complex_XY_one(X, Y, XY,1.9, 1.9, 1.9, result);

result = cell(20, 3);
[new_density, select_X, select_Y]=detect_test(X, Y, XY,1.9, 1.9, 1.9, result);

