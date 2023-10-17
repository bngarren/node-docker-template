FROM node:19 as base
ENV NPM_CONFIG_LOGLEVEL warn

RUN apt-get update

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json into the directory
COPY package*.json ./
# Install global dependencies
RUN npm install -g dotenv-cli
# Install only production dependencies
RUN npm ci --omit=dev

### Development TARGET ### i.e. includes dev dependencies
FROM base as development
WORKDIR /app

ENV NODE_ENV development

# Install dev dependencies
RUN npm install -D

# Copy entrypoint and make it executable
COPY entrypoint.development.docker.sh ./
RUN chmod +x entrypoint.development.docker.sh

COPY . .

EXPOSE 2025
