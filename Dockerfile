FROM node:18-alpine

WORKDIR /app

# Install required build tools
RUN apk add --no-cache python3 make g++ git

COPY package*.json ./

# Install ALL dependencies (Important for Strapi build)
RUN npm install

COPY . .

# Build Strapi admin panel
RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
