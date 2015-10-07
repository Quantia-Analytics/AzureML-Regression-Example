# -*- coding: utf-8 -*-
"""
Created on Tue Jul 21 12:49:06 2015

@author: Steve Elston
"""


## The main function with a single argument, a Pandas data frame
## from the first input port of the Execute Python Script module.    
def azureml_main(BikeShare):
    import pandas as pd
    from sklearn import preprocessing
    import utilities as ut
    import numpy as np
    import os
 
## If not in the Azure environment, read the data from a csv 
## file for testing purposes.    
    Azure = False  
    if(Azure == False):
        pathName = "C:/Users/Steve/GIT/Quantia-Analytics/AzureML-Regression-Example/Python files"
        fileName = "BikeSharing.csv"
        filePath = os.path.join(pathName, fileName)
        BikeShare = pd.read_csv(filePath)
        
    ## Drop the columns we do not need    
    BikeShare = BikeShare.drop(['instant',
                          'instant',
                          'atemp',
                          'casual',
                          'registered'], 1)  
                          
    ## Normalize the numeric columns
    scale_cols = ['temp', 'hum', 'windspeed']
    arry = BikeShare[scale_cols].as_matrix()
    BikeShare[scale_cols] = preprocessing.scale(arry)                      
                          
    ## Create a new column to indicate if the day is a working day or not.
    work_day = BikeShare['workingday'].as_matrix()
    holiday = BikeShare['holiday'].as_matrix()                       
    BikeShare['isWorking'] = np.where(np.logical_and(work_day == 1, holiday == 0), 1, 0)
    
    ## Compute a new column with the count of months from
    ## the start of the series which can be used to model 
    ## trend
    BikeShare['monthCount'] = ut.mnth_cnt(BikeShare)
    
    ## Shift the order of the hour variable so that it is smoothly
    ## "humped over 24 hours.## Add a column of the count of months which could 
    hr = BikeShare.hr.as_matrix()
    BikeShare['xformHr'] = np.where(hr > 4, hr - 5, hr + 19)

    ## Add a variable with unique values for time of day for working 
    ## and non-working days.
    isWorking = BikeShare['isWorking'].as_matrix()
    BikeShare['xformWorkHr'] = np.where(isWorking, 
                                        BikeShare.xformHr, 
                                        BikeShare.xformHr + 24)
                                        
    BikeShare['dayCount'] = pd.Series(range(BikeShare.shape[0]))/24
                                       
        
    return BikeShare 