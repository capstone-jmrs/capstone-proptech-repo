# Market and location analysis for a proptech company
Capstone project for the data analytics bootcamp at [neuefische](https://www.neuefische.de/). This project was developed in four weeks during September and October 2022 by Ruben Prinz ([Github](https://github.com/burned-py)), Julia Rupp ([Linkedin](https://www.linkedin.com/in/juliarupp1987/), [Github](https://github.com/juliarupp)) and Markus Steinke ([Linkedin](https://www.linkedin.com/in/markus-steinke001/), [Github](https://github.com/neovegeto)).

## Overview

Ukio is a spain based company that’s on the mission to empower individuals to live where they want and when they want. As a product, they offer fully furnished premium apartments in prime locations within major metropolitan cities. One major European city Ukio has taken into focus as one of their possible next stops is London.

## Scope
Ukio delivered nine prime neighbourhoods in London and three different platforms which are our data sources. 

#### Neighbourhoods:
- Camden
- City of London
- City of Westminster
- Hackney 
- Hammersmith and Fulham
- Islington
- Kensington and Chelsea
- Lambrth
- Tower Hamlets

#### Data sources:
- [Blueground](https://www.theblueground.com/)
- [Spotahome](https://www.spotahome.com/)
- [Rightmove](https://www.rightmove.co.uk/)

## Goal 
The goal was to explore the question: Should Ukio go to London?

## Data
Since there is no available data to download or APIs to use for our case, we scraped the data from the platforms ourself.
For this we wrote python code using the python package BeautifulSoup.
Our main focus was information about the rental offers:
- the property type e.g. Studios and Apartments
- the rental price
- the size of the property
- the number of bedrooms
- the date when the offer is available

## Notebooks
Every platform works different so the goal was to have one notebook for each platform that performs the scraping with python, cleaning with python and sql and analysis with one run.
- Blueground: name.ipynb
- Spotahome: name.ipynb
- Rightmove: name.ipynb

After that the tables are combined and provided for the visualization with tableau: platforms_complete.twb
