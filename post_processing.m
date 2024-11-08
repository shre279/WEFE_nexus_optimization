T = readtable('mopso_pareto_all.csv');
costs = T{:,1:4};
for i = 1:4
    for j = i+1:4
        isd = DetermineDomination(costs(:,[i j]));
        pareto_data = costs(~isd,[i j]);
        csvwrite(['mopso_pareto_ ' num2str(i)  '_'  num2str(j) '.csv'],pareto_data);
    end
end

        
