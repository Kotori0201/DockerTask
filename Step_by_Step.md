# Setup some alias for current_user ubuntu

```bash
alias c='clear'
alias sysstatus='sudo systemctl status'
alias sysrestart='sudo systemctl restart'
alias edit='sudo nano'
```

# Preconfig
## IP address and edit /etc/hosts
```bash
192.168.56.110 server-A
192.168.56.120 server-B
192.168.56.130 server-C
192.168.56.140 server-D
```
## Change hostname for 4 server
```bash
sudo hostnamectl set-hostname server-A
sudo hostnamectl set-hostname server-B
sudo hostnamectl set-hostname server-C
sudo hostnamectl set-hostname server-D
```

## Create user devops2024
```bash
sudo useradd -m devops2024
```

## Shortcut SSH
```bash
nano /.ssh/config
Host A
    HostName server-A
    User devops2024
    IdentityFile ~/.ssh/id_rsa
    Port 8080
Host B
    HostName server-B
    User devops2024
    IdentityFile ~/.ssh/id_rsa
    Port 8080
Host C
    HostName server-C
    User devops2024
    IdentityFile ~/.ssh/id_rsa
    Port 8080
Host D
    HostName server-D
    User devops2024
    IdentityFile ~/.ssh/id_rsa
    Port 8080
```



# Install Docker in Ubuntu

## First, update your existing list of packages
```bash
sudo apt-get update
```

## Next, install a few prerequisite packages which let apt use packages over HTTPS:
```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```
## Then add the GPG key for the official Docker repository to your system
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

## Add the Docker repository to APT sources:
```bash
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
```

## Finally, install Docker
```bash
sudo apt install docker-ce
```

## Verify that Docker is installed correctly
```bash
sudo systemctl status docker
```

## Executing the Docker Command Without Sudo

```bash
sudo usermod -aG docker $(whoami)
```

[Reference](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)

# Setup Docker private registry
## Docker registry là gì?


## Self-host Docker PRIVATE Registry service on server B expose port 5555
``Hiểu đơn giản thì là chạy 1 container registry ở port 5555``

### Install Docker Registry
```bash
docker run -d -p 5555:5000 --name local-registry registry:2
```

### Tag and Push an image to registry
```bash
docker tag nginx:latest localhost:5555/nginx:latest
docker push localhost:5555/nginx:latest

docker tag nginx:latest 192.168.56.120:5555/nginx:latest
docker push 192.168.56.120:5555/nginx:latest
```

### Pull image from registry
```bash
docker pull localhost:5555/nginx:latest
docker pull 192.168.56.120:5555/nginx:latest
```

[Reference](https://k21academy.com/docker-kubernetes/how-to-set-up-your-own-local-docker-registry-a-step-by-step-guide/)

[Reference](https://www.baeldung.com/ops/docker-push-image-self-hosted-registry)

Sửa lỗi: "[http: server gave HTTP response to HTTPS client](https://stackoverflow.com/questions/49674004/docker-repository-server-gave-http-response-to-https-client)"



# Task 4: DockerFile
```
From server A build image and push to Docker Registry on server B with the following image requirements:

Base image: Ubuntu 20.04 (If an error occurs, you can change to another version)

Install Nginx and configure to print "Hello DO2 team" on the main page. Access /v1 prints "Version 1", /v2 prints "Version 2", Logs are recorded in 2 files access.log and error.log

At the path /home/user/devops2023/ there must be a devops2024.txt file whose main content is the html file of the main page.

Must have DEVOPS environment variable with value "This is DO2 team"

Add a folder from the server to the path /home/user/devops2023/server with arbitrary content

Expose port 2304.

Work directory: /home/do2/workdir/

Do not use root and default users

Has healthcheck to determine the state of Nginx service

Assign labels:
 env: stg
 name: service-test
 Team: do2
```
[Nginx](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04)

## Create Dockerfile
Use dockerfile at [Dockerfile](Dockerfile)

Use nginx.conf at [nginx.conf](nginx.conf)
## Build image
```bash
sudo docker build -t ta-images .
```

## Push image to self-hosted registry at server B
```bash
docker tag ta-images 192.168.56.120:5555/ta-images:latest
docker push 192.168.56.120:5555/ta-images:latest
```

# Task 5: From server A run command to create a container on server C from the image just created by pulling from the Docker Registry service
```
From server A run command to create a container on server C from the image just created by pulling from the Docker Registry service

Inspect container just created and interpreted. Then clean up the newly created container
```
## Way 1: Using SSH
ssh user@host '**command**'

## Way 2: Using docker daemon
[Reference](https://dockerlabs.collabnix.com/beginners/components/daemon/access-daemon-externally.html)
## Way 3: Using docker context
### Create a context
```bash
docker context create [context-name] --docker "host=tcp://[ip or dns]:8080"
# Because i created shortcut ssh, so i can use "server-B"
docker context create remote-B --docker "host=ssh://B"
docker context create remote-C --docker "host=ssh://C"
docker context create remote-D --docker "host=ssh://D"
```

### Use context
```bash
docker context use [context-name]

#If you want to back default context
docker context use default
```

## Change context to C
```bash
docker context use remote-C
```

## Pull image from registry
```bash
docker pull 192.168.56.120:5555/ta-images:latest
```

## Run container
```bash
docker run -d -p 2304:2304 --name ta-container 192.168.56.120:5555/ta-images:latest
```

## Inspect container
```bash
docker inspect ta-container
```

# Task 6
```
Present build options to reduce image size and explain & demo (optimize Dockerfile in No.4)
```
## Change base image to alpine

## Remove unnecessary package

## Use multi-stage build

# Task 7
```
From server A run command to create 2 containers with arbitrary images (note that you must push to Docker Registry and pull back) to share the same volume and share files between each other.
    On server B use volume Ephemeral type
    On server C use volume Persistent type 
```

# Task 8
```
Implement a plan to backup data of the 2 containers in No.7 to server D.
```

# Task 9
```
Clean up the 2 containers and data created on server B and C.
Then restore the backup in No.8
    Restore server C on server B 
    Restore server B on server C
```

# Task 10
```
Run on server D
    - Use docker compose for deploy a MySQL 5.7 container with username and password
    - Connect container run by image No.4 to MySQL.
    - Update docker compose to run image No.4 too. 
    - Link: https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu
```

# Task 11
```
Explain networking in Docker and demo each type(at least 3 types).
```

# Project
```
Resource:  MySQL_EAN-basic.zip

Based on one of the two resources above, build the Dockerfile and Docker Compose files needed to deploy the resource.

Output:
    Use registry to distribute images.
    Build images in an optimal way.
    Use network and volume efficiently.
    Draw a project diagram or understand the project to present.
```