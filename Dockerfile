FROM node:18-alpine

WORKDIR /app

# Install build tools (VERY IMPORTANT for Strapi)
RUN apk add --no-cache python3 make g++ git

# Copy only package files first (better caching)
COPY package.json package-lock.json ./

# Clean install (safer than npm install)
RUN npm cache clean --force
RUN npm install --legacy-peer-deps

# Copy source code
COPY . .

# Build Strapi admin panel
RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
