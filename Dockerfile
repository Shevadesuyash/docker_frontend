# Stage 1: Build the frontend application
FROM node:14.17.0-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the frontend with Nginx
FROM nginx:1.21.6-alpine

# Remove the default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the built frontend from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
