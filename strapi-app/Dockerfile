FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache python3 make g++ git

# Copy only package.json (since lock file may not exist)
COPY package.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy rest of project
COPY . .

RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
