load('mopso_all_data1.mat')
temp_sum = sum(index_wells);
temp_index_wells = index_wells(:,setdiff(1:376,find(temp_sum==0)));
imagesc(glo_ibound);
daspect([1 1 1]);
hold on;
% for i = 1: size(index_wells,1)
 temp_index = temp_index_wells(10,:); 
 scatter(cell_col(temp_index),cell_row(temp_index),'filled');
 pause(2);
% end
temp_name = string(1:31);
size(temp_name)
temp_name = "well " + temp_name;
temp_nums = double(well_nums);
temp_nums = sort(temp_nums);
temp_well_nums = string(temp_nums);
legend(temp_name);
pause(2);

% for i = 1: size(index_wells,1)
%  temp_index = temp_index_wells(1,:); 
%  scatter(cell_col(temp_index),cell_row(temp_index),'kO');
% %  title(['highlighted zone:' temp_well_nums(i)]);
%  pause(2);
% end

  
%  temp = h5read([filename '.h5'],'///Well/07. Property');
% arcs = size(temp,2) -  size(index_wells,2);