# -*- coding: utf-8 -*-
"""
Created on Sat Oct 10 17:28:01 2015

@author: Steve Elston

Code for visualization of the residuals (errors) of the 
regression model.
"""

def azureml_main(BikeShare):
    import matplotlib
    matplotlib.use('agg')  # Set backend
    matplotlib.rcParams.update({'font.size': 20})
    
    import matplotlib.pyplot as plt
    import statsmodels.api as sm
    
    Azure = False

## Compute the residuals.
    BikeShare['Resids'] = BikeShare['Scored Label Mean'] - BikeShare['cnt']   
    
## Plot the residuals vs the label, the count of rented bikes.
    fig = plt.figure(figsize=(8, 6))
    fig.clf()
    ax = fig.gca()
## PLot the residuals.    
    BikeShare.plot(kind = 'scatter', x = 'dayCount', y = 'Resids', 
                   alpha = 0.05, color = 'red', ax = ax)              
    plt.xlabel("Days from start")
    plt.ylabel("Residual")
    plt.title("Residuals vs time")
    plt.show()
    if(Azure == True): fig.savefig('scatter1.png')
    

## Make time series plots of actual bike demand and 
## predicted demand by times of the day.    
    times = [7, 9, 12, 15, 18, 20, 22]
    for tm in times:
        fig = plt.figure(figsize=(8, 6))
        fig.clf()
        ax = fig.gca()
        BikeShare[BikeShare.hr == tm].plot(kind = 'line', 
                                           x = 'dayCount', y = 'cnt',
                                           ax = ax)          
        BikeShare[BikeShare.hr == tm].plot(kind = 'line', 
                                           x = 'dayCount', y = 'Scored Label Mean',
                                           color = 'red', ax = ax)                                    
        plt.xlabel("Days from start of plot")
        plt.ylabel("Count of bikes rented")
        plt.title("Bikes rented by days for hour = " + str(tm))
        plt.show()
        if(Azure == True): fig.savefig('tsplot' + str(tm) + '.png')
 
## Boxplots to for the residuals by hour and transformed hour.
    labels = ["Box plots of residuals by hour of the day \n\n",
            "Box plots of residuals by transformed hour of the day \n\n"]
    xAxes = ["hr", "xformWorkHr"]
    for lab, xaxs in zip(labels, xAxes):
        fig = plt.figure(figsize=(12, 6))
        fig.clf()
        ax = fig.gca()  
        BikeShare.boxplot(column = ['Resids'], by = [xaxs], ax = ax)   
        plt.xlabel('')
        plt.ylabel('Residuals')
        plt.show() 
        if(Azure == True): fig.savefig('boxplot' + xaxs + '.png')
     
## QQ Normal plot of residuals    
    fig = plt.figure(figsize = (6,6))
    fig.clf()
    ax = fig.gca()
    sm.qqplot(BikeShare['Resids'], ax = ax)
    ax.set_title('QQ Normal plot of residuals')
    if(Azure == True): fig.savefig('QQ.png')
    if(Azure == True): fig.savefig('QQ1.png')

## Histograms of the residuals
    fig = plt.figure(figsize = (8,6))
    fig.clf()
    fig.clf()
    ax = fig.gca()
    ax.hist(BikeShare['Resids'].as_matrix(), bins = 40)
    ax.set_xlabel("Residuals")
    ax.set_ylabel("Density")
    ax.set_title("Histogram of residuals")
    if(Azure == True): fig.savefig('hist.png')   

    return BikeShare    


