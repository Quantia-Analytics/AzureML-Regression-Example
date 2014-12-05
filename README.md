Azure Machine Learning-Regression-Example
==========================

This repo contains all the code and data necessary to explore non-linear regression using Microsoft's Azure Machine Learning cloud service.

The .R files contain code to explore the data set, create a number of types of models and evaluate the performance of these models. Both built in Azure ML models and R models. 

The data set can be found in Azure ML Studio as an example, or you can load it from the .csv file provided here.  The reference for these data is; Fanaee-T, Hadi, and Gama, Joao, 'Event labeling combining ensemble detectors and background knowledge', Progress in Artificial Intelligence (2013): pp. 1-15, Springer Berlin Heidelberg.

## Background

If you are not familiar with using R with Azure ML you might want to first ready my [Quick Start Guide to R in Azure ML Studio](http://azure.microsoft.com/en-gb/documentation/articles/machine-learning-r-quickstart). The code is available in this [Git repo](https://github.com/Quantia-Analytics/AzureML-R-Quick-Start).

Companion videos are available:

* [Using R in Azure ML](https://www.youtube.com/watch?v=G0r6v2k49ys). 
* [Time series model with R in Azure ML](https://www.youtube.com/watch?v=q-PJ3p5C0kY).

You can find a Git repo containing all of the code for the Quick Start Guide [here](https://github.com/Quantia-Analytics/AzureML-R-Quick-Start)

## R object serialization

This example uses serialization and unserialization of R model objects. You can find my tutorial on serialization and unserialization of R objects for Azure ML [here](https://github.com/Quantia-Analytics/AzureML-R-Serialization)
.