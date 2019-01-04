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

    docker tag 642bf761dbd9 grame/faust-ready-ubuntu:1604

and then to build the faustservice image:

    docker build -f Dockerfile-faustservice .

And run it:

    docker run -p 8080:8080 57271bc51321
    docker run -d -p 80:8080 grame/faustservice-ubuntu-1604-tris-tuned:002
    docker run -d --restart on-failure -p 80:8080 grame/faustservice-ubuntu-1604-tris-tuned:002

### Log into a running image

First list running containers, then open a terminal into one of the containers:

    docker ps
    docker exec -it <container name> /bin/bash

Copy content to docker container:

    docker cp build.gradle 81d552f72883:/

### Kill a running container

    docker kill <container name>

### Create an image from a running container
The goal is to run an android compilation on the container to force gradle update and speedup subsequent compilations

    docker ps
    docker commit 6da0477dc33c faustservice-ubuntu-1604-tuned:001
    docker push grame/faustservice-ubuntu-1604-tuned:001

## deploy on google cloud

    docker pull grame/faustservice-ubuntu-1604-tuned:001


## nouvelle installation des packages android

    android/tools/bin/sdkmanager "build-tools;28.0.3"  "cmake;3.6.4111459" "extras;android;m2repository" "ndk-bundle" "patcher;v4" "platform-tools" "platforms;android-25"  "platforms;android-27" "tools" 

build-tools;25.0.3          | 25.0.3       | Android SDK Build-Tools 25.0.3 | build-tools/25.0.3/         
  build-tools;28.0.3          | 28.0.3       | Android SDK Build-Tools 28.0.3 | build-tools/28.0.3/         
  cmake;3.6.4111459           | 3.6.4111459  | CMake 3.6.4111459              | cmake/3.6.4111459/          
  emulator                    | 27.1.12      | Android Emulator               | emulator/                   
  extras;android;m2repository | 47.0.0       | Android Support Repository     | extras/android/m2repository/
  ndk-bundle                  | 16.1.4479499 | NDK                            | ndk-bundle/                 
  patcher;v4                  | 1            | SDK Patch Applier v4           | patcher/v4/                 
  platform-tools              | 27.0.1       | Android SDK Platform-Tools     | platform-tools/             
  platforms;android-25        | 3            | Android SDK Platform 25        | platforms/android-25/       
  platforms;android-27        | 1            | Android SDK Platform 27        | platforms/android-27/       
  tools                       | 26.1.1       | Android SDK Tools              | tools/                      


# new stuff

docker run -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/sharedfaustfolder:/tmp/sharedfaustfolder -p 8888:80 grame/faustservice-ubuntu-1604-five-tuned :latest


# On Google Compute Engine

## Creating the VM from scratch

Assuming a VM created from the docker image:  `eu.gcr.io/faust-cloud-208407/faust-cross-osx:latest`

- first we need to pull the `faustservice` image:
    ```
    docker pull grame/faustservice-ubuntu-1604-five-tuned:latest
    ```

- then we need to tag it with the name assumed by faustservice (to be changed)
    ```
    docker tag eu.gcr.io/faust-cloud-208407/faust-cross-osx:latest faust:cross-osx
    ```

- then we need to create the shared folder that will be used to communicate between the two docker images:
    ```
    mkdir /tmp/sharedfaustfolder
    ```

- and finally we can start `faustservice`:
    ```
    docker run -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/sharedfaustfolder:/tmp/sharedfaustfolder -p 80:80 grame/faustservice-ubuntu-1604-five-tuned:latest
    ```
