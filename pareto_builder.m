%clear all;
% load('mopso_all_data.mat')
% isd = DetermineDomination(all_cost(:,1:2));
% %scatter(all_cost(:,2),all_cost(:,1))
% scatter(all_cost(~isd,2),all_cost(~isd,1),"filled",'r')
% hold on;
load('mopso_all_data.mat')
isd = DetermineDomination(all_cost(:,1:4));
% scatter(all_cost(:,2),all_cost(:,1))
%scatter(all_cost(~isd,2),all_cost(~isd,1),'b')

varLabels = {'Energy Cost', 'Water Supplied', 'Affected Area', 'Food Yield', 'Leakage in', 'Leakage out', 'Total conc'};
corrected_cost = all_cost(~isd,[1:4, end-2:end] );
corrected_cost(:,[2 4]) = -1.*corrected_cost(:,[2 4]);
energyCost = corrected_cost(:,1);

% Normalize the energy cost values for mapping to the colormap
% normEnergyCost = (energyCost - min(energyCost)) / (max(energyCost) - min(energyCost));
% colors = jet(length(energyCost));
% Create the parallel coordinates plot
% parallelplot(array2table(corrected_cost,'VariableNames',varLabels),'CoordinateVariables',varLabels,'Color',colors);


energyCost = corrected_cost(:,1);

% Normalize the energy cost values for mapping to the colormap
normEnergyCost = (energyCost - min(energyCost)) / (max(energyCost) - min(energyCost));
colors = jet(length(energyCost));

% Create the parallel coordinates plot
p = parallelplot(array2table(corrected_cost, 'VariableNames', varLabels));

% Set line colors based on normalized 'Energy Cost' values
for i = 1:length(p.Data)
    % Map each line's color to the normalized 'Energy Cost'
    colorIndex = round(normEnergyCost(i) * (size(colors, 1) - 1)) + 1;
    p.Data(i).Color = colors(colorIndex, :);  % Use the 'Color' property
end

% Create a figure to add a colorbar manually
% colormap(jet);  % Use the same colormap as the lines
% c = colorbar;

% Label the colorbar
% c.Label.String = 'Energy Cost';







% Customize the plot (optional)
title('Parallel Coordinates Plot');
xlabel('Variables');
ylabel('Values');
pareto_data = all_cost(~isd,:);
csvwrite('mopso_pareto_all.csv',pareto_data);