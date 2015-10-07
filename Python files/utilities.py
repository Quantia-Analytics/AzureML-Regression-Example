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
    
def set_day(df):
    '''
    This function assigns day names to each of the 
    rows in the data set. The function needs to account
    for the fact that some days are missing and there 
    may be some missing hours as well.
    '''  
    ## Assumes the first day of the data set is Saturday
    days = ["Sat", "Sun", "Mon", "Tue", "Wed", 
            "Thr", "Fri"]
    temp = ['d']*df.shape[0]  
    i = 0   
    indx = 0
    cur_day = df.dteday[0]    
    for day in df.dteday:
        if(cur_day != day): 
            cur_day = day
#            i = lambda i: retun 0 if i == 6 else retun i + 1
            if(i == 6): i = 0
            else: i += 1 
        temp[indx] = days[i]
        indx += 1
    df['dayWeek'] = temp
    return df        
        
        
    