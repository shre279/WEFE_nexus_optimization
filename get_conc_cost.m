%% cost based upon contaminant concentration in the model
function cost = get_conc_cost(x)

% assuming one decision variable
conc_value  = x;

[row, col] = change_conc(conc_value);

%% Run MT3DMS
run_mt3dms();

%----------------------------------
%% READ THE CONCENTRATION OUTPUT FILE
ucn_data = readMT3D('MT3D001.UCN');

%--------------------------------------
%% CALCULATE THE COST
conc_last = ucn_data(end).values(:,:,1);    %last stress period, 1st layer - conc data.
mat_id = (col - 1)*(size(conc_last,1)) + row ;  % id = (col -1)*max_row + row - row major order
decrease = conc_value- conc_last(mat_id);       
cost = mean(decrease.*(-1));    % decrement is maximized

%---------------------------

end