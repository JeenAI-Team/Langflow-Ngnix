FROM openresty/openresty:1.25.3.1-alpine

# "opm" requires perl to run; install it first
RUN apk add --no-cache perl curl \
    && opm get SkyLothar/lua-resty-jwt

# Copy configuration and Lua access script
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY jwt.lua /usr/local/openresty/nginx/lua/jwt.lua

# Expose HTTP (will typically be front-ended by TLS elsewhere)
EXPOSE 80

ENTRYPOINT ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"] 