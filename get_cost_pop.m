%....................Cost function............%
function cost = get_cost_pop(x)

global max_col;
global max_row;
global filename;
global index_wells;
global glo_stress_period;
global all_cost;
global well_position_mat;
global cp;
global gen_wise_data;
global top;

f_name = [filename '.mfs'];
cost = ones([size(x,1) 2]);
ra = ones([size(x,1) 3])
d = ones([size(x,1) 1]);

..............read well data to update file...%
    
% well_data = read_well();
% well_data.discharge(:) = x;
% write_well(well_data);

total_discharge = 0;

crop_data = readtable('crop_values.csv');

well_groups = size(index_wells,1);
for p = 1:size(x,1)
    cd(['.\'  filename  '_MODFLOW'])
    temp = h5read([filename '.h5'],'///Well/07. Property');
    arcs = size(temp,2) -  size(index_wells,2);
    xn = x(p,1:well_groups);
    temp = h5read([filename '.h5'],'///Well/07. Property');
    total_discharge = 0;
for i = 1:numel(xn)
    
    temp(:,[false([1 arcs]) index_wells(i,:)],1) = ones(glo_stress_period,sum(index_wells(i,:))).*xn(i);
    % total discharge calculated
    total_discharge = total_discharge + xn(i)*sum(index_wells(i,:));
    
end
h5write([filename '.h5'],'///Well/07. Property',temp);


[s t] = system(sprintf('mf2k_h5.exe "%s" ', f_name));

head_data = readDat([filename '.hed']);
time_head = [head_data.time];
temp_head = {head_data.values};
temp_head = cat(3,temp_head{:});
temp = readDat([filename '.drw']);
drawdown = temp(end).values;

cd('.\..')

%% pollutant part
h_val = [ temp_head(32,78,15), temp_head(37,62,15), temp_head(125,28,15), temp_head(142,51,15) ];
porosity = 0.30;
conc_value  = (x(p,(well_groups+1):end)./h_val).*(0.015/porosity);

change_conc(conc_value);

%% Run MT3DMS
run_mt3dms();

%----------------------------------
%% READ THE CONCENTRATION OUTPUT FILE
cd(['.\'  filename  '_MT3DMS'])
ucn_data = readMT3D('MT3D001.UCN');
cd('.\..')

%% Calculate environmental cost
t_steps = [ucn_data.time];
t_diff = time_head - [0, time_head(1:end-1)];

temp = abs(t_steps - time_head');
cols = zeros([numel(time_head) 1]);

%correction for small random time steps
for i = 1:size(temp,1)
   cols(i) = find(min(temp(i,:))==temp(i,:));
end


% id = t_diff<50 & t_diff>1;
id = cols;

conc_data = {ucn_data.values};
conc_data = cat(3,conc_data{:});
conc_data = conc_data(:,:,id);
weighted_conc = zeros([numel(t_steps) 1]);
% for steps = 1:numel(t_steps)
%     temp = conc_data(:,:,steps)~=-999;
%     temp2 = conc_data(:,:,steps);
%    weighted_conc(steps) =  mean(temp2(temp))*t_diff(steps);
% end
% mean_conc =sum(weighted_conc)/sum(t_diff);
conc_threshold = 40;
affected_area = sum(sum(conc_data(:,:,end)>conc_threshold));
%--------------------------------------


%conc_river = conc_data(,,end);


%--------------------------------------------

% Runmodflow





if(contains(t,'Error'))
    cost(p,1) = 1000000;
    cost(p,2) = 1000000;
    cost(p,3) = 1000000;
    cost(p,4) = 1000000;
% cost
else
    
    if size(head_data,1)<glo_stress_period
        % penalty multiplied by the number of unconverged stress periods
        cost(p,1) = 100000*(glo_stress_period-size(head_data,1));
        cost(p,2) = 100000*(glo_stress_period-size(head_data,1));
        cost(p,3) = 100000*(glo_stress_period-size(head_data,1));
        cost(p,4) = 100000*(glo_stress_period-size(head_data,1));
    else
               % Calculate Energy cost
              
                hft = repmat(top,1,1,23) - temp_head; % hft: head from top

                const = 9.8 /0.75 * 0.26; % constant = gamma / efficiency * unit cost
                energy_cost = zeros([numel(t_diff) 1]);
                for steps = 1:numel(t_diff)
                    temp_hft = hft(:,:,steps);
                        for communes = 1:size(index_wells,1)
                            % constant * Head Difference * Required Discharge
                            temp_hft_well = temp_hft(well_position_mat(index_wells(communes,:)));
                            temp_hft_well = temp_hft_well(temp_hft_well<80); 
                           energy_cost(steps) = energy_cost(steps) + abs(const*sum(temp_hft_well)*x(p,communes)*t_diff(steps));     
                        end

                end
                total_energy_cost = sum(energy_cost)/4.67;  % 4.67 years in the total simulation time
        
                %calculate food production
                
                food_poly = zeros([numel(conc_value) 1]);
                fel_val = x(p,(well_groups+1):end);
                for poly = 1:numel(fel_val)
                    
                    ids = crop_data.polygon == poly;
                    temp_data = crop_data(ids,:);
                   
                    
                    temp_npk =     [ temp_data.max_yield.*(1-temp_data.b_nut.*exp(-temp_data.c_N*fel_val(poly))), ...
                                    temp_data.max_yield.*(1-temp_data.b_nut.*exp(-temp_data.c_P2O5*fel_val(poly))), ...
                                    temp_data.max_yield.*(1-temp_data.b_K2O.*exp(-temp_data.c_K2O*fel_val(poly))) ];
                    temp_food = min(temp_npk, [] ,2);
                    
                    food_poly(poly) = sum(temp_food.*temp_data.Area);
                    
               
                end
                
                
        % Energy consumed to be minimized
        cost(p,1) = total_energy_cost;
        
        % discharge -> negative, (maximization)
        cost(p,2) = total_discharge;    % total_discharge
        
        % total area contaminated to be minimized so positive
        cost(p,3) = affected_area*250*250;
        
        % total food to be maximized
        cost(p,4) = -1*sum(food_poly)*1000; %converting tonnes to kg
        
        
        % add constraints to drawdown
        
        dd = drawdown(well_position_mat);
        dd_threshold = 2;
        index = dd>dd_threshold;
        dd_distance = sqrt(sum((dd(index)-dd_threshold).^2));
        % drawndown should not be greater than 2.
        % decreasing the magnitude as penalty
        cost(p,1) = cost(p,1) + cp*dd_distance*1e4 ; 
        cost(p,2) = cost(p,2) + cp*dd_distance ;
        cost(p,3) = cost(p,3) + cp*dd_distance*100;
        cost(p,4) = cost(p,4) + cp*dd_distance ;
        d(p) = dd_distance;
        
        
        % only valid solutions without penalty are recorded in the
        % variable all_cost
        
        %%%%%%%%%%% R-A exchanges %%%%%%%%%%%%%%%%%%%
        cd(['.\'  filename  '_MODFLOW']);
        temp2 = reading_ccf();
        cd('.\..');
        temp2 = temp2{7,glo_stress_period*8};
        total_leakage_out = sum(temp2(temp2(:)<0));
        total_leakage_in = sum(temp2(temp2(:)>0));
        ids = temp2~=0;
        
        % leakage out is negative and is needed to be maximised
        ra(p,1) = total_leakage_out;
        ra(p,2) = total_leakage_in;
        temp2 = conc_data(:,:,end);
        ra(p,3) = sum(sum(temp2(ids)));
        
    end
    
    
end

end

gen_wise_data{end+1,1} = {x};
gen_wise_data{end,2} = {cost};
gen_wise_data{end,3} = {d};
gen_wise_data{end,4} = {ra};


all_cost = vertcat(all_cost,[cost d x ra]);
end