FROM node:23.3.0-bullseye
WORKDIR /app
COPY yarn.lock package.json ./
RUN yarn install
COPY . .
EXPOSE 5173
CMD ["yarn","run","dev", "--host"] 



