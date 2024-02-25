# Use the official Node.js image as the base image
FROM node:20.11.0-alpine as build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the entire project to the container
COPY . .

# Build the Angular app for production
RUN npm run build:prod

# Use a smaller, production-ready image as the final image
FROM nginx:alpine

# Copy the production-ready Angular app to the Nginx webserver's root directory
COPY --from=build /app/dist/tutorial-app/browser /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]