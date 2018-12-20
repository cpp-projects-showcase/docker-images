#
# http://github.com/cpp-projects-showcase/docker-images/tree/master/centos
#
FROM docker.io/centos:7
MAINTAINER Denis Arnaud <denis.arnaud_github at m4x dot org>

# Docker build time environment variables
ENV container docker
ENV HOME /home/build
ENV LANG en_US.UTF-8
ENV LC_ALL ${LANG}

# Import the Centos-7 GPG key to prevent warnings
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7

# Update of CentOS
RUN yum -y clean all && \
    yum -y upgrade && \
    yum -y install epel-release

# Environment for the `root` user
ADD resources/bashrc /root/.bashrc

# Basic, C++ and Python packages
RUN yum -y install less htop net-tools which sudo man vim \
	git-all wget curl file bash-completion keyutils Lmod \
	zlib-devel bzip2-devel gzip tar rpmconf yum-utils \
	gcc gcc-c++ cmake cmake3 m4 \
	lcov cppunit-devel \
	zeromq-devel czmq-devel \
	boost-devel xapian-core-devel openssl-devel libffi-devel \
	mpich-devel openmpi-devel \
	readline-devel sqlite-devel mariadb-devel \
	soci-mysql-devel soci-sqlite3-devel \
	libicu-devel protobuf-devel protobuf-compiler \
	python-devel \
	python34 python34-pip python34-devel \
	python2-django mod_wsgi \
	geos-devel geos-python \
	doxygen ghostscript "tex(latex)"
RUN pip3 install -U pip pipenv

# Create the `build` user (for the development activities)
RUN adduser build
RUN echo "build ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/build && \
    chmod 0440 /etc/sudoers.d/build

# Configure SSH
RUN mkdir -p $HOME/.ssh && chmod 700 $HOME/.ssh

# Set up the packaging environment for the `build` user
ADD resources/bashrc $HOME/.bashrc
ADD resources/gitconfig $HOME/.gitconfig
ADD resources/vimrc $HOME/.vimrc
RUN chmod 640 $HOME/.bashrc $HOME/.gitconfig $HOME/.vimrc
RUN chown -R build.build $HOME

# Switch to the `build` user
WORKDIR $HOME
USER build

# Python Pyenv and pipenv
RUN git clone https://github.com/pyenv/pyenv.git ${HOME}/.pyenv
RUN source ${HOME}/.bashrc && pyenv install 3.7.1
RUN pip3 install --user -U pipenv

# Entry point
CMD ["/bin/bash"]


