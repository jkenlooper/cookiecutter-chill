# {{ cookiecutter.project_name }}

{{ cookiecutter.project_short_description }}

This site is hosted at [{{ cookiecutter.site_protocol }}://{{ cookiecutter.site_domain }}]({{ cookiecutter.site_protocol }}://{{ cookiecutter.site_domain }}).

It is based off of the [chill cookiecutter](https://github.com/jkenlooper/cookiecutter-chill).

## Developing

TLDR; instructions
```
git init;
git submodule add https://github.com/jkenlooper/chill.git chill;
git commit -m "Add chill submodule";
(cd chill; docker build -t chill .)
touch .env .htpasswd;
cat db.dump.sql | sqlite3 db;
docker-compose build;
docker-compose up --no-start;
docker-compose start;
curl http://localhost:8080
```

To get started you will need Docker.  
[Download and install Docker](https://www.docker.com/community-edition#/download)
on your machine if you haven't already.

In the top level directory (where this README is) you will need to create
a `.env` file to store secret stuff like api keys and other environment
variables.  This file should not be committed to source control. See the 
[Docker documentation for env files](https://docs.docker.com/compose/env-file/)
for more information. If you have no need for it, just create an empty file.

A `.htpasswd` file should also be created in the top level directory.  It is
used by the stats container for protecting that route.  Either edit the NGINX
configs, or create this file with `htpasswd` command.

At the moment the chill docker image hasn't been published.  You can create one from the
latest branch with a Dockerfile ([chill](https://github.com/jkenlooper/chill))
and run `docker build -t chill .`.

### Building the site on your own machine

The _docker-compose.yml_ file will be used by default and is designed to be the
base of the other two configuration files.  The _docker-compose.override.yml_
is used when developing and _docker-compose.production.yml_ is for production.

Run the `docker-compose build` command within the same directory as the
_docker-compose.yml_ to build the docker images.  Note that by default this is
the same as 
`docker-compose -f docker-compose.yml -f docker-compose.override.yml build`

The database needs to be created or there will just be 404 pages.  This can be
done by `cat db.dump.sql | sqlite3 db` if you have sqlite3 installed on your
machine.

After building the docker images, run the `docker-compose up` command and the
site should be available at [http://localhost:8080](http://localhost:8080).

