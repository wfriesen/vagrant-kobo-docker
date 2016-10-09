# vagrant-kobo-docker

A vagrant box to run the [kobo-docker](https://github.com/kobotoolbox/kobo-docker) repository for Kobo Toolbox with Docker.

Installs docker and docker-compose onto a minimal Ubuntu 16.04 box, fills out the local environment file, pulls images and starts the server.

At the end of provisioning, a link will be echo'd to reach the server.

Configures the Kobo superuser with username/password: `admin/admin`.
