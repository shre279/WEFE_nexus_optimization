
%% SMOOTH WALE SE KAAM CHAL JANA CHAHIYE
clear all;
load('gen_wise_data_mopso.mat');

bounds = [-0.6e5 -0.8e5 -0.6e5 -0.8e5];
for i = 1:200
    temp2 = gen_wise_data{i,2};
    temp(i) = hypeIndicatorExact8(-temp2{:}, bounds,4);
    
    
end

figure(1);semilogy(1:numel(temp),temp);
figure(2); plot(temp);
temp3 = smoothdata(temp,'gaussian',20);
temp4 = smoothdata(temp,'gaussian',30);
temp5 = smoothdata(temp,'gaussian',50);

figure(3);subplot(3,1,1); plot(temp3); title('Window:20');
figure(3); subplot(3,1,2); plot(temp4); title('Window:30');
figure(3); subplot(3,1,3); plot(temp5); title('Window:50');
figure(3); sgtitle('Smoothed Hypervolume data');