function run_mt3dms()

global filename;
cd([filename  '_MT3DMS'])

f_name = [filename '.mts' ];
%system(sprintf('MT3D-USGS_64.exe "%s" ', f_name));
[s,t ] = system(sprintf('mt3dms53.exe "%s \n" ', f_name));
cd('.\..')
end