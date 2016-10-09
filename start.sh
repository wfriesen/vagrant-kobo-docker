#!/bin/bash
set -e

echo "Starting server"
cd /home/vagrant/kobo-docker/
docker-compose up -d

hostaddress=$(docker-compose run --rm kpi /sbin/ip route|awk '/default/ { print $3 }' | tail -n 1)
echo "Server should now be available at http://$hostaddress:8000"
