FROM sameersbn/ubuntu:latest
MAINTAINER "G.J.R. Timmer <gjr.timmer@gmail.com>"

# Set DOCKER VERSION to 1.11.2 for Synology NAS 6.0.x
ARG DEBIAN_FRONTEND=noninteractive
ARG DOCKER_VERSION=1.11.2
ARG DOCKER_MACHINE_VERSION=0.8.2

# Update Image
RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y ca-certificates wget apt-transport-https vim curl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Install docker
#	- docker-engine
#	- docker-compose
#	- docker-machine
# Runner will access the docker of the host through a binded docker socket
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-`lsb_release -cs` main" | tee /etc/apt/sources.list.d/docker.list && \
	apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
	apt-get update && \
	apt-get install -y gdebi-core python-pip && \
	wget -O docker.deb https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_${DOCKER_VERSION}-0~`lsb_release -cs`_amd64.deb && \
	gdebi -n docker.deb && \
	pip install --upgrade pip && \
	pip install docker-compose && \
	wget -q https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
	chmod +x /usr/bin/docker-machine && \
	apt-get clean && \
	rm -rf docker.deb && \
	rm -rf /var/lib/apt/lists/*
	
# Install GitLab Runner
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | sudo bash &&	\
	apt-get install -y gitlab-ci-multi-runner && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	
# Configure GitLab Runner
	mkdir -p /etc/gitlab-runner/certs && \
	chmod -R 700 /etc/gitlab-runner
	
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
