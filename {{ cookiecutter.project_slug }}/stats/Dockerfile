FROM perl:5.26

LABEL maintainer="{{ cookiecutter.full_name }} {{ cookiecutter.email}}"

RUN apt-get update && apt-get -y install cron

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/awstats

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/awstats

ADD https://github.com/eldy/awstats/archive/7.7.tar.gz /usr/src/awstats/awstats.tar.gz
WORKDIR /usr/src/awstats/
# extracts into a awstats-7.7/ dir
RUN tar -xzf awstats.tar.gz
RUN mkdir -p /usr/run/stats/www/
RUN cp -r awstats-7.7/wwwroot/icon /usr/run/stats/www/

# Create the data dir which will probably be replaced by a volume
RUN mkdir -p /usr/run/stats/data/

# Add the conf
COPY awstats.{{ cookiecutter.site_domain }}.conf /etc/awstats/

CMD ["cron", "-f"]
