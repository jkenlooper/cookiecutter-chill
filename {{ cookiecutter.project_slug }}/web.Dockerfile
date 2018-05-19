FROM nginx:1.12.2-alpine

ARG conf

# Replace the default.conf
COPY $conf /etc/nginx/conf.d/default.conf

COPY web/snippets /etc/nginx/snippets

# Copy the generated certs
COPY web/server.crt /etc/nginx/ssl/server.crt
COPY web/server.key /etc/nginx/ssl/server.key
COPY web/dhparam.pem /etc/nginx/ssl/dhparam.pem

# Used by stats
COPY .htpasswd /www/.htpasswd
