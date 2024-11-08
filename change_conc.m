%% Changes the initial concentration of the leachate
function change_conc(conc_values)

global filename;
cd([filename  '_MT3DMS'])
btn = readBTN;      % data of basic transport package.
ssm = readSSM([],btn); % data of sink source mixing package

data = ssm.values;

temp = data{1}; % lay row col leachate
temp = temp(:,2);
index = zeros(1,numel(temp));

index(temp>28 & temp < 34) = 1;
index(temp>34 & temp<40) = 2;
index(temp>121 & temp<129) = 3;
index(temp>140 & temp<143) = 4;

%% Read original and write modified SSM


fname1 = [filename '.ssm'];


fname2 = [filename '_temp.ssm'];

% if ~exist(fname2, 'file')==2
% 
% 
% end


fid1 = fopen(fname1,'rt');
fid2 = fopen(fname2,'w');

% logical vals
s=fgetl(fid1);
fprintf(fid2,'%s\n',s);

% mxss
s = fscanf(fid1,'%d',1);
fprintf(fid2,'%10d\n',s);
fgets(fid1);

% get 4 lines of logical values
s=fgetl(fid1);
fprintf(fid2,'%s\n',s);

s=fgetl(fid1);
fprintf(fid2,'%s\n',s);

s=fgetl(fid1);
fprintf(fid2,'%s\n',s);

s=fgetl(fid1);
fprintf(fid2,'%s\n',s);
num_sources = fscanf(fid1,'%d',1);
 
% write the leachate point data as per the provided format
for i = 1:btn.NPER
    
    fprintf(fid2,'%s',sprintf('%10d\n',num_sources));
    temp = data{1};
    temp(index==1,4) = conc_values(1);  temp(index==1,6) = conc_values(1);
    temp(index==2,4) = conc_values(2);  temp(index==2,6) = conc_values(2);
    temp(index==3,4) = conc_values(3);  temp(index==3,6) = conc_values(3);
    temp(index==4,4) = conc_values(4);  temp(index==4,6) = conc_values(4);
    formatSpec = '%10d%10d%10d%10.5f%10d%10.5f\n';
    temp2 = sprintf(formatSpec,temp');
    fprintf(fid2,'%s',temp2);
    fprintf(fid2,'%s',sprintf('%10d\n',-1));
    fprintf(fid2,'%s',sprintf('%10d\n',-1));
    
end

fclose(fid1);
fclose(fid2);

delete(fname1);
system("rename " + '"' + string(fname2) + '" "' + string(fname1) + '"');

cd('.\..')   
end