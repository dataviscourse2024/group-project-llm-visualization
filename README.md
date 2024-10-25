# llm-visualization

Members : \
Jake Wagoner; u6048387;  jakew@sci.utah.edu \
Sudhanva Manjunath Athreya; u1529299; u1529299@utah.edu \
Tin Vo; u1289616; u1289616@utah.edu

Install [Docker](https://www.docker.com/products/docker-desktop/) execute the following commands. \

## API Setup
```
cd api 
docker build -t viz_api .
docker run -d --name api_container -p 80:80 viz_api 
```

## FrontEnd Setup
```
cd web 
npm install -g yarn 
yarn install 
yarn dev 
```
