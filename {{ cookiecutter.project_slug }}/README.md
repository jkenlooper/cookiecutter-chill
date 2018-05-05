# {{ cookiecutter.project_name }}

{{ cookiecutter.project_short_description }}

This site is hosted at [{{ cookiecutter.site_protocol }}://{{ cookiecutter.site_domain }}]({{ cookiecutter.site_protocol }}://{{ cookiecutter.site_domain }}).

It is based off of the [chill cookiecutter](https://github.com/jkenlooper/cookiecutter-chill).

## Developing

You should have already setup your machine with a root SSL certificate and
created the necessary files in the web directory. See the section below for the
guide on this.

Run this script if you know what you are doing and are skipping ahead.  
```
git init;

# Add chill image
git submodule add https://github.com/jkenlooper/chill.git chill;
git commit -m "Add chill submodule";
(cd chill; docker build -t chill .)

# Create db file and minimal other files
touch .env .htpasswd;
cat db.dump.sql | sqlite3 db;

# Build and start
docker-compose build;
docker-compose up --no-start;
docker-compose start;

# Did it work?
curl --cacert web/rootCA.pem https://localhost
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

### Configure the website to work with HTTPS for local development

For the staging or sandbox environment use a self-signed SSL certificate.  For production, [certbot](https://certbot.eff.org/) is used to
deploy [Let's Encrypt](https://letsencrypt.org/) certificates.

Follow along with these articles for a more full explanation.

- [How To Create a Self-Signed SSL Certificate for Nginx in Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04)
- [Docs on openssl req](https://www.openssl.org/docs/manmaster/man1/req.html)
- [How to get HTTPS working on your local development environment in 5 minutes](https://medium.freecodecamp.org/how-to-get-https-working-on-your-local-development-environment-in-5-minutes-7af615770eec)

To set it up for HTTPS on localhost using a root SSL certificate that is on your own machine:

Generate a root SSL certificate
`openssl genrsa -des3 -out web/rootCA.key 2048`

Create the rootCA.pem and then import it to Keychain Access and mark it as always trusted.
`openssl req -x509 -new -nodes -key web/rootCA.key -sha256 -days 1024 -out web/rootCA.pem`

Create a certificate key for localhost and save it in web/server.key. Also
create the certificate signing request and save it in web/server.crt.

```
openssl req -new -sha256 -nodes -newkey rsa:2048 \
	-config web/server.csr.cnf \
	-out web/server.csr \
	-keyout web/server.key

openssl x509 -req -CAcreateserial -days 500 -sha256 \
	-in web/server.csr \
	-CA web/rootCA.pem \
	-CAkey web/rootCA.key \
	-out web/server.crt \
	-extfile web/v3.ext
```

Create a strong Diffie-Hellman group.

```
openssl dhparam -out web/dhparam.pem 2048
```

Now the web/server.key, web/server.crt, and web/dhparam.pem will be added to
the web docker container when building. Note that the web/server.key and
web/server.crt are not used in the production nginx conf.

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

## Deployment

This uses [docker-machine commands](https://docs.docker.com/machine/overview/)
to deploy to a [DigitalOcean](https://www.digitalocean.com/) droplet.
A staging or sandbox environment can be set up on your own machine with
[VirtualBox](https://www.virtualbox.org/), but is not set up to use https.  

### Staging with VirtualBox

Test the production deployment on your own machine. Create a virtualbox
host with docker. Note that the https won't work here unless you create a cert
for the staging address.

```
docker-machine create --driver virtualbox \
	 --virtualbox-disk-size 8000 \
	 --virtualbox-memory 2048 \
	 --virtualbox-no-share sandbox-{{ cookiecutter.project_slug }}
```

Connect your shell to the new machine.

```
eval "$(docker-machine env sandbox-{{ cookiecutter.project_slug }})"
```

Build it by passing in the production config

```
docker-compose -f docker-compose.yml -f docker-compose.production.yml build
docker-compose -f docker-compose.yml -f docker-compose.production.yml up --no-start
docker-compose -f docker-compose.yml -f docker-compose.production.yml start
```

### Deploy to DigitalOcean droplet

You will need to set the PAT environment variable to your digital ocean
personal access token.  

Create the server with the name 'dm-{{ cookiecutter.project_slug }}-1' and
connect your shell.  Using the 'dm-**-1' naming to hint that this is a
docker-machine with the iteration or version of 1.  Update as necesary.

```
docker-machine create --driver digitalocean \
	--digitalocean-access-token $PAT \
	dm-{{ cookiecutter.project_slug }}-1
eval "$(docker-machine env dm-{{ cookiecutter.project_slug }}-1)"
```

Build the services.

```
docker-compose -f docker-compose.yml -f docker-compose.production.yml build
```

Note that the certbot container will be renewing the cert every month via cron,
but the registration part still needs to be done.  Set this up now by executing
the `certbot certonly` command in the certbot container.

```
docker-compose -f docker-compose.yml -f docker-compose.production.yml \
  run --rm certbot \
  certbot certonly \
  --webroot --webroot-path /www/root \
  --test-cert \
  --domain {{ cookiecutter.site_domain }}
```

Now that the letsencrypt certs have been made, all the services can be started.

```
docker-compose -f docker-compose.yml -f docker-compose.production.yml up --no-start
docker-compose -f docker-compose.yml -f docker-compose.production.yml start
```
