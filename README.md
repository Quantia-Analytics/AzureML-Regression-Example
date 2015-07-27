Azure Machine Learning-Regression-Example
==========================

This repo contains all the code and data necessary to explore non-linear regression using Microsoft's Azure Machine Learning cloud service. You can view a webcast discussing this discussion of this experiment in the O'Reilly Media [webcast](http://www.oreilly.com/pub/e/3292). the companion O'Reilly media report [here](http://radar.oreilly.com/2015/01/getting-started-with-data-science-in-the-cloud.html).

The .R files contain code to explore the data set, create a number of types of models and evaluate the performance of these models. Both built in Azure ML models and R models. 

The data set can be found in Azure ML Studio, or you can load it from the .csv file provided.  Reference for these data is; Fanaee-T, Hadi, and Gama, Joao, 'Event labeling combining ensemble detectors and background knowledge', Progress in Artificial Intelligence (2013): pp. 1-15, Springer Berlin Heidelberg.

## Background

If you are unfamiliar with using R with Azure ML first read my [Quick Start Guide to R in Azure ML Studio](http://azure.microsoft.com/en-gb/documentation/articles/machine-learning-r-quickstart). The code is available in this [Git repo](https://github.com/Quantia-Analytics/AzureML-R-Quick-Start).

Companion videos are available:

* [Using R in Azure ML](https://www.youtube.com/watch?v=G0r6v2k49ys). 
* [Time series model with R in Azure ML](https://www.youtube.com/watch?v=q-PJ3p5C0kY).

There is a [Git repo](https://github.com/Quantia-Analytics/AzureML-R-Quick-Start) containing all of the code for the Quick Start Guide.

## R object serialization

This example uses serialization and unserialization of R model objects. My tutorial and code for serialization and unserialization of R objects in Azure ML is [here](https://github.com/Quantia-Analytics/AzureML-R-Serialization)
. There is a companion video available on [YouTube](https://www.youtube.com/watch?v=vk9Ic1F9YTk&feature=youtu.be).