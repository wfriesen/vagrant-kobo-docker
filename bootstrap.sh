#!/bin/bash
set -e

echo "Checking for required packages"

dockerexists=$( which docker  | wc -l )
if [ $dockerexists -eq 0 ]; then
  echo "Installing docker"
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

  if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    echo "Adding docker repo"
    codename=$(lsb_release -c | cut -f 2)
    echo "deb https://apt.dockerproject.org/repo ubuntu-$codename main" > /etc/apt/sources.list.d/docker.list
    apt-get update
  fi

  apt-get install -y docker-engine
fi

if [ ! -f /usr/local/bin/docker-compose ]; then
  echo "Installing docker-compose"
  wget --progress=bar:force https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  docker-compose --version
fi

if [ ! -d /home/vagrant/kobo-docker ]; then
  echo "Cloning kobotoolbox/kobo-docker from github"
  git clone https://github.com/kobotoolbox/kobo-docker.git /home/vagrant/kobo-docker/
fi

cd /home/vagrant/kobo-docker/

if [ ! -f /home/vagrant/kobo-docker/docker-compose.yml ]; then
  echo "Creating docker-compose.yml"
  ln -s docker-compose.local.yml docker-compose.yml
fi

echo "Pulling latest docker images"
docker-compose pull

echo "Editing envfile.local.txt"
hostaddress=$(docker-compose run --rm kpi /sbin/ip route|awk '/default/ { print $3 }' | tail -n 1)
sed -i -e "s/^HOST_ADDRESS=$/HOST_ADDRESS=$hostaddress/" \
  -e "s/^ENKETO_API_TOKEN=$/ENKETO_API_TOKEN=8ac3226aa1b8cce11b631088381cfddd5bc05efdd56c0b7b84e92f5624687f32/" \
  -e "s/^DJANGO_SECRET_KEY=$/DJANGO_SECRET_KEY=fa6beea713eb0176462c75f8afd3f44d499c73a5a874696855/" \
  -e "s/^KOBO_SUPERUSER_USERNAME=$/KOBO_SUPERUSER_USERNAME=admin/" \
  -e "s/^KOBO_SUPERUSER_PASSWORD=$/KOBO_SUPERUSER_PASSWORD=admin/" envfile.local.txt
