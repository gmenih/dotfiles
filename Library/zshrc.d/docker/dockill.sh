function dockill () {
    docker kill $(docker container ls -q)
}
