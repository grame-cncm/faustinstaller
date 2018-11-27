# Creating Docker images for Faust, Faustservice, etc.

## Installing Docker

### Installing Docker on Ubuntu 18.10

    sudo apt-get install docker.io

### Test Docker is working    

    docker -v
    sudo docker ps

### Avoid `sudo`
In order to avoid having to type `sudo` for most docker command you can add yourself to the `docker` group. In principle the `docker` group already exists, no need to create it, just do:

    sudo adduser $USER docker
    newgrp docker (or relog)

### Check docker working without sudo
Now commands should work without sudo. Let's try:

    docker ps

and the a more ambitious test:

    docker run hello-world

### Log into docker account

    docker login

Will ask for identifier and password.

## Building Docker image for Faustservice

### Start with the faustinstaller repo

    git clone https://github.com/grame-cncm/faustinstaller.git

### Build FRU1604 (Faust Ready Ubuntu 1604)

    docker build -f Dockerfile-FRU1604 .

Use this commande to build the Faust Ready Ubuntu 16.04 image. The next step is to tag it:

    docker tag 642bf761dbd9 faust-ready-ubuntu:1604

and then to build the faustservice image:

    docker build -f Dockerfile-faustservice .

And run it:

    docker run -p 8080:8080 57271bc51321
