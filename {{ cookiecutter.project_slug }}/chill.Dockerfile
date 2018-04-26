FROM chill as chill

COPY . /usr/run/

WORKDIR /usr/run

# Remove and recreate the db from the db.dump.sql.  The db file is usually
# masked by a bind mount anyways when developing.
RUN rm -f db && cat db.dump.sql | sqlite3 db

ENTRYPOINT ["chill"]
