# -*- coding: utf-8 -*-
"""
Created on Thu Oct 08 14:57:25 2015

@author: Steve Elston

This code computes scores (perdictions) for a scikit-learn
linear model using a DataFrame contianing the intercept and
coeficients.
"""

def azureml_main(BikeShare, coefs):
#    import pandas as pd
    import numpy as np
        
    arr1 = BikeShare[coefs.iloc[1:, 0]].as_matrix()
    arr2 = coefs.iloc[1:, 1].as_matrix()   
    
    BikeShare['Scored Labels'] = np.dot(arr1, arr2) + coefs.iloc[0, 1]
    
    return BikeShare

