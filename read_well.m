%.......................Reading well data....................%
function well_data = read_well()
global filename;

file_name = [filename '.h5'];
well_data.discharge = [];
well_data.cell_id = [];
well_data.other_properties = [];
well_data.map_id = [];
temp = h5read(file_name,'///Well/07. Property');
well_data.discharge = temp(:,:,1);
well_data.other_properties = temp(:,:,2:3);
well_data.cell_id = h5read(file_name,'///Well/02. Cell IDs');
well_data.map_id =  h5read(file_name,'///Well/04. Map ID');

end


% col = mod(cell_id-1,100);
% row = 100 - (cell_id-col)/100 - 1;
% row = 100 - row;