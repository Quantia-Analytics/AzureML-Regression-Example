# -*- coding: utf-8 -*-
"""
Created on Thu Oct 08 13:56:44 2015

@author: Steve Elston

Code to create a simple linear model for testing purposes.
"""

def azureml_main(BikeShare):
    from sklearn import linear_model
    import pandas as pd
    
    cols = ['temp', 'hum', 'xformWorkHr', 'dayCount', 'mnth']
    X = BikeShare[cols].as_matrix()
    Y = BikeShare['cnt'].as_matrix()
    ## Compute the linear model.
    clf = linear_model.LinearRegression()
    bike_lm = clf.fit(X, Y)
    
    coef_names = ['intercept'] + cols
    
    ## Build a DataFrame to output the coeficients    
    lm_co = []
    lm_co.append(bike_lm.intercept_)
    for val in list(bike_lm.coef_): lm_co.append(val)
    
    coefs = pd.DataFrame({'coef_names' : coef_names,
                          'coefs' : lm_co}
    )
    
    return coefs
