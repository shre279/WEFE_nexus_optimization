load('gen_wise_data_mopso.mat');
for i = 1:size(gen_wise_data,1)
    
    temp = gen_wise_data{i,2}{1,1};
    scatter(-temp(:,2),-temp(:,1),'r','filled','MarkerFaceAlpha',tanh(i/5000));
    pause(0.01);
    hold on;
    
    
end