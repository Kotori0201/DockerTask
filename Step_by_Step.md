## Task 1

## Task 2

## Task 3

## Task 4
#### Run the Docker Registry Container port 5555 on B
[Reference](https://k21academy.com/docker-kubernetes/how-to-set-up-your-own-local-docker-registry-a-step-by-step-guide/)

docker run -d -p 5555:5000 --name local-registry registry:2

#### Tag the image to point to local registry on A
docker tag ubuntu:latest serverB-ip:5555/ubuntu:latest
docker tag hello-world:latest serverB-ip:5555/hello-world:latest

#### push and pull test on A
docker push serverB-ip:5555/hello-world
docker pull serverB-ip:5555/hello-world

    Fix lỗi docker http server gave http response to https client
        /etc/docker/daemon.json và thêm "insecure-registries":["serverB-ip:5555"]

    [Reference](https://stackoverflow.com/questions/49674004/docker-repository-server-gave-http-response-to-https-client)
