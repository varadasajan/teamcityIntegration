# Stage 1: Build the React application
FROM node:14 as build

WORKDIR /app

# Copy package.json and package-lock.json (if using npm)
# or yarn.lock (if using yarn) to install dependencies.
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the production-ready React app
RUN npm run build

# Stage 2: Serve the React application with Nginx
FROM nginx:alpine

# Remove the default Nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the built React app from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy a custom nginx.conf if needed (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose the container's port, default for Nginx is 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
