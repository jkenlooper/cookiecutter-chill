FROM certbot/certbot:v0.24.0

# Override the certbot entrypoint so cron can run in fg
ENTRYPOINT [""]

# Cron job to auto renew certs every month
ADD crontab /etc/crontabs/certbot

# Give execution rights on the cron job
RUN chmod 0644 /etc/crontabs/certbot

CMD ["crond", "-f"]
