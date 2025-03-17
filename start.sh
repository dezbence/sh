#!/bin/bash

Help() 
{
    echo "Ez egy docker konténer indítását segítő script."
    echo "Használat:"
    echo "$0 KONTÉNER_NEVE [-n] [-DOCKER ARGS]"
    echo 
    echo "options:"
    echo "-h    print this help"
    echo "-n    konténer futtatása nvidia videókártyával"
    exit 1
}

intel()
{
    docker run -it "${@:2}" \
    --device=/dev/dri:/dev/dri \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/dev/dri:/dev/dri:rw" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    $1
}

nvidia()
{
    docker run -it "${@:3}" \
    --runtime=nvidia \
    --gpus all \
    --device=/dev/dri:/dev/dri \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/dev/dri:/dev/dri:rw" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    $1
}

if [ "$#" -eq 0 ]; then
    Help
fi

case $1 in
    -h|--help|-*) Help;;
esac

case $2 in
    -h|--help) Help;;
    -n) nvidia $@; exit 0;;
    *) intel $@; exit 0;;
esac
