# -*- coding: utf-8 -*-
"""
Created on Wed Oct 07 09:51:37 2015

@author: Steve Elston

This file contains a funciton for filtering outliers
from the bike rental data. Lower quantiles are computed
based on the month of the year and the working hour 
(0-47 hour) for the day. Values less than this quantile
are filtered from the dataset. 
"""

def azureml_main(BikeShare):
    import pandas as pd
    
    ## Save the original names of the DataFrame.
    in_names = list(BikeShare)
    
    ## Compute the lower quantile of the number of biked grouped by
    ## Date and time values. 
    quantiles = BikeShare.groupby(['yr', 'mnth', 'xformWorkHr']).cnt.quantile(q = 0.2)
    
    ## Join (merge) quantiles as a DataFrame to BikeShare
    quantiles = pd.DataFrame(quantiles)
    BikeShare = pd.merge(BikeShare, quantiles,
                     left_on = ['yr', 'mnth', 'xformWorkHr'], 
                     right_index = True,
                     how = 'inner')   
    
    ## Filter rows where the count of bikes is less than the lower quantile.                                         
    BikeShare = BikeShare.ix[BikeShare.cnt_x > BikeShare.cnt_y]      

    ## Remove the unneeded column and restore the original column names. 
    BikeShare.drop('cnt_y', axis = 1, inplace = True)
    BikeShare.columns = in_names       
    
    return BikeShare
