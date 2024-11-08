Run main_mopso for the optimization process
the MODFLOW and MT3DMS model folder should be added in the code get_cost_pop.m as well as defined as the global vairable in main_mopso.m
"well_zone_upper_lower.csv" is the csv file of the decision variables. You may change accordingly.
post processing is the nondominated sorting of the obtained solutions.
THe plots generated in the paper are made through Plotly library in python
rest of the code is self explanatory. 
