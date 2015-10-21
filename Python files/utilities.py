# -*- coding: utf-8 -*-
"""
Created on Mon Sep 07 18:34:24 2015

@author: Steve
"""

def mnth_cnt(df):
    '''
    Compute the count of months from the start of the time series. 
    '''
    import itertools
    yr = df['yr'].tolist()
    mnth = df['mnth'].tolist()
    out = [0] * df.shape[0]
    indx = 0
    for x, y in itertools.izip(mnth, yr):
        out[indx] =  x + 12 * y
        indx += 1
    return out
    
