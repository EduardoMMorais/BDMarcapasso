# This file creates a container to run the calculator
# It can also be used as a guide to build an VM or bare metal installation
# Some commands:
# - Generate the container image:
#  docker image build -t marcapassoml:0.0.10 .
# - Create the container:
#  docker load -i marcapassoml-0.0.10.tar.gz
#  docker container create -p 80:80 --name calculadora marcapassoml:0.0.10
# - Launch the container:
#  docker container start calculadora
# - Stop the container
#  docker container stop calculadora
# - Terminal on container
#  docker exec -i -t calculadora /bin/bash

# We are starting from a Debian Bookworm distro
FROM debian:bookworm-20210816-slim

# Install the packages for the backend
RUN apt-get update && apt-get install -y r-base

# Install R packages
RUN R -e "install.packages(c('dplyr','Rook','parsnip','lightgbm','workflows','yaml','recipes','bonsai'), repos='https://vps.fmvz.usp.br/CRAN/')"

# Create user for the backend
RUN useradd -ms /bin/bash calculator

# Copy backend files
COPY --chown=calculator:calculator backend /home/calculator/

# Install the server for the frontend. Any webserver can be used
RUN apt-get update && apt-get install -y nginx-core \
# forward logs to the docker log collector. Not needed on VM or bare metal
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy frontend files
COPY frontend /usr/share/nginx/html/
# NGINX configuration file. Needs to enable SSI (Server-side Includes) and reverse proxy the "/marcapasso" path
COPY dockerfiles/default.conf /etc/nginx/conf.d/default.conf
# Copy the launcher. On bare metal it is better to create systemd entries or similar
COPY dockerfiles/launcher.sh /home/calculator/launcher.sh

EXPOSE 80
STOPSIGNAL SIGQUIT
CMD "/home/calculator/launcher.sh"