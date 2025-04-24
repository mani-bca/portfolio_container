# # Use the official Nginx image as the base image
# FROM nginx:alpine

# # Set the working directory inside the container
# WORKDIR /usr/share/nginx/html

# # Copy the HTML and CSS files to the working directory
# COPY . .

# # Expose port 80 for the web server
# EXPOSE 80

# # Start Nginx when the container runs
# CMD ["nginx", "-g", "daemon off;"]


# Use Alpine-based Nginx for a smaller footprint
FROM nginx:stable-alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Create a non-root user to run the application
RUN addgroup -g 1000 appuser && \
    adduser -u 1000 -G appuser -h /usr/share/nginx/html -D appuser && \
    chown -R appuser:appuser /usr/share/nginx/html

# Copy static files to the working directory
COPY --chown=appuser:appuser . .

# Set permissions
RUN chmod -R 755 /usr/share/nginx/html && \
    # Fix nginx permissions requirements
    chown -R appuser:appuser /var/cache/nginx && \
    chown -R appuser:appuser /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appuser /var/run/nginx.pid

# Add healthcheck to verify the service is running
HEALTHCHECK --interval=30s --timeout=3s CMD wget -q -O /dev/null http://localhost/ || exit 1

# Expose port 80
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]