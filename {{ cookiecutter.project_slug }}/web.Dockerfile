FROM nginx:1.12.2-alpine

ARG conf

# Replace the default.conf
COPY $conf /etc/nginx/conf.d/default.conf

COPY web/snippets /etc/nginx/snippets

# Used by stats
COPY .htpasswd /www/.htpasswd
