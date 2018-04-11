FROM nginx:1.12.2-alpine

ARG conf

# Replace the default.conf
COPY $conf /etc/nginx/conf.d/default.conf

# Used by stats
COPY .htpasswd /www/.htpasswd
