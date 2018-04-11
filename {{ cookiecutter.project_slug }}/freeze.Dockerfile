FROM ubuntu:16.04 as media

RUN apt-get update && apt-get --yes install imagemagick

# TODO optimize and resize images
COPY ./source-media/ /usr/media/
WORKDIR /usr/media/

# TODO npm run build and create the dist

FROM chill as chill

#COPY --from=media /usr/media/ /usr/run/media/

COPY . /usr/run/
WORKDIR /usr/run/

RUN rm -f db && cat db.dump.sql | sqlite3 db

ENTRYPOINT ["chill"]
