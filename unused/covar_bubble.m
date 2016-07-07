function [ output_args ] = covar_bubble( sigma )
% Plots the Gaussian "bubble" for a given covariance matrix sigma.

size = abs(max(max(sigma))) * 3;
[X1,X2] = meshgrid(linspace(-size, size, 85));
X = [X1(:), X2(:)];
Z = mvnpdf(X, 0.0, sigma);
surf(X1, X2, reshape(Z, 85, 85));

end

