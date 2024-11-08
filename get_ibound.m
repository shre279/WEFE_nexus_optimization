%.......................Reading ibound data....................%
function ibound = get_ibound()

global glo_n_layers;
global filename;
global max_row;
global max_col;
global top;


f_name = [filename '.h5'];
cd(['.\'  filename  '_MODFLOW']);


for i = 1:glo_n_layers
    path = ['///Arrays/ibound' num2str(i)];
    a = h5read(f_name,path);
    ibound(:,:,i) = reshape(a,[max_col max_row])';
    top(:,:,i) =  reshape(h5read([filename '.h5'],'//Arrays/top1'),[max_col max_row])';

end

cell_id = h5read([filename '.h5'],'/Stream/02. Cell IDs');
map_temp = int32(zeros([max_col max_row]));
map_temp(cell_id) = 1;
ibound(:,:,1) = ibound(:,:,1) + map_temp';
cd('.\..');
end



%%
% b = reshape(ibound(:,1),[360 272]);
% imagesc(b');
