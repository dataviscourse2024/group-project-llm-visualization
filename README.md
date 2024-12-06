# llm-visualization

Members : \
Jake Wagoner; u6048387;  jakew@sci.utah.edu \
Sudhanva Manjunath Athreya; u1529299; u1529299@utah.edu \
Tin Vo; u1289616; u1289616@utah.edu

Install [Docker](https://www.docker.com/products/docker-desktop/) execute the following commands. 


## Overview

Frontend is made using Vue and Vuetify for some styling of common components, along with D3. Vite was used for building/running the frontend.

The geojson used for the map was obtained from here: https://gist.github.com/tomshanley/a006f9c6c4b30835137ead7574a51d17#file-utah-districts-geojson

The code in the /web folder is some setup code from Vue/Vuetify and mostly our code.

The code in the /web/components are basically all the components that can be seen on a browser when the project is ran.

The code in the /api folder is our code (using fastapi) which pulls earthquake data from the website given below.

View the screencast here: https://www.youtube.com/watch?v=SErroFogMmk


## Data

An API is used to grab data from: https://earthquake.usgs.gov/earthquakes/map/

The range of the data is taken by drawing a rectangle around Utah on the map.


## Disclaimer 

Peak Performance can be achieved on an M1 mac or newer, or a GPU workstation. 
Read more here : [ggml](https://github.com/ggerganov/ggml)

Provide exec rights to ```script.sh``` which is present in the ```api``` directory

Executing ```script.sh``` should start the LLM. The interactions with the LLM will be handled by the API.  


## API Setup
```
cd api 
docker build -t viz_api .
docker run -d --name api_container -p 80:80 viz_api 
```

## FrontEnd Setup
```
cd web 
docker build -t viz_ui .
docker run -d --name ui_container -p 5173:5173 viz_ui  
```

Open [http://localhost:5173/](http://localhost:5173/) once both the containers are up. 
