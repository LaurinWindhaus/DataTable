# Stage 1: Build the React app with Vite
FROM node:20-alpine AS builder
ENV NODE_ENV development  # Change to development to install devDependencies

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json to the working directory
COPY ./package*.json ./

# Install both dependencies and devDependencies
RUN npm install

# Copy the remaining application files to the working directory
COPY . .

# Build the app with Vite
RUN npm run build

# Stage 2: Serve the app with Nginx
FROM nginx:1.21.0-alpine as production
ENV NODE_ENV production

# Copy the built assets from the 'dist' directory of the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Add your custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
