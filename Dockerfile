FROM node:18-alpine as build-stage

RUN apk add --no-cache git

WORKDIR /app

RUN git clone https://github.com/haxzie/snipp.in /app && cd /app
# Create app directory
COPY . /app

#COPY package*.json ./


# Install app dependencies
RUN npm install

# build app for production with minification
RUN npm run build

# Bundle app source
COPY . .


# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


