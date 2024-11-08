%......................Writing well data.......................%
function write_well(well_data)

global filename;

 file_name = [filename '.h5' ];
 
temp = [];
 
 temp(:,:,1) = well_data.discharge;
 
 temp(:,:,2:3) = well_data.other_properties;

 h5write(file_name,'///Well/07. Property',temp);
 h5write(file_name,'///Well/02. Cell IDs', well_data.cell_id);
 h5write(file_name,'///Well/04. Map ID',well_data.map_id);

end