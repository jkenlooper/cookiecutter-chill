FROM ubuntu:16.04 as media

RUN apt-get update && apt-get --yes install imagemagick

# TODO optimize and resize images
COPY ./source-media/ /usr/media/
WORKDIR /usr/media/

# TODO npm run build and create the dist

FROM chill as chill

#COPY --from=media /usr/media/ /usr/run/media/

# TODO: copy compiled dist to /usr/run/dist/

COPY . /usr/run/
WORKDIR /usr/run/

# Remove and recreate the db from the db.dump.sql.  When freezing the site the
# db from the context shouldn't be used.  The db.dump.sql is the single source
# of truth here.
RUN rm -f db && cat db.dump.sql | sqlite3 db

ENTRYPOINT ["chill"]
