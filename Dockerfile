FROM node:18

WORKDIR /app

COPY strapi-app/package*.json ./

RUN npm install

COPY strapi-app .

EXPOSE 1337

CMD ["npm","run","develop"]