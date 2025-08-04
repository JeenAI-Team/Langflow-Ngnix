FROM openresty/openresty:1.25.3.1-alpine

# Update packages, install required tools, and install Lua JWT lib
RUN apk update && \
    apk upgrade && \
    apk add --no-cache perl curl aom-libs && \
    opm get SkyLothar/lua-resty-jwt

# Optionally remove libavif if it's vulnerable and installed
RUN apk del libavif || true

# Create necessary directories and fix permissions for OpenShift
RUN mkdir -p /usr/local/openresty/nginx/client_body_temp \
             /usr/local/openresty/nginx/proxy_temp \
             /usr/local/openresty/nginx/fastcgi_temp \
             /usr/local/openresty/nginx/uwsgi_temp \
             /usr/local/openresty/nginx/scgi_temp \
             /var/log/nginx \
             /var/run/openresty && \
    # Fix permissions for OpenShift-style random UID
    chgrp -R 0 /usr/local/openresty /var/log/nginx /var/run/openresty && \
    chmod -R g=u /usr/local/openresty /var/log/nginx /var/run/openresty && \
    chmod -R g+rwX /usr/local/openresty /var/log/nginx /var/run/openresty

# Copy configuration and Lua JWT handler
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY jwt.lua /usr/local/openresty/nginx/lua/jwt.lua

# Expose HTTP on port 8080 (OpenShift-friendly)
EXPOSE 7860

# Use non-root user ID that OpenShift expects
USER 1001

ENTRYPOINT ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]




# FROM openresty/openresty:1.25.3.1-alpine

# # Update packages, install required tools, and install Lua JWT lib
# RUN apk update && \
#     apk upgrade && \
#     apk add --no-cache perl curl aom-libs && \
#     opm get SkyLothar/lua-resty-jwt

# # Optionally remove libavif if it's vulnerable and installed
# RUN apk del libavif || true

# # Copy configuration and Lua JWT handler
# COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
# COPY jwt.lua /usr/local/openresty/nginx/lua/jwt.lua

# # Expose HTTP (typically front-ended by TLS)
# EXPOSE 80

# ENTRYPOINT ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]



#--------


# FROM openresty/openresty:1.25.3.1-alpine

# # "opm" requires perl to run; install it first
# RUN apk add --no-cache perl curl && \
#     opm get SkyLothar/lua-resty-jwt && \
#     apk upgrade aom-libs || true
    
# # Copy configuration and Lua access script
# COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
# COPY jwt.lua /usr/local/openresty/nginx/lua/jwt.lua

# # Expose HTTP (will typically be front-ended by TLS elsewhere)
# EXPOSE 80

# ENTRYPOINT ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"] 