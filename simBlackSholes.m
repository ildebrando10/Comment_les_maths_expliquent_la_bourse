clc; clear; close all;
pkg load statistics
% Paramètres du modèle
E = 100;      % Prix d'exercice
r = 0.06;     % Taux d'intérêt sans risque
sigma = 0.3;  % Volatilité
T = 1;        % Temps d'échéance

% Discrétisation des axes
S = linspace(0, 200, 50);  % Prix du sous-jacent
t = linspace(0, 1, 50);    % Temps avant l'échéance

% Création des grilles de valeurs
[SS, TT] = meshgrid(S, t);

% Calcul des valeurs du call européen selon la formule donnée
k = 2 * r / sigma^2;
d1 = (log(SS(1:end-1,:)/E) ./ (sigma * sqrt(T - TT(1:end-1,:)))) - (k + 1) * sigma * sqrt(T - TT(1:end-1,:));
d2 = (log(SS(1:end-1,:) / E) ./ (sigma * sqrt(T - TT(1:end-1,:)))) - (k - 1) * sigma * sqrt(T - TT(1:end-1,:));

C = (SS(1:end-1,:) ./ E) .* normcdf(d1) - exp(-r * (T - TT(1:end-1,:))) / 2 .* normcdf(d2);

% Appliquer la condition terminale : C(S,T) = max(S - E, 0)
%C(TT == T) = max(SS(TT == T) - E, 0);

% Appliquer la condition aux limites
C(SS(1:end-1,:) == 0) = 0; % C(0,t) = 0
%C(SS == max(S), :) = max(S) - E; % Approximativement pour S->+inf

% Tracé de la surface
figure;
surf(SS(1:end-1,:), TT(1:end-1,:), C, 'EdgeColor', 'none');
xlabel('Prix du sous-jacent S');
ylabel('Temps t');
zlabel('Prix du call C(S,t)');
title('Prix du call en fonction de S et t');
colorbar;
view(135, 30); % Ajustement de l'angle de vue
